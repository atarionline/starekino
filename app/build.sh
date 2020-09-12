#!/bin/bash

mp="$HOME/Programs/MadPascal/mp"
mads="$HOME/Programs/mads/mads"
base="$HOME/Programs/MadPascal/base"
name="wsk"

$mp $name.pas -o

if [ -f $name.a65 ]; then
  [ ! -d "output" ] && mkdir output
  mv $name.a65 output/
  $mads output/$name.a65 -x -i:$base -o:output/$name.xex
else
  exit 1
fi
