class Level
	constructor: (@game, options = {}) ->
		# Width and height for Levels are in tiles, not pixels
		@size = {x: 100, y: 50}
		@tileSize = 16

		c.extend this, options

		@setPxSize()

	setPxSize: =>
		@pxSize = {x: @size.x * @tileSize, y: @size.y * @tileSize}