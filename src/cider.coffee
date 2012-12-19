#@codekit-prepend 'clock.coffee';
#@codekit-prepend 'map.coffee';
#@codekit-prepend 'level.coffee';
#@codekit-prepend 'gamecontroller.coffee';
#@codekit-prepend 'game.coffee';
#@codekit-prepend 'entity.coffee';

b2Vec2 = Box2D.Common.Math.b2Vec2
b2BodyDef = Box2D.Dynamics.b2BodyDef
b2Body = Box2D.Dynamics.b2Body
b2FixtureDef = Box2D.Dynamics.b2FixtureDef
b2Fixture = Box2D.Dynamics.b2Fixture
b2World = Box2D.Dynamics.b2World
b2MassData = Box2D.Collision.Shapes.b2MassData
b2PolygonShape = Box2D.Collision.Shapes.b2PolygonShape
b2CircleShape = Box2D.Collision.Shapes.b2CircleShape
b2DebugDraw = Box2D.Dynamics.b2DebugDraw

Cider =
	Game: Game
	Entity: Entity
	Clock: Clock
	Level: Level
	Map: Map
	#This converts pixels to meters (what Box2D uses for measurements). By default, one pixel equals 1/100th of a meter.
	b2Scale: 30
	mapType: Object.freeze
		regular: 0
		collision: 1
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