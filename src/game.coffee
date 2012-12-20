# Cider's main game class; lives at `c.Game`. Example usage:
#
#     class myGame extends c.Game
#         constructor: ->
#              super
#
#              someLevel = new c.Level this
#              @loadLevel someLevel
#
#              for i in [0..10]
#                   new MyEntity this
#
#     new myGame

class Game
	constructor: (options = {}) ->
		@_unique = 1

		@clock = new c.Clock

		# `Array` containing all `Entity` objects associated with this game. Usually you'll probably want to use methods like `@game.getEntityById()` and `@game.getEntitiesByClassName()` instead of accessing this directly, but you may come across a situation where it's handy.
		@entities = []

		# `Object` containing all resources (images, sound files, etc) needed for this game. Used inside other classes like this: `@game.resources['hero sprite']`, as well as for preloading all necessary files on page load. Each value can be a string or an array of strings.
		#
		#     @resources =
		#         'hero sprite': '/img/sprites/hero.png'
		#         'ominous boss music': ['/audio/boss.mp3', '/audio/boss.ogg']
		@resources = {}

		# Camera size in CSS pixels. This is the viewport into the game world.
		@cSize = {x: 640, y: 320}

		# Tag name, classes, and ID for this game's camera element, probably only useful for styling and such, if you need to do that.
		@tagName = 'div'
		@className = ''
		@id = 'cider-camera'

		# Other default properties. Gravity defaults to `{x:0, y:9.8}` (Earth gravity), and cPos gets reset to `{x: 0, y: 0}` every time `@game.loadLevel()` is called.
		@gravity = {x: 0, y: 9.8}
		@cPos = {x: 0, y: 0}
		@debug = false
		@debugDraw = false

		# Overwrite defaults with any passed options.
		c.extend this, options

		# Set up the DOM elements.
		@createElements()
		@initializeElements()

		# If this game is in debug mode, display FPS and other debug data.
		if @debug
			@initializeDebugMode()
			@lastFrameStart = Date.now()

		# Kick off our run loop.
		@run()

	# This only gets called if the constructor passed `debug: true`. All it does is set up a container for FPS (and eventually other data).
	initializeDebugMode: =>
		@debugEl = document.createElement 'div'

		style = @debugEl.style

		@debugEl.id = 'cider-debug'

		style.position = 'absolute'
		style.bottom = '0px'
		style.right = '0px'

		document.body.appendChild @debugEl

	# Set up the camera and game world elements.
	createElements: =>
		cameraEl = document.createElement 'div'
		cameraEl.id = @id
		cameraEl.className = @className

		@cameraEl = cameraEl

		el = document.createElement @tagName
		el.id = 'cider-world'

		@el = el

	initializeElements: =>
		cEs = @cameraEl.style
		cEs.width = "#{@cSize.x}px"
		cEs.height = "#{@cSize.y}px"
		cEs.overflow = 'hidden'
		cEs.position = 'relative'

		es = @el.style
		es.overflow = 'hidden'
		es.position = 'absolute'

		document.body.appendChild @cameraEl
		@cameraEl.appendChild @el

	# This actually repositions the game world and not the camera itself, but has the same effect as moving the camera.
	positionCamera: =>
		unless @currentLevel then return

		es = @el.style

		if @cPos.x < 0 then @cPos.x = 0
		if @cPos.x > @currentLevel.pxSize.x - @cSize.x then @cPos.x = @currentLevel.pxSize.x - @cSize.x

		if @cPos.y < 0 then @cPos.y = 0
		if @cPos.y > @currentLevel.pxSize.y - @cSize.y then @cPos.y = @currentLevel.pxSize.y - @cSize.y

		es.left = "#{-@cPos.x}px"
		es.top = "#{-@cPos.y}px"

	# Load a new `Level` object, and reconfigure game settings as appropriate.
	loadLevel: (level) =>
		# Recreate the world every time we load a level.
		@world = new b2World(new b2Vec2(@gravity.x, @gravity.y), true)

		if @debugDraw
			debugDraw = new Box2D.Dynamics.b2DebugDraw
			debugDraw.SetSprite document.getElementsByTagName("canvas")[0].getContext("2d")
			debugDraw.SetDrawScale c.b2Scale
			debugDraw.SetFillAlpha 0.3
			debugDraw.SetLineThickness 1
			debugDraw.SetFlags b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit
			@world.SetDebugDraw debugDraw

		@currentLevel = level
		@cPos = {x: 0, y: 0}

		@loadMap map for map in level.maps

		es = @el.style
		es.width = "#{level.size.x * level.tileSize}px"
		es.height = "#{level.size.y * level.tileSize}px"

	# Loads and renders a map into the game world.
	loadMap: (map) =>
		for row, i in map.data
			for col, j in row
				@createMapTile map, row[j], i, j

	createMapTile: (map, tile, row, col) =>
		# If no tile was passed, we don't need to draw anything
		unless tile then return

		tileSize = map.tileSize
		xPos = col * tileSize
		yPos = row * tileSize

		# Create a Box2D body and fixture for our physics simulation
		bodyDef = new b2BodyDef

		bodyDef.position = new b2Vec2(
			(xPos + tileSize / 2) / c.b2Scale,
			(yPos + tileSize / 2) / c.b2Scale
		)
		bodyDef.type = b2Body.b2_staticBody

		body = @world.CreateBody bodyDef

		fixtureDef = new b2FixtureDef
		fixtureDef.density = 2
		fixtureDef.friction = 1
		fixtureDef.restitution = 0.2

		fixtureDef.shape = new b2PolygonShape
		fixtureDef.shape.SetAsBox(
			tileSize / 2 / c.b2Scale,
			tileSize / 2 / c.b2Scale
		)

		body.CreateFixture fixtureDef


		tileContainer = document.createElement 'div'
		tcStyle = tileContainer.style

		tileContainer.className = 'tile'

		tcStyle.width = tcStyle.height = "#{tileSize}px"
		tcStyle.position = 'absolute'
		tcStyle.left = "#{xPos}px"
		tcStyle.top = "#{yPos}px"

		@el.appendChild tileContainer

	# Pause the game (no entities will be updated during this time).
	pause: =>
		@paused = true

	# Unpause the game (entity updates resume).
	unpause: =>
		@paused = false

	# The run loop, which updates our global clock, calculates debug information, and most importantly calls `update()` and `draw()` for all game entities.
	run: =>
		c.raf @run

		c.Clock.step()
		@tick = @clock.tick()

		if @paused then return

		if @debug
			@fps = Math.round(1 / ((Date.now() - @lastFrameStart) / 1000))
			@lastFrameStart = Date.now()

		# Update the game's camera position
		@positionCamera()

		if @world
			# Move our physics world ahead to match our tick (`tick, velocity iterations, position iterations`).
			@world.Step @tick / 1000, 8, 3

		@update()
		@draw()

		if @debug && ~~(Math.random() * 30) == 4
			@debugEl.innerText = "#{@fps} FPS"

	update: =>
		if @world
			if @debugDraw
				@world.DrawDebugData()

			@world.ClearForces()
		@updateEntities()

	draw: =>
		@drawEntities()

	updateEntities: =>
		entity.update() for entity in @entities

	drawEntities: =>
		entity.draw() for entity in @entities

	createEntity: (entity) =>
		@entities.push entity

	destroyEntity: (entity) =>
		#@entities.push entity