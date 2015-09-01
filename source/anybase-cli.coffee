anybase = require './anybase'

if ~process.argv.indexOf('-h') or ~process.argv.indexOf('--help') or
process.argv.length < 4
  console.log """

    Usage:
      anybase number fromBase toBase [options]

    Examples:
      # anybase 9f 16 10
      => 159
      # anybase [9,15] 16 10
      => 159

    Arguments:
      number    charmap-based representation (example: F0), or comma-separated
                array of decimal values of each digits (example: [15,0])
      fromBase  numeric base of the original number
      toBase    conversion target numeric base

    Options:
      --charmap=UTF_STRING -cSTR  custom map to represent digits, default:
                                  0..9 a..z A..Z α..ω (for base <= 87)
                                  '-', '.', ',' and ' ' are not allowed
      --no-charmap         -n     no charmaps (array-style input/output)
      --precision=N        -pN    max fractional digits in output
      --help               -h     this help message
      --version            -v     version info

  """
  return


if ~process.argv.indexOf('-v') or ~process.argv.indexOf('--version')
  console.log require('../package.json').version
  return


precision = null
charmap   = null
plainArgs = []
for arg in process.argv[2 ...]
  if arg[0] is '-'
    if arg in ['-n', '--no-charmap']
      charmap = true
    else if arg.substr(0, 2) is '-c'
      charmap = arg.substr 2
    else if arg.substr(0, 10) is '--charmap='
      charmap = arg.substr 10
    else if arg.substr(0, 2) is '-p'
      precision = arg.substr 2
    else if arg.substr(0, 12) is '--precision='
      precision = arg.substr 12
  else
    plainArgs.push arg

[number, fromBase, toBase] = plainArgs

number = number.trim()
if number[0] is '['
  number = number.substr 1, number.length - 1
  number = (Number(digit.trim()) for digit in number.split ',')

fromBase = Number fromBase.trim() or 10
toBase   = Number toBase.trim()   or 10

try
  console.log anybase number, fromBase, toBase, charmap, precision

catch error
  console.error String error
  process.exit 1
