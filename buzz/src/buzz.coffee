#@codekit-prepend '../../src/map.coffee';
#@codekit-prepend '../../src/level.coffee';
#@codekit-prepend '../../src/loader.coffee';

#@codekit-prepend 'init.coffee';

#@codekit-prepend 'tileCursor.coffee';
#@codekit-prepend 'tilePicker.coffee';
#@codekit-prepend 'renderer.coffee';
#@codekit-prepend 'buzzGame.coffee';
#@codekit-prepend 'layerList.coffee';
#@codekit-prepend 'layer.coffee';
#@codekit-prepend 'layerOptions.coffee';
#@codekit-prepend 'levelOptions.coffee';

$(document).ready ->
	window.buzz =
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
				console.error 'Set up config.json (in the buzz directory) with appropriate values. An appropriate config file looks something like this:', {"resourcesPrefix": "../", "resources": {"box": "img/box.png", "bg tiles": "img/bgtiles.png", "fg tiles": "img/fgtiles.png", "stars": "img/stars.gif"}}

			new Loader kicker, config.resources, config.resourcesPrefix

			window.buzz.resources = config.resources

	kicker =
		ready: ->
			console.log 'all loaded', window.buzz.resources
			window.buzz.layerList = new LayerList()

			window.buzz.levelOptions.load window.buzz.level

			window.buzz.renderer.loadLevel window.buzz.level