###
#
# Copyright © 2013 Paul Straw <paulstraw@paulstraw.com>
#
# Permission is hereby granted, free of charge, to any
# person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the
# Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute,
# sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice
# shall be included in all copies or substantial portions
# of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF
# ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
# TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
###

#@codekit-prepend 'init.coffee';
#@codekit-prepend 'loader.coffee';
#@codekit-prepend 'clock.coffee';
#@codekit-prepend 'map.coffee';
#@codekit-prepend 'level.coffee';
#@codekit-prepend 'animation.coffee';
#@codekit-prepend 'gamecontroller.coffee';
#@codekit-prepend 'levelLoader.coffee';
#@codekit-prepend 'game.coffee';
#@codekit-prepend 'entity.coffee';
#@codekit-prepend 'platformerEntity.coffee';

window.b2Vec2 = Box2D.Common.Math.b2Vec2
window.b2BodyDef = Box2D.Dynamics.b2BodyDef
window.b2Body = Box2D.Dynamics.b2Body
window.b2FixtureDef = Box2D.Dynamics.b2FixtureDef
window.b2Fixture = Box2D.Dynamics.b2Fixture
window.b2World = Box2D.Dynamics.b2World
window.b2MassData = Box2D.Collision.Shapes.b2MassData
window.b2PolygonShape = Box2D.Collision.Shapes.b2PolygonShape
window.b2CircleShape = Box2D.Collision.Shapes.b2CircleShape
window.b2EdgeShape = Box2D.Collision.Shapes.b2EdgeShape
window.b2DebugDraw = Box2D.Dynamics.b2DebugDraw
window.b2ContactListener = Box2D.Dynamics.b2ContactListener
window.b2PrismaticJointDef = Box2D.Dynamics.Joints.b2PrismaticJointDef

Cider =
	Loader: Loader
	LevelLoader: LevelLoader
	Game: Game
	Animation: Animation
	SpriteSheet: SpriteSheet
	Entity: Entity
	PlatformerEntity: PlatformerEntity
	Clock: Clock
	Level: Level
	Map: Map
	GameController: GameController
	key: ciderKeys
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