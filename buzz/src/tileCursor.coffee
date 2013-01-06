class TileCursor
	constructor: () ->
		@el = $('<div class="cursor">')

	setSize: (size) =>
		@size = size

		es = @el[0].style
		es.width = "#{size}px"
		es.height = "#{size}px"

	moveToClosest: (x, y) =>
		es = @el[0].style
		es.left = "#{Math.floor(x / @size) * @size}px"
		es.top = "#{Math.floor(y / @size) * @size}px"


	getPositionFromIndex: =>



	setTile: (@index, @xPos, yPos) =>
		unless @index? then return

		if @index == 0
			@el.css
				backgroundPosition: '9999px 9999px'
		else
			@el.css
				backgroundPosition: "#{xPos - 1}px #{yPos - 1}px" # Extra - 1 is to account for borders, it doesn't actually effect output.


	setTileset: (setName) =>
		# TODO don't match against strings, that's just silly.
		if !setName || setName == 'Select…'
			@el.css
				backgroundImage: ''
			return

		@index = 1

		if setName == 'cider collision'
			@tileset = {src: 'img/collision.png'}
		else
			@tileset = window.buzz.resources[setName]

		@el.css
			backgroundImage: "url(#{@tileset.src})"
			# It's fine to set this statically, since we always reset to index 1 when switching
			backgroundPosition: '0 0'