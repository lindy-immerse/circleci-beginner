#!/bin/bash

##------ CHECK IF karma_stats.js EXISTS ------##

FILE=$PWD/data/karma_stats.js

#module.exports = {
#"branches": 100,
#"functions": 100,
#"lines": 100,
#"statements": 100
#};

if test ! -f "$FILE"; then
    KARMA_JS="module.exports = {\n\"branches\": 0,\n\"functions\": 0,\n\"lines\": 0,\n\"statements\": 0\n};"
    echo -e "$KARMA_JS" > "$PWD/data/karma_stats.js"
fi
