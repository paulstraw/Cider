#@codekit-prepend 'clock.coffee';
#@codekit-prepend 'level.coffee';
#@codekit-prepend 'gamecontroller.coffee';
#@codekit-prepend 'game.coffee';
#@codekit-prepend 'entity.coffee';

Cider =
	Game: Game
	Entity: Entity
	Clock: Clock
	Level: Level
	raf: do ->
		func = window.requestAnimationFrame ||
			window.webkitRequestAnimationFrame ||
			window.mozRequestAnimationFrame ||
			window.oRequestAnimationFrame ||
			window.msRequestAnimationFrame ||
			(callback) ->
				window.setTimeout callback, 1000 / 60

		return (cb, el) ->
			func.apply window, [cb, el]
	extend: (dest) ->
		for source in Array.prototype.slice.call arguments, 1
			dest[key] = val for key, val of source
		dest
	log: ->
		if window.console
			console.log Array.prototype.slice.call(arguments)


window.c = window.Cider = Cider