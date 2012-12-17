class Entity
	constructor: (@game, options = {}) ->
		@game.createEntity this

		@tagName = 'div'
		@className = ''
		@id = ''
		@pos = {x: 0, y: 0}
		@size = {x: 0, y: 0}

		# Overwrite defaults with any passed options.
		c.extend this, options

		@createElement()
		@initializeElement()
		#vel
		#accel

	createElement: =>
		el = document.createElement @tagName
		el.className = @className
		el.id = @id

		@el = el

	initializeElement: =>
		es = @el.style
		es.position = 'absolute'
		es.background = '#f00'
		@game.el.appendChild @el

	drawElement: =>
		es = @el.style
		es.left = "#{@pos.x}px"
		es.top = "#{@pos.y}px"
		es.width = "#{@size.x}px"
		es.height = "#{@size.y}px"

	update: =>
		#c.log 'updating entity'

	draw: =>
		@drawElement()
		#c.log 'drawing entity'

	setStyle: (prop, val) =>
		@el.style[prop] = val;


