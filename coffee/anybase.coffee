
chars = (String(i) for i in [0 ... 10])
chars.push(String.fromCharCode(i)) for i in [65 .. 90]
chars.push(String.fromCharCode(i)) for i in [97 .. 122]

map = {}
map[char] = i for char, i in chars


module.exports = (base, n, orig_base=10, digits_min=0, digits_max=0) ->
  validate base, n, orig_base, digits_min, digits_max

  if orig_base isnt 10
    n = base_to_dec n, orig_base
  else
    n = Number n

  (n = dec_to_base n, base) if base isnt 10

  (n = '0' + n) while digits_min and String(n).length < digits_min

  if digits_max and String(n).length > digits_max
    n = String(n).substr 0, digits_max

  n

base_to_dec = (n, base) ->
  n10 = 0
  (n10 = n10 * base + map[char]) for char in n
  n10

dec_to_base = (n, base) ->
  nx = ''
  while n > 0
    mod = n % base
    n   = (n - mod) / base
    nx = chars[mod] + nx
  nx

validate = (base, n, orig_base, digits_min, digits_max) ->
  int_check = (n, min=false, max=false) ->
    not (typeof n isnt 'number' or Math.round(n) isnt n or
         (min isnt false and n < min) or (max isnt false and n > max))

  if not int_check(base, 2, 62) or not int_check(orig_base, 2, 62)
    throw new Error 'Invalid base'

  if not int_check(digits_min, 0, 64) or not int_check(orig_base, 0, 64)
    throw new Error 'Invalid number of digits'

  for char in String n
    if (v = map[char]) > orig_base or not v?
      throw new Error 'Invalid number for base'
