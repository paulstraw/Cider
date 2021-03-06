class Loader
	constructor: (@parent, @resources = {}, @resourcesPrefix = '') ->
		@percentComplete = 0
		@completed = 0
		@resourceCount = Object.keys(@resources).length

		@_initializeResource key, val for key, val of @resources

	_initializeResource: (key, val) =>
		if Array.isArray val
			# By convention, an array means we've got an audio element.
			audioElement = new Audio()

			for resourceUrl in val
				sourceElement = document.createElement('source')
				sourceElement.src = @resourcesPrefix + (resourceUrl)

				audioElement.appendChild sourceElement

			audioElement.addEventListener 'canplaythrough', @_soundLoaded
			audioElement.addEventListener 'error', @_soundError
			@_loadSound audioElement

			@resources[key] = audioElement
		else
			# Not an array? Load it as an image.
			imgElement = new Image()

			imgElement.addEventListener 'load', @_imageLoaded
			imgElement.addEventListener 'error', @_imageError
			# There's no need to have a `_loadImage` method or similar, because images start loading as soon as we set their `src` attribute.
			imgElement.src = @resourcesPrefix + (val)

			@resources[key] = imgElement

	_loadSound: (el) =>
		document.body.appendChild el
		el.volume = 0
		el.play()

	_soundLoaded: (e) =>
		el = e.target
		el.pause()
		el.currentTime = 0

		el.removeEventListener 'canplaythrough', @_soundLoad
		el.removeEventListener 'error', @_soundError

		@_updateComplete()

	_soundError: (e) =>
		el = e.target

		el.removeEventListener 'canplaythrough', @_soundLoad
		el.removeEventListener 'error', @_soundError

		src = el.firstChild.src
		throw new Error "#{src.substr(0, src.lastIndexOf('.'))} failed to load."

		@_updateComplete()

	_imageLoaded: (e) =>
		el = e.target

		el.removeEventListener 'load', @_imageLoaded
		el.removeEventListener 'error', @_imageError

		@_updateComplete()

	_imageError: (e) =>
		el = e.target

		el.removeEventListener 'load', @_imageLoaded
		el.removeEventListener 'error', @_imageError

		throw new Error "#{el.src} failed to load."

	_updateComplete: =>
		@completed++
		@percentComplete = Math.round(@completed / @resourceCount * 100)

		if @percentComplete == 100
			# Setting volumes back here seems to get rid of the short clip playing after everything's loaded.
			for name, el of @resources
				if el.tagName == 'AUDIO' then el.volume = 1

			@parent?.ready?()