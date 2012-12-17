# Each instance of `Game` automatically instantiates a new `GameController` as `@controller`.

class GameController
	constructor: ->
		@_triggered = []
		@_holding = []

	update: =>
		@_triggered = []

	# Internal handler for keydown events
	_keydown: (e) =>


	# Internal handler for keyup events
	_keyup: (e) =>


	# Check if button for `action` was just pressed. Usage:
	#
	#     if @game.controller.triggered 'jump'
	#         @jump()
	triggered: (action) =>


	# Check if button for `action` is being held. Usage:
	#
	#     if @game.controller.holding 'shoot'
	#         @shoot()
	holding: (action) =>



	# A map of all keys:keyCodes
	_map:
		'm1': -1
		'm2': -3
		'mup': -4
		'mdown': -5

		'backspace': 8
		'tab': 9
		'enter': 13
		'pause': 19
		'caps': 20
		'esc': 27
		'space': 32
		'page up': 33
		'page down': 34
		'end': 35
		'home': 36
		'left': 37
		'up': 38
		'right': 39
		'down': 40
		'insert': 45
		'delete': 46
		'_0': 48
		'_1': 49
		'_2': 50
		'_3': 51
		'_4': 52
		'_5': 53
		'_6': 54
		'_7': 55
		'_8': 56
		'_9': 57
		'a': 65
		'b': 66
		'c': 67
		'd': 68
		'e': 69
		'f': 70
		'g': 71
		'h': 72
		'i': 73
		'j': 74
		'k': 75
		'l': 76
		'm': 77
		'n': 78
		'o': 79
		'p': 80
		'q': 81
		'r': 82
		's': 83
		't': 84
		'u': 85
		'v': 86
		'w': 87
		'x': 88
		'y': 89
		'z': 90
		'num 0': 96
		'numpad 1': 97
		'numpad 2': 98
		'numpad 3': 99
		'numpad 4': 100
		'numpad 5': 101
		'numpad 6': 102
		'numpad 7': 103
		'numpad 8': 104
		'numpad 9': 105
		'multiply': 106
		'add': 107
		'subtract': 109
		'decimal': 110
		'divide': 111
		'f1': 112
		'f2': 113
		'f3': 114
		'f4': 115
		'f5': 116
		'f6': 117
		'f7': 118
		'f8': 119
		'f9': 120
		'f10': 121
		'f11': 122
		'f12': 123
		'shift': 16
		'ctrl': 17
		'alt': 18
		'plus': 187
		'comma': 188
		'minus': 189
		'period': 190