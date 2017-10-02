#!/bin/bash
STATS=$(printf "stats\n" | nc localhost 11211)
gethits=$(echo "$STATS" | grep "get_hits" | cut -d" " -f3 | tr -d '\n')
hitratesincebeginning=$(echo  Total hists"$gethits1" )
echo "$hitratesincebeginning"
