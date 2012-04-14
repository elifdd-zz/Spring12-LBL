#!/usr/bin/env python
"""
Insert lines of data into MongoDB
"""
import sys, time
import pymongo

if len(sys.argv) != 2:
    print("usage: {0} <count>\n{1}".format(sys.argv[0], __doc__))
    sys.exit(1)
reps = int(sys.argv[1])
collname = "dang{0:d}".format(int(time.time()))
coll = pymongo.Connection().test[collname]
def loadn(c, n, data):
    nd = len(data)
    for i in xrange(n):
        c.insert({"x":data[i % nd]})
data = file("censusdata.sample.small").readlines()
t0 = time.time()
loadn(coll, reps, data)
t1 = time.time()
sec = t1 - t0
print("{c}: n={n:d} sec={s:f} rate={r:f}".format(
    c=collname, n=reps, s=sec, r=reps/sec))
