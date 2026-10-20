#!/usr/bin/env bash
# Collect the Assignment 4 verification evidence from inside the guest VM.
set -uo pipefail

WORK=/home/medisoft/Desktop/bugema-work
SSH_KEY=$HOME/.ssh/id_ed25519
SSH_PORT=2222
GUEST=jovian
OUT=$WORK/evidence/guest-verification.txt
SSHOPTS="-i $SSH_KEY -p $SSH_PORT -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=10 -o BatchMode=yes"

ssh $SSHOPTS "$GUEST@127.0.0.1" 'bash -s' > "$OUT" 2>&1 <<'GUEST'
echo "=================================================================="
echo " BUGEMA LINUX DEVELOPMENT ENVIRONMENT - VERIFICATION TRANSCRIPT"
echo " collected inside the guest virtual machine"
echo "=================================================================="
echo
echo "----- 1. USER AND SYSTEM CONFIGURATION ------------------------------"
echo "\$ whoami";      whoami
echo "\$ id";          id
echo "\$ hostname";    hostname
echo "\$ hostnamectl"; hostnamectl 2>/dev/null | sed -n '1,8p'
echo "\$ uname -a";    uname -a
echo "\$ lsb_release -a"; lsb_release -a 2>/dev/null
echo
echo "----- 2. RESOURCES ----------------------------------------------------"
echo "\$ free -h";    free -h
echo "\$ df -h /";    df -h /
echo "\$ nproc";      nproc
echo "\$ systemd-detect-virt"; systemd-detect-virt 2>/dev/null
echo
echo "----- 3. PACKAGE MANAGEMENT ------------------------------------------"
echo "\$ apt --version"; apt --version | head -1
echo "\$ apt update (last lines)"; sudo apt update 2>&1 | tail -3
echo "\$ apt list --installed | wc -l"; apt list --installed 2>/dev/null | wc -l
echo
echo "----- 4. NETWORK CONFIGURATION AND TESTING ---------------------------"
echo "\$ ip -brief addr"; ip -brief addr
echo "\$ ip route";        ip route
echo "\$ ping -c 4 8.8.8.8"; ping -c 4 8.8.8.8
echo "\$ ping -c 4 github.com"; ping -c 4 github.com
echo "\$ getent hosts github.com"; getent hosts github.com
echo
echo "----- 5. GIT INSTALLATION AND CONFIGURATION -------------------------"
echo "\$ git --version"; git --version
echo "\$ git config --global --list"; git config --global --list
echo
echo "----- 6. BUGEMA LINUX REPOSITORY CLONE TEST -------------------------"
cd ~ && rm -rf bugema-linux
echo "\$ git clone https://github.com/bos-com/bugema-linux.git"
git clone https://github.com/bos-com/bugema-linux.git
cd bugema-linux
echo "\$ git status";       git status
echo "\$ git log --oneline -5"; git log --oneline -5
echo "\$ git branch -a";    git branch -a
echo "\$ ls -la";           ls -la
echo
echo "----- 7. DEVELOPMENT TOOLS -------------------------------------------"
for t in git python3 curl wget vim java gcc; do
  printf '%-10s ' "$t"
  command -v "$t" >/dev/null 2>&1 && ($t --version 2>&1 | head -1) || echo "not installed"
done
echo
echo "----- 8. CLOUD-INIT / PROVISIONING LOG -------------------------------"
echo "\$ cloud-init status"; cloud-init status 2>/dev/null
echo "=================================================================="
echo " END OF TRANSCRIPT"
echo "=================================================================="
GUEST

echo "transcript written to $OUT ($(wc -l < "$OUT") lines)"
tail -3 "$OUT"
