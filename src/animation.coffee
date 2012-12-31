# Sprite sheets are used to set up Animations. They must be passed an `Image` object (probably something from a `Game`'s `resources`), along with the width and height of each frame.
class SpriteSheet
	constructor: (@image, @frameWidth = 16, @frameHeight = 16) ->
		@src = @image.src


class Animation
	# Animations must be passed a frame length (milliseconds) and a 0-indexed frame sequence (something like this: `[0, 1, 2, 3, 2, 1]`).
	constructor: (@spriteSheet, @frameLength, @sequence = [0]) ->
		spriteSheet = @spriteSheet
		img = spriteSheet.image

		# The separate `SpriteSheet` class is mostly just so you don't have to pass the same three things to a bunch of animations in each entity.
		@src = spriteSheet.image.src
		@width = spriteSheet.frameWidth
		@height = spriteSheet.frameHeight

		@tilesPerRow = img.width / @width


		@offset = {x: 0, y: 0}
		@imgWidth = img.width
		@imgHeight = img.height
		@clock = new c.Clock

	update: =>
		frameTotal = Math.floor(@clock.delta() / @frameLength)

		@frame = frameTotal % @sequence.length
		@tile = @sequence[@frame]

		currentRow = Math.ceil((@tile + 1) / @tilesPerRow) - 1
		currentColumn = @tile % @tilesPerRow
		@offset.x = - (currentColumn * @width)
		@offset.y = - (currentRow * @height)

	draw: (entity) =>
		es = entity.el.style
		# c.log es
		es.backgroundImage = "url(#{@src})"
		es.backgroundPosition = "#{@offset.x}px #{@offset.y}px"

	# update: function() {
	# 	var frameTotal = Math.floor(this.timer.delta() / this.frameTime);
	# 	this.loopCount = Math.floor(frameTotal / this.sequence.length);
	# 	if( this.stop && this.loopCount > 0 ) {
	# 		this.frame = this.sequence.length - 1;
	# 	}
	# 	else {
	# 		this.frame = frameTotal % this.sequence.length;
	# 	}
	# 	this.tile = this.sequence[ this.frame ];
	# },