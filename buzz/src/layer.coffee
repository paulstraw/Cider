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

		if @type == c.mapType.collision
			tilesPerRow = img.width / 32
		else
			tilesPerRow = img.width / @tileSize

		mapContainer.className = 'cider-map'
		mapContainer.id = "cider-layer-#{@id}"
		mcs = mapContainer.style
		mcs.position = 'absolute'
		mcs.zIndex = @zIndex || 1
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
		colTemp = tile % tilesPerRow
		currentColumn = (if colTemp == 0 then tilesPerRow else colTemp) - 1

		if @type == c.mapType.collision
			offX = - (currentColumn * 32) * (tileSize / 32)
			offY = - (currentRow * 32) * (tileSize / 32)
		else
			offX = - (currentColumn * tileSize)
			offY = - (currentRow * tileSize)

		tcStyle.width = tcStyle.height = "#{tileSize}px"
		tcStyle.left = "#{xPos}px"
		tcStyle.top = "#{yPos}px"
		tcStyle.backgroundImage = "url(#{img.src})"
		tcStyle.zIndex = @zIndex || 1

		if @type == c.mapType.collision
			tcStyle.backgroundSize =  "#{256 * (tileSize / 32)}px"
			tcStyle.backgroundPosition = "#{offX}px #{offY}px"
		else
			tcStyle.backgroundSize = 'auto'
			tcStyle.backgroundPosition = "#{offX}px #{offY}px"

		mapContainer.appendChild tileContainer