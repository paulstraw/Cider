class LayerOptions
	_template: (layer) ->
		$("""
			<h2>Layer Options</h2>
			<ul class="options-container">
				<li class="group">
					<div class="key">Name</div>
					<div class="val">
						<input value="#{if layer.name then layer.name}" type="text" class="name">
					</div>
				</li>
				<li class="group">
					<div class="key">Type</div>
					<div class="val">
						<select class="type">
							<option #{if layer.type == c.mapType.collision then 'selected'} value="#{c.mapType.collision}">collision</option>
							<option #{if layer.type == c.mapType.regular then 'selected'} value="#{c.mapType.regular}">regular</option>
						</select>
					</div>
				</li>
				<li class="group">
					<div class="key">Tile Size</div>
					<div class="val">
						<input value="#{if layer.tileSize then layer.tileSize}" type="number" class="tileSize">
					</div>
				</li>
				<li class="group">
					<div class="key">Distance</div>
					<div class="val">
						<input value="#{if layer.distance then layer.distance}" type="number" class="distance">
					</div>
				</li>
				<li class="tileset-container group">
					<div class="key">Tileset</div>
					<div class="val">
						<select class="tileset"></select>
					</div>
				</li>
				<li class="group">
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

		if @layer.type == c.mapType.collision
			@el.find('.tileset-container').hide()

		tilesetHtml = _.reduce window.buzz.resources, (memo, resource, name) =>
			return memo + "<option #{if @layer.tilesetUrl == resource.src then 'selected'} value=\"#{resource.src}\">#{name}</option>"
		, ''
		@el.find('.tileset').html(tilesetHtml)

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
		type = parseInt(changed.val(), 10)

		if type == c.mapType.collision
			$('.tileset-container').hide()
			@layer.tileset = ''
			@layer.tilesetUrl = 'img/collision.png'
		else
			$('.tileset-container').show()

		@layer.type = type

	updateLayerTileSize: (e) =>
		changed = $(e.target)
		@layer.tileSize = parseInt(changed.val(), 10)

	updateLayerDistance: (e) =>
		changed = $(e.target)
		@layer.distance = parseInt(changed.val(), 10)

	updateLayerTileset: (e) =>
		@layer.tileset = @el.find(".tileset option[value=\"#{$(e.target).val()}\"]").text()
		@layer.tilesetUrl = $(e.target).val()

	updateLayerZindex: (e) =>
		changed = $(e.target)
		@layer.zIndex = parseInt(changed.val(), 10)