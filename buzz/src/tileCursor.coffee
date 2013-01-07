class TileCursor
	constructor: (@painter = false) ->
		@el = $('<div class="cursor">')
		@bindEvents()


	bindEvents: =>
		if @painter
			@el.on 'mousedown', @startPainting
			@el.on 'mouseup', @stopPainting


	startPainting: (e) =>
		unless e.which == 1 then return

		@painting = true
		@paint()


	paint: (e) =>
		unless @painting && @index? && window.buzz.currentLayer? then return

		layer = window.buzz.currentLayer
		tileSize = layer.tileSize
		elPos = @el.position()
		zoom = window.buzz.zoom

		row = elPos.top / zoom / tileSize
		col = elPos.left / zoom / tileSize

		if layer.data[row]
			layer.data[row][col] = @index
		else
			layer.data[row] = []
			layer.data[row][col] = @index

		window.buzz.renderer.renderLayers()


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