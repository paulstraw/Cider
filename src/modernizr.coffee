# Modernizr 2.6.2 (Custom Build) | MIT & BSD
# Build: http://modernizr.com/download/#-prefixed-testprop-testallprops-domprefixes
modernizr = (a, b, c) ->
  w = (a) ->
    i.cssText = a
  x = (a, b) ->
    w prefixes.join(a + ";") + (b or "")
  y = (a, b) ->
    typeof a is b
  z = (a, b) ->
    !!~("" + a).indexOf(b)
  A = (a, b) ->
    for d of a
      e = a[d]
      return (if b is "pfx" then e else not 0)  if not z(e, "-") and i[e] isnt c
    not 1
  B = (a, b, d) ->
    for e of a
      f = b[a[e]]
      return (if d is not 1 then a[e] else (if y(f, "function") then f.bind(d or b) else f))  if f isnt c
    not 1
  C = (a, b, c) ->
    d = a.charAt(0).toUpperCase() + a.slice(1)
    e = (a + " " + m.join(d + " ") + d).split(" ")
    (if y(b, "string") or y(b, "undefined") then A(e, b) else (e = (a + " " + n.join(d + " ") + d).split(" ")
    B(e, b, c)
    ))
  d = "2.6.2"
  e = {}
  f = b.documentElement
  g = "modernizr"
  h = b.createElement(g)
  i = h.style
  j = undefined
  k = {}.toString
  l = "Webkit Moz O ms"
  m = l.split(" ")
  n = l.toLowerCase().split(" ")
  o = {}
  p = {}
  q = {}
  r = []
  s = r.slice
  t = undefined
  u = {}.hasOwnProperty
  v = undefined
  (if not y(u, "undefined") and not y(u.call, "undefined") then v = (a, b) ->
    u.call a, b
   else v = (a, b) ->
    b of a and y(a.constructor::[b], "undefined")
  )
  Function::bind or (Function::bind = (b) ->
    c = this
    throw new TypeError  unless typeof c is "function"
    d = s.call(arguments_, 1)
    e = ->
      if this instanceof e
        a = ->

        a:: = c::
        f = new a
        g = c.apply(f, d.concat(s.call(arguments_)))
        return (if Object(g) is g then g else f)
      c.apply b, d.concat(s.call(arguments_))

    e
  )

  for D of o
    v(o, D) and (t = D.toLowerCase()
    e[t] = o[D]()
    r.push(((if e[t] then "" else "no-")) + t)
    )
  e.addTest = (a, b) ->
    unless typeof a is "object"
      a = a.toLowerCase()
      return e  if e[a] isnt c
      b = (if typeof b is "function" then b() else b)
      typeof enableClasses isnt "undefined" and enableClasses and (f.className += " " + ((if b then "" else "no-")) + a)
      e[a] = b
    e

  w("")
  h = j = null
  e._version = d
  e._domPrefixes = n
  e._cssomPrefixes = m
  e.testProp = (a) ->
    A [a]

  e.testAllProps = C
  e.prefixed = (a, b, c) ->
    (if b then C(a, b, c) else C(a, "pfx"))

  e
window.Modernizr = modernizr(this, @document)