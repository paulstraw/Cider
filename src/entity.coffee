class Entity
	constructor: (@game, options = {}) ->
		@game.createEntity this

		@tagName = 'div'
		@className = ''
		@id = ''
		@pos = {x: 0, y: 0}
		@size = {x: 0, y: 0}
		@angle = 0

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
		bodyDef.type = b2Body.b2_dynamicBody

		@body = @game.world.CreateBody bodyDef

		fixtureDef = new b2FixtureDef
		fixtureDef.density = 2
		fixtureDef.friction = 1
		fixtureDef.restitution = 0.2

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
		#console.log 'ohelo'
		es.left = "#{@pos.x - @size.x / 2}px"
		es.top = "#{@pos.y - @size.y / 2}px"
		#es[c.prefixed.transform] = "translate3d(#{@pos.x}px, #{@pos.y}px, 0px)"
		es.width = "#{@size.x}px"
		es.height = "#{@size.y}px"
		es.WebkitTransform = "rotate(#{@angle}deg)"

	update: =>
		newPos = @body.GetPosition()

		@angle = @body.GetAngle() * (180 / Math.PI)
		@pos.x = (newPos.x * c.b2Scale)
		@pos.y = (newPos.y * c.b2Scale)

		# unless @whatever
		# 	@whatever = true
		# 	c.log 'ooo', @body, @body.GetPosition(), @body.GetAngle()
		#c.log 'updating entity'

	draw: =>
		@drawElement()
		#c.log 'drawing entity'

	setStyle: (prop, val) =>
		@el.style[prop] = val;


