class LevelLoader
	constructor: (@game) ->
		unless @game then throw new Error 'LevelLoader must be passed a `Game`.'

	load: (level) =>
		@loadMap map for map in level.maps

	# Loads and renders a map into the game world.
	loadMap: (map) =>
		if map.type == c.mapType.collision
			for row, i in map.data
				for col, j in row
					@createMapBody map, row[j], i, j
		else if map.type == c.mapType.regular
			# Calculate reusable values used for tile generation.
			mapContainer = document.createElement 'div'
			img = map.tileset
			tileSize = map.tileSize
			tilesPerRow = img.width / tileSize

			mapContainer.className = 'cider-map'
			mapContainer.setAttribute 'data-distance', map.distance
			mcs = mapContainer.style
			mcs.position = 'absolute'
			mcs.left = '0px'
			mcs.top = '0px'

			for row, i in map.data
				if row
					for col, j in row
						@createMapTile mapContainer, map, row[j], i, j, img, tileSize, tilesPerRow

			@game.el.appendChild mapContainer


	createMapBody: (map, tile, row, col) =>
		# If no tile was passed, we don't need to draw anything
		unless tile then return

		tileSize = map.tileSize
		xPos = col * tileSize
		yPos = row * tileSize

		# Create a Box2D body and fixture for our physics simulation
		bodyDef = new b2BodyDef

		bodyDef.position = new b2Vec2(
			(xPos + tileSize / 2) / c.b2Scale,
			(yPos + tileSize / 2) / c.b2Scale
		)
		bodyDef.type = b2Body.b2_staticBody

		body = @game.world.CreateBody bodyDef

		fixtureDef = new b2FixtureDef
		fixtureDef.density = 2
		fixtureDef.friction = 1
		fixtureDef.restitution = 0

		fixtureDef.shape = new b2PolygonShape
		fixtureDef.shape.SetAsBox(
			tileSize / 2 / c.b2Scale,
			tileSize / 2 / c.b2Scale
		)

		body.CreateFixture fixtureDef

	createMapTile: (mapContainer, map, tile, row, col, img, tileSize, tilesPerRow) =>
		# If no tile was passed, we don't need to draw anything
		unless tile then return

		tileSize = map.tileSize
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
		tcStyle.zIndex = map.zIndex || 1

		mapContainer.appendChild tileContainer