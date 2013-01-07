class LevelOptions
	constructor: () ->
		@el = $('#level-options')
		@bindEvents()

	bindEvents: =>
		@el.on 'change', '.tileSize', @updateLevelTileSize
		@el.on 'change', '.x, .y', @updateLevelSize

	load: (@level) =>
		unless @level then throw 'LevelOptions requires a level'

		@el.find('.tileSize').val(@level.tileSize)
		@el.find('.x').val(@level.size.x)
		@el.find('.y').val(@level.size.y)

	updateLevelTileSize: (e) =>
		changed = $(e.target)
		@level.tileSize = parseInt(changed.val(), 10)

		@level.setPxSize()

		window.buzz.renderer.updateLevel()

	updateLevelSize: (e) =>
		@level.size =
			x: parseInt(@el.find('.x').val(), 10)
			y: parseInt(@el.find('.y').val(), 10)

		@level.setPxSize()

		window.buzz.renderer.updateLevel()