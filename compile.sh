#!/bin/sh

npm install

echo "[compiling]"

coffee -o javascript/ source/

echo '#!/usr/bin/env node\n' | cat - javascript/anybase-cli.js > javascript/anybase-cli.js.tmp
mv javascript/anybase-cli.js.tmp javascript/anybase-cli.js

chmod a+x javascript/anybase-cli.js
echo "[done]"
