class TilePicker
	constructor: () ->
		@el = $('#tile-picker')
		$('body').append @el

		@inner = @el.find('.inner')
		@img = @el.find('.tiles')

		@cursor = new TileCursor
		@inner.append @cursor.el

		@bindEvents()

	bindEvents: =>
		$(document).on 'keypress', @maybeShowOrHide
		@el.on 'click', @hide
		@img.on 'mousemove', @handleImgMousemove
		@el.on 'click', '.delete', @handleDeleteClick
		@cursor.el.on 'click', @handleCursorClick


	maybeShowOrHide: (e) =>
		return if e.target.tagName in ['INPUT', 'SELECT', 'TEXTAREA'] || e.which != 32

		unless window.buzz.currentLayer && window.buzz.currentLayer.tileset
			alert 'Select a layer and choose its tileset before picking a tile.'
			return

		if @visible
			@hide()
		else
			@show()

	show: =>
		layer = window.buzz.currentLayer
		size = if layer.type == c.mapType.collision then 32 else layer.tileSize
		@visible = true
		@cursor.setSize size

		setName = layer.tileset
		if setName == 'cider collision'
			@setImg = new Image
			@setImg.src = 'img/collision.png'
		else
			@setImg = window.buzz.resources[setName]

		@img[0].src = @setImg.src

		@el.find('.delete').css
			left: - layer.tileSize
			width: layer.tileSize
			height: layer.tileSize

		rCursorOff = window.buzz.renderer.cursor.el.offset()
		@inner.css
			top: rCursorOff.top
			left: rCursorOff.left + size

		console.log rCursorOff, rCursorOff.top, @img[0].height, $(window).height()
		if rCursorOff.top + @img[0].height > $(window).innerHeight()
			overflowDistance = (rCursorOff.top + @img[0].height) - $(window).innerHeight()
			@zoomFactor = 1 - (overflowDistance / @img[0].height)

			@inner.css
				transform: "scale(#{@zoomFactor})"
				transformOrigin: 'left top'
		else
			@zoomFactor = 1
			@inner.css('transform', "scale(1)")

		@el.fadeIn 60

	hide: () =>
		@visible = false
		@el.fadeOut 60

	handleImgMousemove: (e) =>
		if e.target == @cursor.el[0] then return

		@cursor.moveToClosest e.offsetX, e.offsetY

	handleCursorClick: (e) =>
		e.stopPropagation()

		layer = window.buzz.currentLayer

		if layer.type == c.mapType.collision
			tilesPerRow = @setImg.width / 32
			cursorPos = @cursor.el.position()
			currentColumn = (cursorPos.left / 32) + 1
			currentRow = (cursorPos.top / 32)
		else
			tilesPerRow = @setImg.width / layer.tileSize
			cursorPos = @cursor.el.position()
			if @zoomfactor != 1
				cursorPos.left = Math.round(cursorPos.left / @zoomFactor)
				cursorPos.top = Math.round(cursorPos.top / @zoomFactor)
			console.log @zoomFactor
			currentColumn = (cursorPos.left / layer.tileSize) + 1
			currentRow = (cursorPos.top / layer.tileSize)

		index = (tilesPerRow * currentRow) + currentColumn

		window.buzz.renderer.cursor.setTile(index, -cursorPos.left, -cursorPos.top)

		setTimeout @hide, 60

	handleDeleteClick: (e) =>
		e.stopPropagation()

		window.buzz.renderer.cursor.setTile(0)

		setTimeout @hide, 60