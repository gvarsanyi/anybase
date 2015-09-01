anybase
=======

node_module to convert virtually from any to any other numeric base

# Limits
- Numeric base: 1 ... 9,007,199,254,740,991 (= 2 ^ 53 - 1)
- Fraction conversion: limited around precision 12 in decimal (less in bigger, more in smaller bases)
- Integer length: virtually unlimited (memory-limited)

# Maps digit values as follows:
- 0..9 to 0..9
- a..z to 10..35
- A..Z to 36..61

# Use with your node.js project
## Install
    cd /path/to/your/project
    npm install anybase --save

## In your code
    var anybase = require('anybase');
    
    original_number = '11'
    target_base     = 2
    original_base   = 8
    
    // prints 1001
    console.log(anybase(target_base, original_number, original_base));
    
    // prepend with zeros to make it 8 characters
    minimum_digits = 8
    // prints 00001001
    console.log(anybase(target_base, original_number, original_base, minimum_digits));
    
    // prepend with zeros to make it 8 characters
    minimum_digits = 2
    maximum_digits = 2
    // prints 01
    console.log(anybase(target_base, original_number, original_base, minimum_digits, maximum_digits));

# Use on your terminal
## Install globally
    sudo npm install -g anybase

## Convert numbers on your terminal
    anybase 2 11 8 # prints 1001
    anybase 2 11 8 8 # prints 00001001
    anybase 2 11 2 2 # prints 01
