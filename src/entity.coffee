class Entity
	constructor: (@game, options = {}) ->
		# _entityId is used internally by Cider for things like notifying entities of collisions.
		@_entityId = @game.createEntity this

		@tagName = 'div'
		@className = ''
		@id = ''
		@pos = {x: 0, y: 0}
		@vel = {x: 0, y: 0}

		# Properties used for drawing and Box2D body creation.
		@size = {x: 0, y: 0}
		@angle = 0

		# Properties for Box2D body creation.
		@angularDamping = 0
		@linearDamping = 0
		@gravityScale = 1
		@fixedRotation = false unless @fixedRotation?
		@bodyType = b2Body.b2_dynamicBody

		# Properties for Box2D fixture creation.
		@density = 1
		@restitution = 0 unless @restitution?
		@friction = 0.5 unless @friction?

		# Overwrite defaults with any passed options.
		c.extend this, options

		@createBody()
		@createElement()
		@initializeElement()
		#vel
		#accel

	createBody: =>
		# Create a Box2D body and fixture for our physics simulation
		bodyDef = new b2BodyDef

		bodyDef.position = new b2Vec2(
			(@pos.x + @size.x / 2) / c.b2Scale,
			(@pos.y + @size.y / 2) / c.b2Scale
		)
		bodyDef.type = @bodyType

		# Set up userData on bodyDef so we can trace the body back to its Cider object (for collision and stuff).
		bodyDef.userData = @_entityId

		bodyDef.angularDamping = @angularDamping
		bodyDef.linearDamping = @linearDamping
		bodyDef.gravityScale = @gravityScale
		bodyDef.fixedRotation = @fixedRotation

		@body = @game.world.CreateBody bodyDef

		fixtureDef = new b2FixtureDef

		fixtureDef.density = @density
		fixtureDef.friction = @friction
		fixtureDef.restitution = @restitution

		fixtureDef.shape = new b2PolygonShape
		fixtureDef.shape.SetAsBox(
			@size.x / 2 / c.b2Scale,
			@size.y / 2 / c.b2Scale
		)

		@body.CreateFixture fixtureDef

	createElement: =>
		el = document.createElement @tagName
		el.className = @className
		el.id = @id

		@el = el

	initializeElement: =>
		es = @el.style
		es.position = 'absolute'
		es.background = '#f00'
		# es.WebkitPerspective = 1000
		# es.WebkitBackfaceVisibility = 'hidden'
		@game.el.appendChild @el

	drawElement: =>
		es = @el.style

		es.left = "#{@pos.x - @size.x / 2}px"
		es.top = "#{@pos.y - @size.y / 2}px"
		#es[c.prefixed.transform] = "translate3d(#{@pos.x}px, #{@pos.y}px, 0px)"
		es.width = "#{@size.x}px"
		es.height = "#{@size.y}px"
		es.WebkitTransform = "rotate(#{@angle}deg)"

	setAnim: (anim) =>
		@currentAnim = anim
		@el.style.backgroundImage = "url(#{anim.src})"

	update: =>
		body = @body
		newPos = body.GetPosition()
		newVel = body.GetLinearVelocity()

		if @currentAnim then @currentAnim.update()

		# Update physics properties and position needed for drawing based on Box2D data.
		@angle = body.GetAngle() * (180 / Math.PI)
		@pos.x = Math.round(newPos.x * c.b2Scale)
		@pos.y = Math.round(newPos.y * c.b2Scale)
		@vel.x = newVel.x
		@vel.y = newVel.y

	# This gets called by the game when this entity collides with something else. By default, it's a noop; you'll probably want to make it do something interesting.
	collidePost: (other, impulse) =>


	collidePre: (contact) =>


	contactBegin: (contact) =>


	contactEnd: (contact) =>


	# Call this when your entity has died, or needs to be removed for some other reason. You can do animations or whatever else you need in here, but remember to call `parent`!
	destroy: =>
		@_destroyElement()
		@game.destroyEntity this

	_destroyElement: =>
		@game.el.removeChild @el

	draw: =>
		@drawElement()
		if @currentAnim then @currentAnim.draw this

	setStyle: (prop, val) =>
		@el.style[prop] = val;