class Clock
	# Global properties (we want these to change for all clocks if we change them)
	maxStep: 50
	timeScale: 1

	constructor: (@target = 0) ->
		@base = c.Clock.time
		@last = c.Clock.time

	set: (target) =>
		@target = target || 0
		@base = c.Clock.time

	reset: =>
		@base = c.Clock.time

	tick: =>
		delta = c.Clock.time - @last
		@last = c.Clock.time

		delta

	delta: =>
		c.Clock.time - @base - @target


Clock.maxStep = 50
Clock.timeScale = 1
Clock.time = 0
Clock._last = 0

Clock.step = =>
	current = Date.now()
	delta = current - c.Clock._last

	c.Clock.time += Math.min(delta, c.Clock.maxStep) * c.Clock.timeScale;
	c.Clock._last = current;