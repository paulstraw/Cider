onReady = ->
	document.removeEventListener 'DOMContentLoaded', onReady, false

	class MyEntity extends c.Entity
		constructor: ->
			super

			#start with a randomized direction
			@dir =
				x: if ~~(Math.random() * 2) then 1 else -1
				y: if ~~(Math.random() * 2) then 1 else -1

		update: =>
			super

			if @dir.x == 1
				if @pos.x + @size.x < @game.currentLevel.pxSize.x
					@pos.x += 2
				else
					@dir.x = -1
			else
				if @pos.x > 0
					@pos.x -= 2
				else
					@dir.x = 1

			if @dir.y == 1
				if @pos.y + @size.y < @game.currentLevel.pxSize.y
					@pos.y += 2
				else
					@dir.y = -1
			else
				if @pos.y > 0
					@pos.y -= 2
				else
					@dir.y = 1

	class myGame extends c.Game
		constructor: ->
			super

			someLevel = new c.Level this
			@loadLevel someLevel

			for i in [0..1500]
				new MyEntity this,
					pos:
						x: ~~(Math.random() * 590)
						y: ~~(Math.random() * 270)
					size:
						x: 50
						y: 50

			# setTimeout @pause, 5000
			# setTimeout @unpause, 10000



	gameInstance = new myGame
		debug: true
		resources:
			stuff: 'things'

	#console.log gameInstance


document.addEventListener 'DOMContentLoaded', onReady, false