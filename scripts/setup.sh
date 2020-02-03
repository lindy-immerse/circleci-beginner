#!/bin/bash

##------ CHECK IF karma_stats.js EXISTS ------##

FILE=$PWD/data/karma_stats.js
THRESHOLD=0

if test ! -f "$FILE";
then
    KARMA_JS="module.exports = {\n\"branches\": $THRESHOLD,\n\"functions\": $THRESHOLD,\n\"lines\": $THRESHOLD,\n\"statements\": $THRESHOLD\n};"
    echo -e "$KARMA_JS" > "$PWD/data/karma_stats.js"
    echo "---> Generated karma_stats.js!"
else
    echo "---> File karma_stats.js already exists."
fi
