class LayerOptions
	_template: (layer) ->
		$("""
			<ul class="options-container">
				<li>
					<div class="key">Name</div>
					<div class="val">
						<input value="#{if layer.name then layer.name}" type="text" class="name">
					</div>
				</li>
				<li>
					<div class="key">Type</div>
					<div class="val">
						<select class="type">
							<option #{if layer.type == c.mapType.collision then 'selected'} value="#{c.mapType.collision}">collision</option>
							<option #{if layer.type == c.mapType.regular then 'selected'} value="#{c.mapType.regular}">regular</option>
						</select>
					</div>
				</li>
				<li>
					<div class="key">Tile Size</div>
					<div class="val">
						<input value="#{if layer.tileSize then layer.tileSize}" type="number" class="tileSize">
					</div>
				</li>
				<li>
					<div class="key">Distance</div>
					<div class="val">
						<input value="#{if layer.distance then layer.distance}" type="number" class="distance">
					</div>
				</li>
				<li>
					<div class="key">Tileset</div>
					<div class="val">
						<select class="tileset">
							<option>some tileset</option>
							<option>another tileset</option>
							<option>a third tileset</option>
						</select>
					</div>
				</li>
				<li>
					<div class="key">zIndex</div>
					<div class="val">
						<input value="#{if layer.zIndex then layer.zIndex}" type="number" class="zIndex">
					</div>
				</li>
			</ul>
		""")


	constructor: () ->
		@el = $('#selected-options')
		@bindEvents()

	bindEvents: =>
		@el.on 'change', '.name', @updateLayerName
		@el.on 'change', '.type', @updateLayerType
		@el.on 'change', '.tileSize', @updateLayerTileSize
		@el.on 'change', '.distance', @updateLayerDistance
		@el.on 'change', '.tileset', @updateLayerTileset
		@el.on 'change', '.zIndex', @updateLayerZindex

	load: (@layer) =>
		unless @layer then throw 'LayerOptions requires a layer'

		@el.html @_template(layer)

	unload: (layer) =>
		unless layer == @layer then return

		@layer = null
		@el.html('')

	updateLayerName: (e) =>
		changed = $(e.target)
		@layer.name = changed.val()
		@layer.listEl.trigger('updateName')

	updateLayerType: (e) =>
		changed = $(e.target)
		@layer.type = parseInt(changed.val(), 10)

	updateLayerTileSize: (e) =>
		changed = $(e.target)
		@layer.tileSize = parseInt(changed.val(), 10)

	updateLayerDistance: (e) =>
		changed = $(e.target)
		@layer.distance = parseInt(changed.val(), 10)

	updateLayerTileset: (e) =>
		@layer.tileSet = $(e.target).val()

	updateLayerZindex: (e) =>
		changed = $(e.target)
		@layer.zIndex = parseInt(changed.val(), 10)