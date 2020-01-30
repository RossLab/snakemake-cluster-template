#!/bin/bash

OUT=${@: -1}
IN=${@:1:$#-1}

wc -l $IN > $OUT
