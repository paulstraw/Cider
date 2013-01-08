#@codekit-prepend '../../COPYING.coffee';
#@codekit-prepend '../../src/map.coffee';
#@codekit-prepend '../../src/level.coffee';
#@codekit-prepend '../../src/loader.coffee';

#@codekit-prepend 'init.coffee';

#@codekit-prepend 'tileCursor.coffee';
#@codekit-prepend 'tilePicker.coffee';
#@codekit-prepend 'renderer.coffee';
#@codekit-prepend 'layerList.coffee';
#@codekit-prepend 'layer.coffee';
#@codekit-prepend 'layerOptions.coffee';
#@codekit-prepend 'levelOptions.coffee';
#@codekit-prepend 'exporter.coffee';
#@codekit-prepend 'importer.coffee';

$(document).ready ->
	window.buzz =
		version: 0.1
		layers: {}
		zoom: 1
		layerOptions: new LayerOptions()
		levelOptions: new LevelOptions()
		level: new Level()
		renderer: new Renderer()
		tilePicker: new TilePicker()
		Layer: Layer

	$.ajax
		url: 'config.json'
		success: (config) ->
			unless config && config.resources
				throw new Error 'Set up config.json (in the buzz directory) with appropriate values. See readme.md for an example, and other Buzz documentation.'

			new Loader kicker, config.resources, config.resourcesPrefix

			window.buzz.resources = config.resources

	kicker =
		ready: ->
			window.buzz.layerList = new LayerList()

			window.buzz.levelOptions.load window.buzz.level

			window.buzz.renderer.loadLevel window.buzz.level

			$('#export-trigger').on 'click', ->
				new Exporter

			$('#import-trigger').on 'click', ->
				new Importer