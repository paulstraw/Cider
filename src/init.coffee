# Initializers to set up things like `Audio.trigger()`, `Audio.loop()` and `Audio.stop()`

Audio.prototype.stop = ->
	this.pause()
	this.currentTime = 0

Audio.prototype.trigger = ->
	this.stop()
	this.play()