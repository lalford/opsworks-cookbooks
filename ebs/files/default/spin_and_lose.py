#! /usr/bin/env python
import sys
import time

max = 5
i = 0
while True:
    print "%d: spinning..." % i
    if (i == max):
        print "doh!"
        sys.exit(42)
    else:
        time.sleep(1)
        i = i + 1
