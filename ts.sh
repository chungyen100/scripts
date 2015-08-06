#!/bin/bash

python ~/ts/timeseries.py ss:mongod-ss.log--$1 iostat:iostat.log--$1  > $1.html
