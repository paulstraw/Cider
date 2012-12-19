class Map
	constructor: (@data, options = {}) ->
		unless @data then throw new Error 'Cider Maps require an array containing map data'

		@type = c.mapType.regular

		c.extend this, options

		if @type != c.mapType.collision && !@tileset then throw new Error 'Non-collision Cider Maps require a tileset'
