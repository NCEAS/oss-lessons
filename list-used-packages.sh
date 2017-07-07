#!/bin/sh

grep -h -E -R -o "library\((\w+)\)" ./ | sort | uniq
