# TODO this is pretty fragile, and relies too much on regex. Not sure what I can do about that, but some cleanup would be really good.
class Importer
	constructor: () ->
		@el = $('#import-dialog')
		@el.on 'click', '.cancel', @remove
		@el.on 'click', '.import', @import

		@render()

	render: =>
		@el.fadeIn 120

	remove: =>
		@el.fadeOut 120, =>
			@el.find('textarea').val ''

	import: =>
		data = @el.find('textarea').val()
		level = JSON.parse(data.match(/c\.Level\((\{[^}]+\})/)[1] + '}')

		lOpts = $('#level-options')
		lOpts.find('.tileSize').val level.tileSize
		lOpts.find('.x').val level.size.x
		lOpts.find('.y').val level.size.y

		levelObject = window.buzz.level
		levelObject.size.x = level.size.x
		levelObject.size.y = level.size.y
		levelObject.tileSize = level.tileSize
		levelObject.setPxSize()

		# Remove old layers.
		$('#layer-list').find('.delete').trigger('click')

		for map in data.match(/c\.Map\((\[[^\n]+\],\n\{[^\}]+\})/g)
			[fullMatch, data, options] = map.match(/c\.Map\((\[[^\n]+\]),\n(\{[^\}]+\})/)
			data = JSON.parse(data)
			options = JSON.parse(options)

			if options.type != c.mapType.collision
				options.tilesetUrl = window.buzz.resources[options.tileset].src

			window.buzz.layerList.addLayer(null, data, options)


		window.buzz.renderer.updateLevel()
		window.buzz.renderer.renderLayers()

		setTimeout =>
			@remove()
		, 60