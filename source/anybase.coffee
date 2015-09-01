
defaultMap = for i in [48 .. 57].concat [97 .. 122], [65 .. 90], [945 .. 969]
  String.fromCharCode i # 0..9 A..Z a..z α..ω


class AnybaseDigits

  # @base     int 2+
  # @charmap  []
  # @digits   []
  # @fraction undefined | []
  # @negative bool


  constructor: (@base, number, @charmap) ->
    @_checkBase()
    @_checkNumber(number)
    @_checkFraction()
    @_checkCharmap()


  _checkBase: ->
    unless typeof @base is 'number' and @base > 1 and @base is Math.floor @base
      throw new Error '`base` must be an integer >= 2'
    return


  _checkCharmap: ->
    if @charmap
      unless @charmap?.length >= @base
        throw new Error '`charmap` must be an array with enough keys for base'
      for char in @charmap when char in ['-', '.'] or char.length isnt 1
        throw new Error '`charmap` must not contain \'-\', \'.\' and must ' +
                        'contain single characters only'

      for digit, i in @digits
        if typeof digit is 'string'
          if -1 is @digits[i] = @charmap.indexOf digit
            throw new Error '`charmap` does not contain: \'' + digit + '\''
        else unless @base > digit >= 0 and
        (@digits[i] = Number digit) is Math.floor digit
          throw new Error 'invalid digit: \'' + digit + '\''
    else
      for digit, i in @digits
        unless @base > digit >= 0 and
        (@digits[i] = Number digit) is Math.floor digit
          throw new Error 'invalid digit: \'' + digit + '\''
    return


  _checkFraction: ->
    unless @digits.lastIndexOf('.') is pos = @digits.indexOf '.'
      throw new Error 'More then 1 decimal points in `number`'

    if pos is @digits.length - 1
      @digits.pop()
    else if pos > -1
      @fraction = @digits.splice pos + 1
      @digits.pop()


  _checkNumber: (number) ->
    if typeof number is 'number'
      @digits = String(number).split ''
    else if typeof number is 'string'
      @digits = number.split ''
    else if number.slice
      @digits = number.slice()
    else
      throw new Error '`number` must be number a string or an array of digits'

    if @negative = @digits[0] is '-'
      @digits.shift()

    while @digits[0] is 0
      @digits.shift()
    return


  add: (n, pos = @digits.length - 1, multiply) ->
    growth = 0
    if pos is -1
      @digits.unshift 0
      growth = 1
      pos    = 0

    peek = if multiply then @digits[pos] * n else @digits[pos] + n
    @digits[pos] = peek % @base
    if remainder = (peek - @digits[pos]) / @base
      growth += @add remainder, pos - 1

    growth


  addToFractionPos: (n, pos) ->
    unless n
      return

    if pos is -1
      @add n
      return

    @fraction ?= []
    while pos >= @fraction.length
      @fraction.push 0

    peek = @fraction[pos] + n
    @fraction[pos] = peek % @base
    if remainder = (peek - @fraction[pos]) / @base
      @addToFractionPos remainder, pos - 1

    return


  times: (n) ->
    i = 0
    len = @digits.length
    while i < len
      if growth = @add n, i, true
        i   += growth
        len += growth
      i += 1
    return


  compile: (toBase, precision = 10) ->
    res = new AnybaseDigits toBase, 0, @charmap

    res.negative = @negative

    for digit, i in @digits # integer
      if i
        res.times @base
      res.add digit

    if @fraction
      res.fraction = []
      for digit, i in @fraction
        i2 = 0
        value = digit
        pow = @base ** (i + 1)
        until value is 0 or i2 >= precision
          value = value * toBase
          multi = Math.floor (value / pow).toPrecision 12
          value -= pow * multi
          res.addToFractionPos multi, i2
          i2 += 1

    res


  output: ->
    if @fraction
      while @fraction[@fraction.length - 1] is 0
        @fraction.pop()
      unless @fraction.length
        delete @fraction

    unless @charmap
      res = if @negative then ['-'] else []
      res.push @digits...
      if @fraction
        res.push '.', @fraction...
      return res

    res  = if @negative then '-' else ''
    res += (@charmap[digit] for digit in @digits).join ''
    if @fraction
      res += '.' + (@charmap[digit] for digit in @fraction).join ''
    res


anybase = (number, fromBase=10, toBase=10, charmap=defaultMap, precision=20) ->
  charmap = null if charmap is true

  source = new AnybaseDigits fromBase, number, charmap

  source.compile(toBase, precision).output()


unless typeof module is 'undefined'
  module.exports = anybase

unless typeof window is 'undefined'
  window.anybase = anybase
