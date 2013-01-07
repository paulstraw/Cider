class Renderer
	constructor: () ->
		@el = $('#rendering-container')
		@inner = $('#inner')
		@inner.css('transform-origin', 'left top')

		@bindEvents()


	bindEvents: () =>
		@el.on 'mousedown', @handleMousedown
		@el.on 'mouseup', @handleMouseup
		@el.on 'mousemove', @handleMousemove
		@el.on 'contextmenu', @handleContext
		@inner.on 'mousemove', @handleInnerMousemove
		$('#zoom-level').on 'change', @handleZoomChange


	loadLevel: (@level) =>
		unless @level then throw 'Renderer.loadLevel requires a level'

		@levelEl = $('<div id="level-container">')
		@levelEl.css
			width: @level.pxSize.x
			height: @level.pxSize.y

		@inner.html(@levelEl)

		@cursor = new TileCursor(true)
		@inner.append @cursor.el

		@cursor.setSize(@level.tileSize)

		@renderLayers()

	updateLevel: =>
		unless window.buzz.level then return

		level = window.buzz.level

		@levelEl.css
			width: level.pxSize.x
			height: level.pxSize.y

		@cursor.setSize(if window.buzz.currentLayer? then window.buzz.currentLayer.tileSize else level.tileSize)


	renderLayers: =>
		@el.find('#level-container').html('')
		@renderLayer(layer) for id, layer of window.buzz.layers


	renderLayer: (layer) =>
		if layer.visible
			$('#level-container').append layer.render()

	handleContext: (e) =>
		e.preventDefault()

	handleMousedown: (e) =>
		if e.which == 3
			@dragStart =
				x: e.clientX
				y: e.clientY
				origX: @inner.offset().left
				origY: @inner.offset().top

	handleMousemove: (e) =>
		unless @dragStart then return

		delta =
			x: e.clientX - @dragStart.x
			y: e.clientY - @dragStart.y

		@inner[0].style.top = "#{@dragStart.origY + delta.y}px"
		@inner[0].style.left = "#{@dragStart.origX + delta.x}px"

	handleMouseup: (e) =>
		@dragStart = null

	handleZoomChange: (e) =>
		zoom = $(e.target).val()
		window.buzz.zoom = zoom
		@inner.css('transform', "scale(#{zoom})")

	handleInnerMousemove: (e) =>
		if @dragStart then return
		if e.target == @cursor.el[0] then return

		@cursor.moveToClosest e.offsetX, e.offsetY

	switchLayer: =>
		if window.buzz.currentLayer
			layer = window.buzz.currentLayer
			@cursor.setSize(layer.tileSize)
			@cursor.setTileset(layer.tileset)
		else
			@cursor.setSize(@level.tileSize)
			@cursor.setTileset(null)