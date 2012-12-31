# In Cider, levels are made out of one or more maps (at least one collision map, but you'll probably want some regular maps as well to actually show players what they're colliding with). Map data is an array of arrays. For collision maps, 0 is empty, and 1 or more will create a body in the physics simulation ([TODO] the number is passed to the body's `userData` so you can determine how entities should react when colliding with various tile types). For regular maps, 0 is empty, and 1 or more corresponds to the tile position in the passed tileset (any image; 1 is the first tile, 2 the second, etc). This differs from sprites in Cider, which set the image based on 0 instead of 1.
class Map
	constructor: (@data, options = {}) ->
		unless @data then throw new Error 'Cider Maps require an array containing map data'

		@type = c.mapType.regular

		c.extend this, options

		if @type != c.mapType.collision && !@tileset then throw new Error 'Non-collision Cider Maps require a tileset'
