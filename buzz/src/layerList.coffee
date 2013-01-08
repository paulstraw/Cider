class LayerList
	_layerTemplate: (layer) ->
		$("""
			<li data-layer-id="#{layer.id}" class="layer group">
				<input type="checkbox" class="toggle-visibility" #{if layer.visible then 'checked' else ''}>
				<span class="name">#{layer.name}</span>
				<button class="delete">&times;</button>
			</li>
		""")

	constructor: () ->
		@el = $('#layer-list')

		@el.find('ul').sortable()

		@bindEvents()


	bindEvents: =>
		@el.on 'click', '.layer', @toggleCurrentLayer
		@el.on 'click', '.layer .delete', @deleteLayer
		@el.on 'click', '#add-layer', @addLayer
		@el.on 'change', '.layer .toggle-visibility', @toggleLayerVisibility
		@el.on 'click', '.layer .toggle-visibility', @stopPropagation


	stopPropagation: (e) ->
		e.stopPropagation()


	toggleCurrentLayer: (e) =>
		layerEl = $(e.currentTarget)
		return if layerEl.hasClass 'current'

		layerEl.addClass('current').siblings().removeClass('current')

		layer = window.buzz.layers[parseInt(layerEl.data('layer-id'), 10)]
		window.buzz.currentLayer = layer
		window.buzz.layerOptions.load layer

		window.buzz.renderer.switchLayer()


	deleteLayer: (e) =>
		e.stopPropagation()

		layerEl = $(e.currentTarget).parent()
		layerId = parseInt(layerEl.data('layer-id'), 10)
		layer = window.buzz.layers[layerId]

		window.buzz.layerOptions.unload layer
		window.buzz.currentLayer = null
		delete window.buzz.layers[layerId]

		window.buzz.renderer.switchLayer()
		window.buzz.renderer.renderLayers()

		layerEl.off()
		layerEl.slideUp 180, ->
			layerEl.remove()


	toggleLayerVisibility: (e) =>
		clicked = $(e.currentTarget)
		layerEl = clicked.parent()
		layer = window.buzz.layers[parseInt(layerEl.data('layer-id'), 10)]

		layer.visible = !!clicked.prop('checked')

		window.buzz.renderer.renderLayers()


	addLayer: (e, data, options) =>
		if data && options then options.data = data

		layer = new window.buzz.Layer(options)
		listEl = @_layerTemplate(layer)

		listEl.on 'updateName', ->
			listEl.find('.name').text layer.name

		layer.listEl = listEl
		window.buzz.layers[layer.id] = layer

		@el.find('ul').append listEl