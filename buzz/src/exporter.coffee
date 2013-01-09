class Exporter
	_mapTemplate: (memo, layer) =>
		memo + """
new c.Map(#{JSON.stringify(layer.data)},
{"name": "#{layer.name}", "type": #{layer.type}, "tileSize": #{layer.tileSize}, "distance": #{layer.distance}, "zIndex": #{layer.zIndex}, "tileset": "#{layer.tileset}"}),
		"""

# {"name": "#{layer.name}", "type": #{layer.type}, "tileSize": #{layer.tileSize}, "distance": #{layer.distance}, "zIndex": #{layer.zIndex}, "tileset": #{if layer.type == c.mapType.collision then null else "\"#{layer.tileset}\""}}),
	_dataTemplate: (level, layers) =>
		mapData = _.reduce layers, @_mapTemplate, ''

		"""
new c.Level({"tileSize": #{level.tileSize}, "size": {"x": #{level.size.x}, "y": #{level.size.y}},
"maps": [#{mapData}]
});
		"""

	constructor: () ->
		@el = $('#export-dialog')
		@el.on 'click', '.done', @remove
		@el.on 'focus', 'textarea', (e) ->
			setTimeout ->
				$(e.currentTarget).select()
			, 0

		@data = @generateData()
		if @data then @render()

	render: =>
		@el.find('textarea').html @data
		@el.fadeIn 120

	remove: =>
		@el.fadeOut 120, =>
			@el.find('textarea').val ''

	generateData: =>
		level = window.buzz.level
		layers = window.buzz.layers

		unless Object.keys(layers).length
			alert 'You must create at least one layer to export.'
			return false

		@_dataTemplate level, layers