ciderStuff =
	mapType: Object.freeze
		regular: 0
		collision: 1
	extend: (dest) ->
		for source in Array.prototype.slice.call arguments, 1
			dest[key] = val for key, val of source
		dest

window.c = window.Cider = ciderStuff