class TileCursor
	constructor: (@painter = false) ->
		@el = $('<div class="cursor">')
		@bindEvents()


	bindEvents: =>
		if @painter
			@el.on 'mousedown', @startPainting
			@el.on 'mouseup', @stopPainting
			$(document).on 'keydown', @handleDocKeydown
			$(document).on 'keyup', @handleDocKeyup


	startPainting: (e) =>
		unless e.which == 1 then return

		if @picking && window.buzz.currentLayer?
			@pickTile()
		else
			@painting = true
			@paint()

	pickTile: =>
		unless window.buzz.currentLayer? then return

		layer = window.buzz.currentLayer
		tileSize = layer.tileSize
		elPos = @el.position()
		zoom = window.buzz.zoom

		tileRow = elPos.top / zoom / tileSize
		tileCol = elPos.left / zoom / tileSize
		index = if layer.data[tileRow] && layer.data[tileRow][tileCol] then layer.data[tileRow][tileCol] else 0

		if index == 0
			@setTile 0
			return

		if layer.tileset == 'cider collision'
			img = new Image
			img.src = 'img/collision.png'
		else
			img = window.buzz.resources[layer.tileset]

		if layer.type == c.mapType.collision
			tilesPerRow = img.width / 32
		else
			tilesPerRow = img.width / layer.tileSize

		tileRow = Math.ceil((index) / tilesPerRow) - 1
		colTemp = index % tilesPerRow
		tileCol = (if colTemp == 0 then tilesPerRow else colTemp) - 1

		if layer.type == c.mapType.collision
			offX = - (tileCol * 32) * (layer.tileSize / 32)
			offY = - (tileRow * 32) * (layer.tileSize / 32)
		else
			offX = - (tileCol * layer.tileSize)
			offY = - (tileRow * layer.tileSize)

		@setTile index, offX, offY


	paint: (e) =>
		unless @painting && @index? && window.buzz.currentLayer? then return

		layer = window.buzz.currentLayer
		tileSize = layer.tileSize
		elPos = @el.position()
		zoom = window.buzz.zoom

		row = elPos.top / zoom / tileSize
		col = elPos.left / zoom / tileSize

		layer.data[row] ?= []
		layer.data[row][col] = @index

		window.buzz.renderer.renderLayer layer


	stopPainting: (e) =>
		# For some reason, setting ANYTHING (even a random variable like `foo`) to false here messes stuff up. Other falsy values work. So confused.
		@painting = 0


	setSize: (size) =>
		@size = size

		es = @el[0].style
		es.width = "#{size}px"
		es.height = "#{size}px"


	moveToClosest: (x, y) =>
		es = @el[0].style
		es.left = "#{Math.floor(x / @size) * @size}px"
		es.top = "#{Math.floor(y / @size) * @size}px"

		if @painting then @paint()


	setTile: (@index, xPos, yPos) =>
		unless @index? then return

		layer = window.buzz.currentLayer

		if @index == 0
			@el.css
				backgroundPosition: '9999px 9999px'
		else
			# Extra - 1 is to account for borders, it doesn't actually effect output.
			if layer.type == c.mapType.collision
				@el.css
					backgroundPosition: "#{xPos * (layer.tileSize / 32) - 1}px #{yPos * (layer.tileSize / 32) - 1}px"
			else
				@el.css
					backgroundPosition: "#{xPos - 1}px #{yPos - 1}px"


	setTileset: (setName) =>
		# TODO don't match against strings, that's just silly.
		if !setName || setName == 'Select…'
			@el.css
				backgroundImage: ''
			return

		@index = 1

		if setName == 'cider collision'
			@tileset = {src: 'img/collision.png'}
			@el.css 'background-size', 256 * (window.buzz.currentLayer.tileSize / 32)
		else
			@tileset = window.buzz.resources[setName]
			@el.css 'background-size', 'auto'

		@el.css
			backgroundImage: "url(#{@tileset.src})"
			# It's fine to set this statically, since we always reset to index 1 when switching
			backgroundPosition: '0 0'

	handleDocKeydown: (e) =>
		if e.which in [17, 91]
			@picking = true
			@el.addClass('picking')

	handleDocKeyup: (e) =>
		if e.which in [17, 91]
			@picking = false
			@el.removeClass('picking')