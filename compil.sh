#!/bin/bash

./myc < test/$1.myc > test/$1.c

cat test/$1.c

gcc  -o test/$1 test/$1.c

