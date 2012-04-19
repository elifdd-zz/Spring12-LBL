#!/usr/bin/env python
"""
Insert lines of data into MongoDB
"""
import sys, time
import pymongo

msg_ = sys.stderr.write

def load_data():
    line = "X" * 1024
    return [line] * 100

def loadn(c, n, data,rpt=1000):
    nd, sz = len(data), len(data[0]) /(1024*1024.0)
    t0 = time.time()
    print("MB,MBps")
    for i in xrange(n):
        c.insert({"x":data[i % nd]})
        if i % rpt == 0:
            t1 = time.time()
            rate = (i*sz)/(t1 - t0)
            print("{0:.2f},{1:.2f}".format(i*sz, rate))
            sys.stdout.flush()

def main():
    if len(sys.argv) != 2:
        msg_("usage: {0} <count>\n{1}\n".
                format(sys.argv[0], __doc__))
        return 1
    reps = int(sys.argv[1])
    collname = "dang{0:d}".format(int(time.time()))
    # connect
    db = pymongo.Connection().test
    # remove old data
    for c in db.collection_names():
        if c.startswith("dang"):
            msg_("drop collection {c}\n".format(c=c))
            db.drop_collection(c)
    coll = db[collname]
    data = load_data()
    loadn(coll, reps, data)
    return 0

if __name__ == "__main__":
    sys.exit(main())
