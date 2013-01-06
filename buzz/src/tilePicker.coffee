class TilePicker
	constructor: () ->
		@el = $('#tile-picker')
		$('body').append @el

		@inner = @el.find('.inner')
		@img = @el.find('img')

		@cursor = new TileCursor
		@inner.append @cursor.el

		@bindEvents()

	bindEvents: =>
		$(document).on 'keypress', @maybeShowOrHide
		@el.on 'click', @hide
		@img.on 'mousemove', @handleImgMousemove
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
		@visible = true
		@cursor.setSize window.buzz.currentLayer.tileSize

		setName = window.buzz.currentLayer.tileset
		if setName == 'cider collision'
			@setImg = new Image
			@setImg.src = 'img/collision.png'
		else
			@setImg = window.buzz.resources[setName]

		@img[0].src = @setImg.src
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

		tilesPerRow = @setImg.width / window.buzz.currentLayer.tileSize
		cursorPos = @cursor.el.position()
		currentColumn = (cursorPos.left / window.buzz.currentLayer.tileSize) + 1
		currentRow = (cursorPos.top / window.buzz.currentLayer.tileSize)

		index = (tilesPerRow * currentRow) + currentColumn

		window.buzz.renderer.cursor.setTile(index, -cursorPos.left, -cursorPos.top)

		setTimeout @hide, 60