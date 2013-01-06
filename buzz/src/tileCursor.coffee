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