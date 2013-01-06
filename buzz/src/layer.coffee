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

		c.extend this, options