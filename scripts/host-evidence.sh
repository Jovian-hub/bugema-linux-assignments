#!/usr/bin/env bash
# Capture the Assignment 4 verification evidence from the Linux system that is
# actually used for Bugema Linux development.
set -uo pipefail
OUT=/home/medisoft/Desktop/bugema-work/evidence/host-verification.txt
mkdir -p "$(dirname "$OUT")"

{
echo "=================================================================="
echo " BUGEMA LINUX DEVELOPMENT ENVIRONMENT - VERIFICATION TRANSCRIPT"
echo " Host: $(hostname)   Distribution: $(. /etc/os-release; echo "$PRETTY_NAME")"
echo " Captured: $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo "=================================================================="
echo
echo "----- 1. USER AND SYSTEM CONFIGURATION ------------------------------"
echo "\$ whoami";        whoami
echo "\$ id";            id
echo "\$ hostname";      hostname
echo "\$ hostnamectl";   hostnamectl 2>/dev/null | sed -n '1,8p'
echo "\$ uname -a";      uname -a
echo "\$ lsb_release -a"; lsb_release -a 2>/dev/null
echo
echo "----- 2. HARDWARE AND RESOURCES -------------------------------------"
echo "\$ lscpu (selected)"; lscpu | grep -E "Architecture|^CPU\(s\)|Model name|Thread|Core|Virtualization"
echo "\$ free -h";       free -h
echo "\$ df -h /";       df -h /
echo "\$ lspgi/graphics"; lspci 2>/dev/null | grep -iE "vga|3d controller|display" | head -2
echo "\$ ls -l /dev/kvm"; ls -l /dev/kvm
echo
echo "----- 3. PACKAGE MANAGEMENT ------------------------------------------"
echo "\$ apt --version"; apt --version | head -1
echo "\$ apt-get --version"; apt-get --version | head -1
echo "\$ dpkg --version"; dpkg --version | head -1
echo "\$ apt update (tail)"; mkdir -p /tmp/apt-lists/partial /tmp/apt-cache/archives/partial && timeout 180 apt-get -o Dir::State::lists=/tmp/apt-lists -o Dir::Cache=/tmp/apt-cache update 2>&1 | tail -4
echo "\$ apt list --installed | wc -l"; apt list --installed 2>/dev/null | wc -l
echo "\$ dpkg -l | grep -c '^ii'"; dpkg -l 2>/dev/null | grep -c '^ii'
echo
echo "----- 4. NETWORK CONFIGURATION AND TESTING ---------------------------"
echo "\$ ip -brief addr"; ip -brief addr
echo "\$ ip route";        ip route
echo "\$ ping -c 4 8.8.8.8"; ping -c 4 8.8.8.8
echo "\$ ping -c 4 github.com"; ping -c 4 github.com
echo "\$ getent hosts github.com"; getent hosts github.com
echo "\$ nmcli device status"; nmcli device status 2>/dev/null | head -5
echo
echo "----- 5. GIT INSTALLATION AND CONFIGURATION -------------------------"
echo "\$ git --version"; git --version
echo "\$ git config --global --list"; git config --global --list
echo "\$ git config --global credential.helper"; git config --global credential.helper
echo
echo "----- 6. GITHUB CLI AND AUTHENTICATION ------------------------------"
echo "\$ gh --version"; gh --version | head -1
echo "\$ gh auth status"; gh auth status 2>&1 | sed 's/gho_[A-Za-z0-9_]*/<token redacted>/; s/ghu_[A-Za-z0-9_]*/<token redacted>/'
echo
echo "----- 7. BUGEMA LINUX REPOSITORY CLONE TEST -------------------------"
cd /tmp && rm -rf bugema-clone-test
echo "\$ git clone https://github.com/bos-com/bugema-linux.git"
git clone --quiet https://github.com/bos-com/bugema-linux.git bugema-clone-test 2>&1 | tail -2
cd bugema-clone-test
echo "\$ git status";       git status
echo "\$ git log --oneline -5"; git log --oneline -5
echo "\$ git branch -a";    git branch -a
echo "\$ ls";              ls
cd /tmp && rm -rf bugema-clone-test
echo
echo "----- 8. DEVELOPMENT TOOLS -------------------------------------------"
for t in git gh python3 curl wget vim java gcc make systemctl; do
  printf '%-10s ' "$t"
  if command -v "$t" >/dev/null 2>&1; then ($t --version 2>&1 | head -1); else echo "not installed"; fi
done
echo
echo "----- 9. VIRTUALISATION PLATFORM (QEMU/KVM) --------------------------"
P=/home/medisoft/Desktop/bugema-work/qemu-prefix
export LD_LIBRARY_PATH=$P/usr/lib/x86_64-linux-gnu:$P/usr/lib:${LD_LIBRARY_PATH:-}
echo "\$ qemu-system-x86_64 --version"; $P/usr/bin/qemu-system-x86_64 --version 2>&1 | head -1
echo "\$ qemu-img --version";           $P/usr/bin/qemu-img --version 2>&1 | head -1
echo "\$ qemu-system-x86_64 -accel help"; $P/usr/bin/qemu-system-x86_64 -accel help 2>&1 | tail -3
echo
echo "=================================================================="
echo " END OF TRANSCRIPT"
echo "=================================================================="
} > "$OUT" 2>&1

echo "written: $OUT ($(wc -l < "$OUT") lines)"
