uniqueLayerId = 1

class Layer
	constructor: (options) ->
		@name = 'New Layer'
		@type = c.mapType.regular
		@distance = 1
		@zIndex = 1
		@tileSize = 32
		@visible = true
		@id = uniqueLayerId++

		@el = $('<div class="layer">')
		@data = []

		c.extend this, options

	render: =>
		unless @tileset then return

		if @tileset == 'cider collision'
			img = new Image
			img.src = 'img/collision.png'
		else
			img = window.buzz.resources[@tileset]

		mapContainer = document.createElement 'div'
		tilesPerRow = img.width / @tileSize

		mapContainer.className = 'cider-map'
		mapContainer.id = "cider-layer-#{@id}"
		mcs = mapContainer.style
		mcs.position = 'absolute'
		mcs.left = '0px'
		mcs.top = '0px'

		for row, i in @data
			if row
				for col, j in row
					@renderTile mapContainer, row[j], i, j, img, tilesPerRow

		return mapContainer

	renderTile: (mapContainer, tile, row, col, img, tilesPerRow) =>
		# If no tile was passed, we don't need to draw anything
		unless tile then return

		tileSize = @tileSize
		xPos = col * tileSize
		yPos = row * tileSize

		tileContainer = document.createElement 'div'
		tcStyle = tileContainer.style

		currentRow = Math.ceil((tile) / tilesPerRow) - 1
		currentColumn = tile % tilesPerRow - 1
		offX = - (currentColumn * tileSize)
		offY = - (currentRow * tileSize)

		tcStyle.width = tcStyle.height = "#{tileSize}px"
		tcStyle.position = 'absolute'
		tcStyle.left = "#{xPos}px"
		tcStyle.top = "#{yPos}px"
		tcStyle.backgroundImage = "url(#{img.src})"
		tcStyle.backgroundPosition = "#{offX}px #{offY}px"
		tcStyle.zIndex = @zIndex || 1

		mapContainer.appendChild tileContainer