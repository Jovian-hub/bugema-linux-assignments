#!/usr/bin/env python3
"""Capture QEMU guest console screenshots through the QMP socket.

Usage: screendump.py <qmp_port> <output_dir>
"""
import json
import os
import socket
import sys
import time

from PIL import Image

QMP_PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 4444
OUT_DIR = sys.argv[2] if len(sys.argv) > 2 else "."


class Qmp:
    def __init__(self, port):
        self.sock = socket.create_connection(("127.0.0.1", port), timeout=20)
        self.buf = b""
        self.read()  # greeting
        self.cmd("qmp_capabilities")

    def read(self):
        while True:
            chunk = self.sock.recv(65536)
            if not chunk:
                raise RuntimeError("QMP closed")
            self.buf += chunk
            while b"\n" in self.buf:
                line, self.buf = self.buf.split(b"\n", 1)
                if not line.strip():
                    continue
                try:
                    return json.loads(line)
                except json.JSONDecodeError:
                    continue

    def cmd(self, execute, **args):
        payload = {"execute": execute}
        if args:
            payload["arguments"] = args
        self.sock.sendall((json.dumps(payload) + "\n").encode())
        while True:
            msg = self.read()
            if "event" in msg:
                continue
            if "error" in msg:
                raise RuntimeError(f"{execute} failed: {msg['error']}")
            if "return" in msg:
                return msg["return"]


def grab(qmp, path_ppm):
    qmp.cmd("screendump", filename=path_ppm)
    for _ in range(50):
        if os.path.exists(path_ppm) and os.path.getsize(path_ppm) > 0:
            time.sleep(0.5)
            return True
        time.sleep(0.2)
    return False


def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    qmp = Qmp(QMP_PORT)
    shots = [
        ("01-vm-boot-console.png", 5),
        ("02-vm-login-screen.png", 60),
        ("03-vm-desktop-xfce.png", 90),
    ]
    for name, wait in shots:
        time.sleep(wait)
        ppm = os.path.join(OUT_DIR, name.replace(".png", ".ppm"))
        try:
            if not grab(qmp, ppm):
                print(f"  !! no screendump produced for {name}")
                continue
            img = Image.open(ppm)
            img.save(os.path.join(OUT_DIR, name))
            os.remove(ppm)
            print(f"  captured {name} ({img.size[0]}x{img.size[1]})")
        except Exception as exc:  # noqa: BLE001
            print(f"  !! failed {name}: {exc}")


if __name__ == "__main__":
    main()
