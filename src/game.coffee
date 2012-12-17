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

		# Other default properties. Gravity defaults to 0 (no gravity), and cPos gets reset to `x0/y0` every time `@game.loadLevel()` is called.
		@gravity = 0
		@cPos = {x: 0, y: 0}
		@debug = false

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
		es = @el.style
		es.left = "#{-@cPos.x}px"
		es.top = "#{-@cPos.y}px"

	# Load a new `Level` object, and reconfigure game settings as appropriate.
	loadLevel: (level) =>
		@currentLevel = level
		@cPos = {x: 0, y: 0}

		es = @el.style
		es.width = "#{level.size.x * level.tileSize}px"
		es.height = "#{level.size.y * level.tileSize}px"

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

		@update()
		@draw()

		if @debug && ~~(Math.random() * 100) == 4
			@debugEl.innerText = "#{@fps} FPS"

	update: =>
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