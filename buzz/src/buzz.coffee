#@codekit-prepend '../../src/map.coffee';
#@codekit-prepend '../../src/loader.coffee';

#@codekit-prepend 'init.coffee';

#@codekit-prepend 'buzzGame.coffee';
#@codekit-prepend 'layerList.coffee';
#@codekit-prepend 'layer.coffee';
#@codekit-prepend 'layerOptions.coffee';

$(document).ready ->
	window.buzz =
		layers: {}
		layerOptions: new LayerOptions()
		Layer: Layer
		Loader: Loader

	$.ajax
		url: 'config.json'
		success: (config) ->
			unless config && config.resources
				console.error 'Set up config.json (in the buzz directory) with appropriate values. An appropriate config file looks something like this:', {"resourcesPrefix": "../", "resources": {"box": "img/box.png", "bg tiles": "img/bgtiles.png", "fg tiles": "img/fgtiles.png", "stars": "img/stars.gif"}}

			new window.buzz.Loader kicker, config.resources, config.resourcesPrefix

			window.buzz.resources = config.resources

	kicker =
		ready: ->
			console.log 'all loaded', window.buzz.resources
			new LayerList()