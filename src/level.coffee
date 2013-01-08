class Level
	constructor: (options = {}) ->
		# Width and height for Levels are in tiles, not pixels
		@size = {x: 50, y: 25}
		@tileSize = 32
		@maps = []

		c.extend this, options

		# unless @maps? && @maps.length then throw new Error 'Cider Levels require at least one map'

		@addMap map for map in @maps

		@setPxSize()

	setPxSize: =>
		@pxSize = {x: @size.x * @tileSize, y: @size.y * @tileSize}

	addMap: (map) =>
		map.tileSize ?= @tileSize