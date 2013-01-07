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
		@visible = true
		@cursor.setSize if layer.type == c.mapType.collision then 32 else layer.tileSize

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

		@inner.css
			marginTop: - (@setImg.height / 2)
			marginLeft: - (@setImg.width / 2)

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
			currentColumn = (cursorPos.left / layer.tileSize) + 1
			currentRow = (cursorPos.top / layer.tileSize)

		index = (tilesPerRow * currentRow) + currentColumn

		window.buzz.renderer.cursor.setTile(index, -cursorPos.left, -cursorPos.top)

		setTimeout @hide, 60

	handleDeleteClick: (e) =>
		e.stopPropagation()

		window.buzz.renderer.cursor.setTile(0)

		setTimeout @hide, 60