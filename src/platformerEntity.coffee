# Cider's `PlatformerEntity` is designed to help you manage Box2D's physics in a more Marioesque way. The entity's fixure `friction` and `restitution` both default to `0`, and the body defaults to `fixedRotation`. Additionally, instances of this class maintain a `standing` property using a foot sensor (Check out [this site]() for implementation details).

class PlatformerEntity extends Entity
	constructor: ->
		@friction = 0
		@restitution = 0
		@fixedRotation = true

		# Things to know if we're standing or not.
		@standing = false
		@footContacts = 0

		super

	update: =>
		super

		@standing = !!@footContacts

	createBody: =>
		super

		fixtureDef = new b2FixtureDef
		fixtureDef.isSensor = true
		fixtureDef.shape = new b2PolygonShape
		fixtureDef.shape.SetAsOrientedBox(@size.x / 2 / c.b2Scale - 0.02, 0.05, new b2Vec2(0.01, @size.y / 2 / c.b2Scale))

		footSensor = @body.CreateFixture fixtureDef
		footSensor.SetUserData('cider-foot-sensor')

	contactBegin: (contact) =>
		if contact.GetFixtureA().GetUserData() == 'cider-foot-sensor'
			@footContacts++

		if contact.GetFixtureB().GetUserData() == 'cider-foot-sensor'
			@footContacts++

	contactEnd: (contact) =>
		if contact.GetFixtureA().GetUserData() == 'cider-foot-sensor'
			@footContacts--

		if contact.GetFixtureB().GetUserData() == 'cider-foot-sensor'
			@footContacts--