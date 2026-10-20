#!/usr/bin/env python3
"""Parallel chunked downloader with resume support.

Usage: pget.py <url> <output> [connections]
"""
import os
import sys
import threading
import time
import urllib.request

URL = sys.argv[1]
OUT = sys.argv[2]
NCONN = int(sys.argv[3]) if len(sys.argv) > 3 else 16
CHUNK = 4 * 1024 * 1024

req = urllib.request.Request(URL, method="HEAD")
with urllib.request.urlopen(req, timeout=60) as r:
    total = int(r.headers.get("Content-Length", 0))
    print(f"total size: {total} bytes ({total/1024/1024:.1f} MiB)", flush=True)

if not total:
    sys.exit("no content-length")

partdir = OUT + ".parts"
os.makedirs(partdir, exist_ok=True)
nchunks = (total + CHUNK - 1) // CHUNK
print(f"{nchunks} chunks of {CHUNK//1024//1024} MiB across {NCONN} connections", flush=True)

lock = threading.Lock()
done_bytes = 0


def worker(cid):
    global done_bytes
    start = cid * CHUNK
    end = min(start + CHUNK, total) - 1
    if start > end:
        return
    path = os.path.join(partdir, f"part-{cid:05d}")
    have = os.path.getsize(path) if os.path.exists(path) else 0
    if have == (end - start + 1):
        return
    for attempt in range(200):
        try:
            rq = urllib.request.Request(URL, headers={"Range": f"bytes={start+have}-{end}"})
            with urllib.request.urlopen(rq, timeout=60) as resp, open(path, "ab") as fh:
                while True:
                    buf = resp.read(262144)
                    if not buf:
                        break
                    fh.write(buf)
                    have += len(buf)
                    with lock:
                        done_bytes += len(buf)
            if have == (end - start + 1):
                return
        except Exception:
            time.sleep(3)
    print(f"chunk {cid} incomplete", flush=True)


threads = [threading.Thread(target=worker, args=(i,), daemon=True) for i in range(NCONN)]
for t in threads:
    t.start()

last = 0
while any(t.is_alive() for t in threads):
    time.sleep(10)
    with lock:
        cur = done_bytes
    rate = (cur - last) / 10
    last = cur
    print(f"  {cur/1024/1024:.1f} MiB  ({rate/1024:.0f} KiB/s aggregate)", flush=True)

with open(OUT + ".tmp", "wb") as out:
    for i in range(nchunks):
        p = os.path.join(partdir, f"part-{i:05d}")
        if os.path.exists(p):
            with open(p, "rb") as fh:
                while True:
                    buf = fh.read(1 << 20)
                    if not buf:
                        break
                    out.write(buf)
os.replace(OUT + ".tmp", OUT)
print(f"assembled {OUT} ({os.path.getsize(OUT)} bytes)", flush=True)
