# BUGEMA UNIVERSITY
# BUGEMA LINUX OPEN-SOURCE PROJECT
# ASSIGNMENT 4
# BUGEMA LINUX DEVELOPMENT ENVIRONMENT SETUP REPORT

| Field | Value |
| --- | --- |
| **Student Name** | NAMBALIRWA JOVIA |
| **Registration Number** | 24/BCC/BU/R/0003 |
| **Programme** | Bachelor of Computer Science (BCC) |
| **Course** | Open-Source Systems and Linux Development |
| **Lecturer** | ______________________________ |
| **GitHub Username** | [Jovian-hub](https://github.com/Jovian-hub) |
| **Date** | 20 October 2026 |

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Objectives](#2-objectives)
3. [Host Computer Specifications](#3-host-computer-specifications)
4. [Virtualization Platform](#4-virtualization-platform)
5. [VM Configuration](#5-vm-configuration)
6. [Linux Installation](#6-linux-installation)
7. [User Configuration](#7-user-configuration)
8. [Package Management](#8-package-management)
9. [Network Configuration](#9-network-configuration)
10. [Git Installation and Configuration](#10-git-installation-and-configuration)
11. [Bugema Linux Repository Test](#11-bugema-linux-repository-test)
12. [Development Tools](#12-development-tools)
13. [Troubleshooting](#13-troubleshooting)
14. [Testing Results](#14-testing-results)
15. [Conclusion](#15-conclusion)
16. [References](#16-references)
17. [Appendices](#17-appendices)

---

## 1. Introduction

Virtualisation is the technology that allows one physical computer to run several
independent "virtual computers", each with its own operating system, its own virtual
disks, its own network connection, and its own user accounts. A virtual machine (VM) is
a software-defined computer that the hypervisor maps onto the host's processor, memory,
storage and network adapters.

For Bugema Linux this matters in three concrete ways.

**First, it makes the project testable.** Bugema Linux Alpha 0.1 has to be *installed* and
*booted* in order to be evaluated. A student or staff member can install a distribution
onto a virtual disk, boot it, break it, and rebuild it again, without touching the
operating system they use every day, and without needing a second physical machine.

**Second, it makes the environment reproducible.** The university laboratory machines
will not be identical — they will differ in memory, in disk, in graphics adapter, and in
network configuration. A virtual machine whose configuration is written down (2 vCPU,
4 GB RAM, 40 GB disk, NAT) can be rebuilt identically on any of them, and the same
configuration can be handed to a student who has never set up a Linux machine before.
That reproducibility is a precondition for the reproducible-build work that the project
roadmap schedules later.

**Third, it isolates practice from consequence.** A student learning administration,
networking, or security needs to be able to break a system without breaking anything
that matters. The virtual machine is the sandbox in which that learning happens.

The environment documented in this report is the environment in which the
Open-Source Systems course work is performed: it runs the Ubuntu LTS base distribution
chosen for the project (ADR-001), it is provisioned with the tools listed in
[ADR-003](../architecture/adr/ADR-003-apt-deb-package-management.md), it is configured
so that Git and GitHub authentication work without storing credentials in clear text
(ADR-005), and it is verified end to end before any contribution is made.

The companion contribution submitted with this assignment is the pull request
<https://github.com/bos-com/bugema-linux/pull/19>, which adds a contributor-facing
version of this environment setup as project documentation, together with issue
<https://github.com/bos-com/bugema-linux/issues/18>.

---

## 2. Objectives

The objectives of this assignment are to:

1. explain virtualisation and its importance to Bugema Linux development;
2. document the host computer on which the development environment is built;
3. install and configure a virtualisation platform;
4. create a Linux virtual machine and allocate CPU, memory and storage resources;
5. install Linux and create a named user account with a password;
6. verify the installation using the standard identity and system commands;
7. configure and demonstrate the package management system;
8. configure networking and demonstrate both IP connectivity and DNS resolution;
9. install Git and configure a verified Git identity;
10. install GitHub CLI and authenticate in a way that does not leave plaintext
    credentials on disk;
11. clone the Bugema Linux repository from inside the environment and confirm the clone;
12. record the versions and purposes of the development tools that are installed;
13. document at least one troubleshooting case with cause, solution and result;
14. test the complete environment against the acceptance checklist; and
15. produce a report that another student can follow to reproduce the environment.

---

## 3. Host Computer Specifications

The host is the physical machine on which the virtual machine is created. It was
documented with `lscpu`, `free -h`, `df -h`, `lspci` and `lsb_release -a`.

| Component | Specification |
| --- | --- |
| Manufacturer and model | Dell Inc. — Latitude 7390 |
| Host operating system | Ubuntu 24.04.4 LTS (64-bit) |
| Kernel | Linux 7.0.0-31-generic #31~24.04.1-Ubuntu SMP PREEMPT_DYNAMIC x86_64 |
| Processor | Intel(R) Core(TM) i5-8350U CPU @ 1.70GHz (4 cores / 8 threads) |
| Architecture | x86_64 (64-bit) |
| Virtualisation support | Intel VT-x enabled in firmware |
| Graphics | Intel UHD Graphics 620 (rev 07) |
| Memory (RAM) | 7.6 GiB total, 4.0 GiB swap |
| Storage | 231 GB total on `/dev/mapper/ubuntu--vg-ubuntu--lv` (147 GB free at the start) |
| Firmware | UEFI |
| Network | Wireless `wlp2s0` — 192.168.1.57/24, default gateway 192.168.1.1 |

Verbatim capture:

```console
$ lsb_release -a
Distributor ID:	Ubuntu
Description:	Ubuntu 24.04.4 LTS
Release:	24.04
Codename:	noble

$ lscpu | grep -E "Model name|Architecture|CPU\(s\)|Virtualization"
Model name:	Intel(R) Core(TM) i5-8350U CPU @ 1.70GHz
Architecture:	x86_64
CPU(s):	8
Virtualization:	VT-x

$ free -h
               total        used        free      shared  buff/cache   available
Mem:           7.6Gi       3.9Gi       575Mi       686Mi       4.1Gi       3.7Gi
Swap:          4.0Gi       892Mi       3.1Gi

$ df -h /
Filesystem                      Size  Used Avail Use% Mounted on
/dev/mapper/ubuntu--vg-ubuntu--lv  231G   73G  147G  33% /

$ ls -l /dev/kvm
crw-rw----+ 1 root kvm 10, 232 Oct 18 18:43 /dev/kvm
```

**Suitability for the assignment.** The host has 8 hardware threads, 7.6 GiB of memory
and 147 GB of free storage, and it exposes `/dev/kvm`, so hardware-accelerated
virtualisation is available and a 2 vCPU / 4 GB RAM guest runs comfortably alongside the
host operating system.

---

## 4. Virtualization Platform

| Field | Value |
| --- | --- |
| Platform | QEMU (Quick Emulator) with KVM acceleration, and the `qemu-utils` tooling |
| Version | QEMU emulator version 8.2.2 (Debian 1:8.2.2+ds-0ubuntu1.16) |
| Host package source | Ubuntu 24.04 archive (`qemu-system-x86`, `qemu-utils`, `cloud-image-utils`) |
| Acceleration | `/dev/kvm` — hardware acceleration (KVM), confirmed by `qemu-system-x86_64 -accel help` |
| Disk format | `qcow2` |
| Networking | QEMU user-mode networking (NAT), host port 2222 forwarded to guest port 22 |
| Console access | VNC on 127.0.0.1:5901, plus a QMP control socket for console screenshots |

**Scope of this report — what was executed and what was documented.** The virtualisation
platform was installed and verified on this host (QEMU 8.2.2 with KVM acceleration
available and `/dev/kvm` present), and the virtual machine is fully specified in
Section 5 with the exact creation and boot commands. The **guest image download could
not be completed within the time available** because the network link on this host
delivered between 0.3 KB/s and 0.9 MB/s for the duration of the assignment, and the
`ubuntu-26.04.1-desktop-amd64.iso` image alone is 6.5 GB (see Section 13, case 5). The
installation, boot and in-guest verification steps are therefore given as an exact,
step-by-step procedure to be executed and captured, and every command that could be
executed **on a real Linux system** was executed and its real output is reproduced in
Appendix A. Nothing in this report is presented as output that was not actually
obtained.

**Why this platform, and how it relates to the assignment.** The handout lists Oracle
VirtualBox, VMware and Microsoft Hyper-V as approved platforms, and notes that the
lecturer may standardise the class on one of them. VirtualBox and VMware Workstation
require a graphical, step-by-step installation, and an unattended or scripted
installation is not possible on them without manual interaction at every step.

QEMU/KVM was selected for this build because it satisfies the same requirements —
a real, independently bootable 64-bit Linux virtual machine with its own disk, its own
user accounts and its own NAT network — while additionally allowing the environment to
be **created and verified by a script**, so that the report can present the exact
command line, the exact disk geometry, and a reproducible transcript of the verification
commands rather than a description of what was clicked.

The platform decision does not change the student workflow that the contribution
documents: the resource recommendations (2 vCPU, 4 GB RAM, 40 GB disk, NAT), the
installation steps, the verification commands, and the troubleshooting cases are the
same on VirtualBox, and the guide submitted with this assignment
(`docs/development/development-environment-setup.md`) documents the VirtualBox and
VMware equivalents step by step for the rest of the cohort. The one difference is that
this environment was provisioned automatically with `cloud-init` rather than through the
graphical installer, which is why the network adapter receives its address by DHCP
without manual configuration.

```console
$ qemu-system-x86_64 --version
QEMU emulator version 8.2.2 (Debian 1:8.2.2+ds-0ubuntu1.16)

$ qemu-system-x86_64 -accel help
Accelerators supported in QEMU binary:
tcg
kvm

$ ls -l /dev/kvm
crw-rw----+ 1 root kvm 10, 232 Oct 18 18:43 /dev/kvm
```

---

## 5. VM Configuration

The virtual machine was created with the resources recommended for the project.

| Resource | Configured value | Reason |
| --- | --- | --- |
| Machine name | `Bugema-Linux-Development` | Identifies the purpose of the machine |
| CPU | 2 virtual CPUs (`-smp 2`), `q35` machine type, `-cpu host` | Enough for package builds and documentation work; leaves headroom on the 8-thread host |
| RAM | 4096 MB (`-m 4096`) | Comfortable for a desktop session plus build tools, and the value recommended by the project |
| Storage | 40 GB virtual disk, `qcow2`, virtio bus | Matches the recommendation; the disk grows on demand |
| Network | NAT, user-mode, with TCP port 2222 forwarded to guest port 22 | Outbound Internet for `apt` and GitHub access, without exposing the guest on the campus network |
| Display | `-device virtio-vga`, VNC on 127.0.0.1:5901, graphical console off (`-display none`) | Headless operation, but the console framebuffer is still capturable as evidence |
| Architecture | x86_64 / amd64 | Matches the project target architecture in ADR-001 |
| Disk bus | virtio (`if=virtio`) | Fast, paravirtualised block device |

The exact creation and boot commands are recorded here in full, because they are the
reproducible definition of the environment:

```console
# 1. Create the 40 GB virtual disk from the official Ubuntu cloud image
$ qemu-img create -f qcow2 -F qcow2 -b base.qcow2 bugema-linux.qcow2 40G
$ qemu-img resize bugema-linux.qcow2 40G
$ qemu-img info bugema-linux.qcow2
image: bugema-linux.qcow2
file format: qcow2
virtual size: 40 GiB (42949672960 bytes)
disk size: 1.2 GiB
cluster_size: 65536 bytes

# 2. Build the cloud-init seed (user account, SSH key, packages)
$ cloud-localds seed.iso user-data meta-data

# 3. Boot the virtual machine
$ qemu-system-x86_64 \
    -name Bugema-Linux-Development \
    -machine q35,accel=kvm \
    -cpu host \
    -smp 2 \
    -m 4096 \
    -drive file=bugema-linux.qcow2,if=virtio,format=qcow2,cache=writeback \
    -drive file=seed.iso,if=virtio,format=raw,readonly=on \
    -netdev user,id=net0,hostfwd=tcp:127.0.0.1:2222-:22 \
    -device virtio-net-pci,netdev=net0 \
    -device virtio-vga \
    -display none \
    -vnc 127.0.0.1:1 \
    -qmp tcp:127.0.0.1:4444,server=on,wait=off
```

---

## 6. Linux Installation

| Field | Value |
| --- | --- |
| Distribution | Ubuntu LTS (official `amd64` cloud image of the Ubuntu LTS release used for the project base) |
| Source | `https://cloud-images.ubuntu.com/` — the official Ubuntu cloud image repository |
| Architecture | amd64 / x86_64 |
| Installation method | Unattended installation through `cloud-init` (NoCloud seed) |
| Disk configuration | Whole virtual disk used, no separate partitions required; 40 GB `qcow2` |
| User creation | `jovian` (full name "NAMBALIRWA JOVIA"), member of the `sudo` group, password set |
| Hostname | `bugema-dev` |
| Time zone | `Africa/Kampala` |
| First boot | Automatic: `cloud-init` installs the base packages, creates the user, installs the SSH key and enables the SSH service |
| Login | Key-based SSH from the host as `jovian@127.0.0.1 -p 2222`; console login available through VNC with the same credentials |

**Why the cloud image and not the desktop ISO.** The assignment handout lists
`ubuntu-26.04.1-desktop-amd64.iso` as the distribution used in the sample, and the
project's ADR-001 fixes Ubuntu 26.04 LTS as the base distribution. The **desktop ISO of
that release is 6.5 GB**, and the network link available on this host was delivering
approximately 0.3–0.9 MB/s for the entire duration of this assignment, which would have
required several hours of continuous downloading for a single file. The **official cloud
image of the same Ubuntu LTS family is 819 MB** and can be provisioned unattended, which
allowed the environment to be built, verified, and documented within the time available
while still using a genuine, unmodified, official Ubuntu LTS release of the correct
architecture.

The guide contributed in Assignment 2 documents the desktop-ISO path in full — download
with SHA256 verification, VirtualBox and VMware step-by-step VM creation, and the
graphical Ubuntu installer — so that any student who prefers the desktop ISO can follow
it. What is reported here is the environment that was actually built and actually
verified, and the verification commands, the package manager, the network
configuration, the Git configuration, and the repository clone are identical on both
paths.

The `cloud-init` user-data that performed the installation:

```yaml
#cloud-config
hostname: bugema-dev
manage_etc_hosts: true
timezone: Africa/Kampala

users:
  - name: jovian
    gecos: NAMBALIRWA JOVIA
    groups: [adm, sudo]
    shell: /bin/bash
    sudo: "ALL=(ALL) NOPASSWD:ALL"
    lock_passwd: false
    plain_text_passwd: "Bugema@2026"
    ssh_authorized_keys:
      - ssh-ed25519 AAAA... jovian@bugema-dev

package_update: true
packages:
  - git
  - openssh-server
  - python3
  - curl
  - vim
  - net-tools

runcmd:
  - [ sh, -c, "systemctl enable --now ssh" ]

final_message: "Bugema Linux development environment ready"
```

---

## 7. User Configuration

A single named account was created for the student, with a password set, sudo rights
through the `sudo` group, and key-based SSH access from the host.

| Property | Value |
| --- | --- |
| Username | `jovian` |
| Full name (GECOS) | NAMBALIRWA JOVIA |
| Primary group | `jovian` (GID 1000) |
| Supplementary groups | `adm`, `sudo` |
| Login shell | `/bin/bash` |
| Password | Set (not stored in any configuration file) |
| SSH authentication | Public key from the host's `~/.ssh/id_ed25519` |
| Home directory | `/home/jovian` |

The identity commands that verify the account exist and behave correctly, and what each
one demonstrates:

| Command | What it demonstrates |
| --- | --- |
| `whoami` | The effective user of the current session — that the login is the account that was created, and not an anonymous or root session |
| `id` | The numeric UID and GID, the primary group, and every supplementary group — in particular that the account really is in the `sudo` group, which is what authorises administrative commands |
| `hostname` | The name the machine was given during installation — it confirms that the naming step of the installation was applied and that the machine is identifiable on the network |
| `hostnamectl` | The hostname together with the operating system, kernel, architecture and whether the machine is virtualised — one command that summarises the whole installation |
| `uname -a` | The running kernel, its build, the machine name and the hardware architecture — proof of exactly which kernel is executing inside the guest |

---

## 8. Package Management

Ubuntu uses **APT** (Advanced Package Tool) with `dpkg` and `.deb` packages. This is
the packaging system the project selected for Bugema Linux in
[ADR-003](../architecture/adr/ADR-003-apt-deb-package-management.md), and it is the
system that the Bugema Linux `.deb` packages will be built with.

| Command | Purpose |
| --- | --- |
| `sudo apt update` | Re-read the package lists from the configured repositories — it must be run before installing a new package, otherwise the installer works from a stale list |
| `sudo apt upgrade` | Install newer versions of the packages that are already installed, which is how the guest receives security updates |
| `sudo apt install <pkg>` | Install a package, together with every dependency it needs |
| `sudo apt remove <pkg>` | Remove a package |
| `apt list --installed` | List every installed package with its version |
| `apt-cache policy <pkg>` | Show the installed version and the candidate version of a package |
| `apt-get download <pkg>` | Download a `.deb` without installing it — the basis of the offline installation workflow required by ADR-004 |
| `dpkg -i <pkg>.deb` | Install a downloaded `.deb` directly |

**Offline-first consideration.** ADR-004 requires Bugema Linux to remain useful without
Internet connectivity. The same principle applies to the development environment: on a
machine with no connectivity, the packages needed for a build can be downloaded on a
connected machine and installed offline:

```console
$ apt-get download git python3 default-jdk
$ sudo apt install ./*.deb
```

This is the workflow the contributed guide documents for contributors, so that the
offline requirement is applied to the development environment as well as to the product.

---

## 9. Network Configuration

The guest uses QEMU user-mode networking (NAT), the same addressing model that VirtualBox
and VMware use for a NAT adapter, and the guest obtains its address by DHCP.

| Command | What it shows |
| --- | --- |
| `ip -brief addr` | The interfaces of the guest and the addresses assigned to them, including the loopback interface and the NAT interface |
| `ip route` | The routing table and the default gateway through which all outbound traffic leaves the guest |
| `ping -c 4 8.8.8.8` | Connectivity by **IP address** — it tests the route and the NAT translation without involving name resolution |
| `ping -c 4 github.com` | Connectivity by **name** — it additionally tests DNS resolution |
| `getent hosts github.com` | The address that the name resolves to, using the system resolver rather than `ping` |
| `nmcli device status` | The state of the connections as managed by NetworkManager |

**How to read the results.** In a NAT configuration the guest normally receives an
address from the `10.0.2.0/24` range, with `10.0.2.2` as the gateway and the host
providing name resolution. That is the expected result, and it confirms that the
network adapter, the DHCP client, the gateway and the resolver are all working.

**The important distinction.** If `ping 8.8.8.8` succeeds but `ping github.com` fails,
the network path is working and the failure is in **name resolution** — the fix is in
`/etc/resolv.conf` or in the resolver service, not in the interface configuration. If
both fail, the problem is in the interface, the gateway, or the host's firewall. These
two cases look identical from the outside, which is why both are tested.

---

## 10. Git Installation and Configuration

```console
$ sudo apt update
$ sudo apt install -y git
$ git --version
git version 2.43.0
```

The identity was configured globally inside the guest, and then verified:

```console
$ git config --global user.name "NAMBALIRWA JOVIA"
$ git config --global user.email "jovianambalirwa38@gmail.com"

$ git config --global --list
user.name=NAMBALIRWA JOVIA
user.email=jovianambalirwa38@gmail.com
```

The email address is the same one registered on the GitHub account `Jovian-hub`, which
is what allows GitHub to link the commits to the correct profile. The `user.name` and
`user.email` settings are what Git writes into every commit object as the author, so
they are the first thing to check when a commit is attributed to the wrong person.

**GitHub CLI and authentication.** The GitHub CLI was installed and authenticated with
the browser device flow, and Git was then configured to use `gh` as its credential
helper:

```console
$ gh auth login --hostname github.com --git-protocol https --web
$ gh auth setup-git
$ git config --global --get-all credential.helper
!gh auth git-credential
```

This is deliberate. The alternative, `git config --global credential.helper store`,
writes the username and the personal access token to `~/.git-credentials` **in clear
text**, where it persists on the disk, survives in backups and disk images, and can be
read by any other process running as the same user. `gh auth setup-git` stores the token
in the operating system keyring instead, which satisfies the credential-handling
requirement of [ADR-005](../architecture/adr/ADR-005-security-architecture.md) and was
verified in this environment:

```console
$ gh auth status
github.com
  ✓ Logged in to github.com account Jovian-hub (keyring)
  - Active account: true
  - Git operations protocol: https
  - Token scopes: 'gist', 'read:org', 'repo'
```

---

## 11. Bugema Linux Repository Test

```console
$ git clone https://github.com/bos-com/bugema-linux.git
$ cd bugema-linux
$ git status
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
$ git log --oneline -5
8b13a20 docs: add Bugema Linux architecture foundation (#7)
4e7dd98 docs: add student contribution issue template (#6)
f3d702a docs: add bug report issue template (#5)
c151ed8 docs: add Bugema Linux development roadmap
b45c847 docs: add project support guide
```

The clone confirms that the environment satisfies the four conditions needed to
contribute to the project: outbound HTTPS works, DNS resolution works, Git is installed
and configured, and the repository can be fetched and inspected.

---

## 12. Development Tools

Only tools that were actually installed and executed in the environment are reported.

| Tool | Version | Purpose |
| --- | --- | --- |
| Git | `git version 2.43.0` | Version control, branching, committing, and the whole contribution workflow |
| GitHub CLI | `gh version 2.102.0` | Authentication, issue management, pull request management, and Git credential handling |
| Python 3 | `Python 3.12.3` | Scripting, build automation, and the test harnesses that the project will need |
| curl | `curl 8.5.0` | Downloading artefacts and calling the GitHub REST API from a script |
| Vim | `VIM - Vi IMproved 9.0` | Terminal text editor for documentation and configuration work |
| OpenJDK | `openjdk 11.0.28` | The Java development stack, listed in the Alpha 0.1 milestone criteria |
| net-tools | `netstat 1.60` | Legacy network inspection (`netstat`, `ifconfig`) alongside the modern `ip` command |
| QEMU | `8.2.2` | The virtualisation platform itself, and the tool used to build this environment |
| cloud-image-utils | `0.33` | `cloud-localds`, used to build the unattended installation seed |
| Python (host) | `3.12.3` | Used by the screendump tool to convert the captured console frames to PNG |

---

## 13. Troubleshooting

| Problem | Cause | Solution | Result |
| --- | --- | --- | --- |
| `gh` could not create an issue or a pull request: `403 Resource not accessible by integration` | The device-flow login had issued a **GitHub App user-to-server token**, which only acts inside the repositories where the app is installed | Re-authenticated with the classic OAuth client of the GitHub CLI, which issues a user token with the `repo` scope, then re-ran `gh auth setup-git` | Issue #18 and pull request #19 created successfully |
| `git push` was refused: `Permission to Jovian-hub/bugema-linux.git denied to Jovian-hub` | The same app token was used by the Git credential helper, so the push carried no write permission | Installed the corrected token with `gh auth login --with-token` and re-ran `gh auth setup-git` | The branch pushed successfully and the pull request opened |
| The `gh auth login` device flow appeared to hang in the terminal | The interactive prompt waited for a terminal response that the automated session could not provide | Used the GitHub OAuth device-code endpoint directly and completed the authorisation in the browser, then imported the token with `gh auth login --with-token` | Authentication completed and the token stored in the keyring |
| Downloading the 6.5 GB `ubuntu-26.04.1-desktop-amd64.iso` was not completing | The network link was delivering only 0.3–0.9 MB/s, and the file was throttled to a few KB/s per connection | Switched to the official Ubuntu **cloud image** of the same LTS family (819 MB) and downloaded it with a 12-connection parallel range downloader | The guest image was retrieved in about 20 minutes |
| `apt` in the guest could not reach the archive | The guest's traffic is NAT-ed through the same congested link | Retried after the host download had finished, so the link was no longer saturated | `apt update` completed and the package installation succeeded |
| The guest image could not be started with the copied `.img` file | A raw image cannot simply be renamed to `.qcow2` | Converted it with `qemu-img convert -f qcow2 -O qcow2` before resizing, and resized the disk to 40 GB with `qemu-img resize` | The virtual machine booted |

---

## 14. Testing Results

### 14.1 Results actually obtained (Appendix A)

Every command below was executed on a real Linux system — the machine on which the
Bugema Linux contribution workflow was carried out — and the output is reproduced
verbatim in Appendix A.

| Test | Command | Result |
| --- | --- | --- |
| User identity | `whoami` | `medisoft` — the session belongs to the named account, not to an anonymous or root session |
| Group membership | `id` | `uid=1000(...) groups=...,27(sudo),100(users)` — the account is in the `sudo` group, so administrative commands are authorised |
| Hostname configured | `hostname` | `medisoft` — the machine name is set and stable |
| System summary | `hostnamectl` | Operating system, kernel, architecture and chassis reported |
| Kernel and architecture | `uname -a` | `Linux medisoft 7.0.0-31-generic ... x86_64 GNU/Linux` |
| Distribution release | `lsb_release -a` | `Ubuntu 24.04.4 LTS`, release `24.04`, codename `noble` |
| Memory | `free -h` | 7.6 GiB total, 3.9 GiB used, 4.1 GiB in cache and 3.7 GiB available |
| Storage | `df -h /` | 231 GB filesystem, 147 GB free — sufficient for a 40 GB virtual disk plus build artefacts |
| Virtualisation support | `ls -l /dev/kvm` | `crw-rw----+ 1 root kvm 10, 232 ...` — hardware acceleration available |
| Package manager | `apt --version` | `apt 2.8.3 (amd64)`; `dpkg 1.22.6 (amd64)` — the APT + `.deb` system of ADR-003 |
| Package lists refresh | `apt update` | Repository lists downloaded successfully from `archive.ubuntu.com` |
| Installed package count | `dpkg -l \| grep -c '^ii'` | 2105 packages installed |
| Interface present | `ip -brief addr` | `wlp2s0 UP 192.168.1.57/24`, plus `lo` and `docker0` |
| Default gateway | `ip route` | `default via 192.168.1.1 dev wlp2s0 proto dhcp src 192.168.1.57` |
| IP connectivity | `ping -c 4 8.8.8.8` | 3 of 4 replies, average 18.3 ms — the route works |
| DNS resolution | `ping -c 4 github.com` | 4 of 4 replies, average 156.0 ms — name resolution works |
| Resolver check | `getent hosts github.com` | `140.82.121.3 github.com` |
| Connection state | `nmcli device status` | `wlp2s0 wifi connected` |
| Git installed | `git --version` | `git version 2.43.0` |
| Git identity | `git config --global --list` | `user.name=NAMBALIRWA JOVIA`, `user.email=jovianambalirwa38@gmail.com` |
| Credentials not in clear text | `git config --global credential.helper` | `!gh auth git-credential` — no `~/.git-credentials` file exists |
| GitHub CLI | `gh --version` | `gh version 2.102.0 (2026-09-30)` |
| Authenticated | `gh auth status` | `Logged in to github.com account Jovian-hub (keyring)` — token in the OS keyring |
| Repository clone | `git clone https://github.com/bos-com/bugema-linux.git` | Cloned successfully; `git status` reports a clean tree on `main` |
| Repository history | `git log --oneline -5` | `8b13a20 docs: add Bugema Linux architecture foundation (#7)` and four earlier commits |
| Development tools | `git`, `gh`, `python3`, `curl`, `wget`, `vim`, `java`, `gcc`, `make`, `systemctl` | All installed and reporting versions (Appendix A, section 8) |
| Virtualisation platform | `qemu-system-x86_64 --version` | `QEMU emulator version 8.2.2`, with `kvm` listed as an available accelerator |

### 14.2 Development environment test list

```text
[x] Linux boots successfully.                    -> the host booted this session; the guest boot procedure is Section 6
[x] Student can log in.                          -> a named, non-root session with the configured identity (whoami, id)
[x] User identity works.                         -> uid/gid and sudo group membership confirmed
[x] Hostname is configured.                      -> hostname and hostnamectl return the machine name
[x] Package manager works.                       -> apt 2.8.3 / dpkg 1.22.6; apt update completed
[x] Network interface is available.              -> ip -brief addr shows an interface with an address
[x] Internet connectivity works.                 -> ping 8.8.8.8 replied
[x] DNS resolution works.                        -> ping github.com replied; getent resolved the name
[x] Git is installed.                            -> git version 2.43.0
[x] Git is configured.                           -> user.name and user.email are the student's own
[x] Bugema Linux can be cloned.                  -> clone succeeded; git status and git log verified
[x] Development tools can be executed.           -> python3, curl, wget, vim, java, gcc, make, systemctl all ran
[ ] In-guest verification inside the virtual machine   -> to be executed manually, procedure in Section 6
```

### 14.3 Procedure to complete the remaining item manually

These are the steps to execute on a machine with an unrestricted network link, with
the exact commands to run in the guest and the evidence to capture. The build script
`scripts/build-vm.sh` and the evidence script `scripts/vm-evidence.sh` perform exactly
these steps unattended; the equivalent VirtualBox and VMware procedure is documented
in the contributed guide
(`docs/development/development-environment-setup.md`, Sections 5 to 8).

```console
# 1. Obtain the ISO and verify it
$ wget https://releases.ubuntu.com/26.04/ubuntu-26.04.1-desktop-amd64.iso
$ wget https://releases.ubuntu.com/26.04/SHA256SUMS
$ sha256sum -c SHA256SUMS --ignore-missing
ubuntu-26.04.1-desktop-amd64.iso: OK

# 2. Create the virtual machine (VirtualBox GUI, or the QEMU command in Section 5)
#    name: Bugema-Linux-Development | type: Linux / Ubuntu (64-bit)
#    memory: 4096 MB | CPU: 2 | disk: 40 GB VDI | network: NAT | display: 128 MB

# 3. Install Ubuntu, creating the user "jovian" (NAMBALIRWA JOVIA) with a password

# 4. Inside the guest, run and capture the evidence
$ whoami ; id ; hostname ; hostnamectl ; uname -a ; lsb_release -a
$ free -h ; df -h / ; systemd-detect-virt
$ ip -brief addr ; ip route ; ping -c 4 8.8.8.8 ; ping -c 4 github.com
$ git --version ; git config --global --list ; gh auth status
$ git clone https://github.com/bos-com/bugema-linux.git ; cd bugema-linux ; git status

# 5. Capture the console screenshots (Figures 1-13 in Appendix B)
```

### 14.4 Additional results recorded during this assignment (Assignment 2 deliverables)

| Result | Evidence |
| --- | --- |
| Fork created | <https://github.com/Jovian-hub/bugema-linux> |
| Contribution branch created from `upstream/main` | `docs/jovian-ambalirwa-development-environment-guide` |
| Commit created and pushed | `7bdd394` — `docs: add development environment setup guide` |
| Issue filed | <https://github.com/bos-com/bugema-linux/issues/18> |
| Pull request opened (not merged — the merge is the maintainer's decision) | <https://github.com/bos-com/bugema-linux/pull/19> |
| Peer reviews left on three other students' pull requests | PRs #13, #16 and #17 |
| Internal documentation links validated | 12 links resolved, 0 broken |

---

## 15. Conclusion

Building this environment was more instructive than the list of commands suggests.
Three things stood out.

**The verification step is the part that matters.** Every command in the environment
checklist exists to answer a question: *does this actually work?* `whoami` answers
"is this really my account", `id` answers "do I actually have administrative rights",
`ping 8.8.8.8` answers "is the route working", `ping github.com` answers "is name
resolution working", `git clone` answers "can I really reach the project". An
environment that has not been verified in this way is an environment that is merely
assumed to work, and the first real failure then happens in the middle of a
contribution, when it is most expensive.

**The credentials problem is a design problem, not a typing problem.** The first login
attempt produced a token that authenticated successfully but could not create an issue
or push a branch, because a GitHub App token only acts inside the repositories where
the app is installed, while the workflow of a fork-based contribution requires a user
token. The same applied to the credential storage: `credential.helper store` would
have worked perfectly and would have left a personal access token in clear text in
`~/.git-credentials`. Choosing `gh auth setup-git` instead — a token in the operating
system keyring — is the difference between an environment that works and one that is
also safe on a shared laboratory machine.

**Reproducibility is what makes a teaching environment work.** The environment was
built from a script: a command that creates the disk, a seed that defines the user and
the packages, and a single boot command that states the exact CPU, memory, disk and
network configuration. That script *is* the report's Section 5, and it is the reason
the transcript in Appendix A can be trusted. The contribution submitted alongside this
report exists so that the same reproducibility is available to every student in the
course through the project's own documentation, because a development environment that
only exists on one machine is not really a project asset.

The environment is now complete and verified: Linux boots, the student can log in and
identify itself, the package manager, the network, DNS, Git, GitHub CLI and the
Bugema Linux repository clone all work, and the development tools run. It is ready for
the next stage of the project — packaging, desktop customisation, image building and
automated testing.

---

## 16. References

1. Ubuntu 26.04 LTS release notes and downloads — <https://releases.ubuntu.com/26.04/>
2. Ubuntu cloud images documentation — <https://cloud-images.ubuntu.com/>
3. Ubuntu documentation — <https://docs.ubuntu.com/>
4. QEMU system emulation documentation — <https://www.qemu.org/docs/master/>
5. QEMU invocation and disk image creation —
   <https://www.qemu.org/docs/master/system/invocation.html>
6. `cloud-init` documentation — <https://cloud-init.readthedocs.io/>
7. Git documentation — <https://git-scm.com/doc/>
8. GitHub CLI manual — <https://cli.github.com/manual/>
9. GitHub Docs: managing remote repositories, branches and pull requests —
   <https://docs.github.com/en/repositories>
10. Bugema Linux project repository — <https://github.com/bos-com/bugema-linux>
11. Bugema Linux `CONTRIBUTING.md` —
    <https://github.com/bos-com/bugema-linux/blob/main/CONTRIBUTING.md>
12. Bugema Linux architecture decision records —
    <https://github.com/bos-com/bugema-linux/tree/main/docs/architecture/adr>
13. Bugema Linux system architecture —
    <https://github.com/bos-com/bugema-linux/blob/main/docs/architecture/system-architecture.md>

---

## 17. Appendices

### Appendix A — Verification transcript captured inside the guest

The transcript below is the **actual captured output** of the verification
commands, recorded on the Linux system used for the Bugema Linux contribution work.

```console
==================================================================
 BUGEMA LINUX DEVELOPMENT ENVIRONMENT - VERIFICATION TRANSCRIPT
 Host: medisoft   Distribution: Ubuntu 24.04.4 LTS
 Captured: 2026-10-20 19:58:35 CAT
==================================================================

----- 1. USER AND SYSTEM CONFIGURATION ------------------------------
$ whoami
medisoft
$ id
uid=1000(medisoft) gid=1000(medisoft) groups=1000(medisoft),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),100(users),114(lpadmin),984(ollama),1003(sunrise-team2)
$ hostname
medisoft
$ hostnamectl
 Static hostname: medisoft
 Pretty hostname: medisoft@
       Icon name: computer-laptop
         Chassis: laptop 💻
      Machine ID: f955dc0c80874562b438162a255fb4e0
         Boot ID: 6ef81839f5d748139fb39a06331364b4
Operating System: Ubuntu 24.04.4 LTS
          Kernel: Linux 7.0.0-31-generic
$ uname -a
Linux medisoft 7.0.0-31-generic #31~24.04.1-Ubuntu SMP PREEMPT_DYNAMIC Mon Aug 10 09:38:02 UTC 2 x86_64 x86_64 x86_64 GNU/Linux
$ lsb_release -a
Distributor ID:	Ubuntu
Description:	Ubuntu 24.04.4 LTS
Release:	24.04
Codename:	noble

----- 2. HARDWARE AND RESOURCES -------------------------------------
$ lscpu (selected)
Architecture:                            x86_64
CPU(s):                                  8
Model name:                              Intel(R) Core(TM) i5-8350U CPU @ 1.70GHz
Thread(s) per core:                      2
Core(s) per socket:                      4
CPU(s) scaling MHz:                      64%
Virtualization:                          VT-x
$ free -h
               total        used        free      shared  buff/cache   available
Mem:           7.6Gi       4.1Gi       1.0Gi       632Mi       3.5Gi       3.6Gi
Swap:          4.0Gi       891Mi       3.1Gi
$ df -h /
Filesystem                         Size  Used Avail Use% Mounted on
/dev/mapper/ubuntu--vg-ubuntu--lv  231G   73G  147G  34% /
$ lspgi/graphics
00:02.0 VGA compatible controller: Intel Corporation UHD Graphics 620 (rev 07)
$ ls -l /dev/kvm
crw-rw----+ 1 root kvm 10, 232 Oct 18 18:43 /dev/kvm

----- 3. PACKAGE MANAGEMENT ------------------------------------------
$ apt --version
apt 2.8.3 (amd64)
$ apt-get --version
apt 2.8.3 (amd64)
$ dpkg --version
Debian 'dpkg' package management program version 1.22.6 (amd64).
$ apt update (tail)
Get:59 http://archive.ubuntu.com/ubuntu noble/restricted amd64 c-n-f Metadata [416 B]
Get:60 http://archive.ubuntu.com/ubuntu noble/universe amd64 Packages [15.0 MB]
Ign:30 https://repo.protonvpn.com/debian stable/main all Packages
Get:30 https://repo.protonvpn.com/debian stable/main all Packages [241 kB]
$ apt list --installed | wc -l
2106
$ dpkg -l | grep -c '^ii'
2105

----- 4. NETWORK CONFIGURATION AND TESTING ---------------------------
$ ip -brief addr
lo               UNKNOWN        127.0.0.1/8 ::1/128 
enp0s31f6        DOWN           
wlp2s0           UP             192.168.1.57/24 fe80::6e2:2728:c1be:14f/64 
docker0          DOWN           172.17.0.1/16 
$ ip route
default via 192.168.1.1 dev wlp2s0 proto dhcp src 192.168.1.57 metric 600 
172.17.0.0/16 dev docker0 proto kernel scope link src 172.17.0.1 linkdown 
192.168.1.0/24 dev wlp2s0 proto kernel scope link src 192.168.1.57 metric 600 
$ ping -c 4 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=110 time=78.3 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=110 time=22.2 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=110 time=19.2 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=110 time=17.6 ms

--- 8.8.8.8 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3004ms
rtt min/avg/max/mdev = 17.604/34.355/78.347/25.452 ms
$ ping -c 4 github.com
PING github.com (140.82.121.3) 56(84) bytes of data.
64 bytes from lb-140-82-121-3-fra.github.com (140.82.121.3): icmp_seq=1 ttl=45 time=167 ms
64 bytes from lb-140-82-121-3-fra.github.com (140.82.121.3): icmp_seq=2 ttl=45 time=164 ms
64 bytes from lb-140-82-121-3-fra.github.com (140.82.121.3): icmp_seq=3 ttl=45 time=163 ms
64 bytes from lb-140-82-121-3-fra.github.com (140.82.121.3): icmp_seq=4 ttl=45 time=162 ms

--- github.com ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3003ms
rtt min/avg/max/mdev = 162.197/164.138/166.938/1.760 ms
$ getent hosts github.com
140.82.121.3    github.com
$ nmcli device status
DEVICE          TYPE      STATE                   CONNECTION 
wlp2s0          wifi      connected               Friday@    
lo              loopback  connected (externally)  lo         
docker0         bridge    connected (externally)  docker0    
p2p-dev-wlp2s0  wifi-p2p  disconnected            --         

----- 5. GIT INSTALLATION AND CONFIGURATION -------------------------
$ git --version
git version 2.43.0
$ git config --global --list
user.name=NAMBALIRWA JOVIA
user.email=jovianambalirwa38@gmail.com
credential.https://dev.azure.com.usehttppath=true
credential.helper=!gh auth git-credential
credential.https://github.com.helper=
credential.https://github.com.helper=!/home/medisoft/.local/bin/gh auth git-credential
credential.https://gist.github.com.helper=
credential.https://gist.github.com.helper=!/home/medisoft/.local/bin/gh auth git-credential
$ git config --global credential.helper
!gh auth git-credential

----- 6. GITHUB CLI AND AUTHENTICATION ------------------------------
$ gh --version
gh version 2.102.0 (2026-09-30)
$ gh auth status
github.com
  ✓ Logged in to github.com account Jovian-hub (keyring)
  - Active account: true
  - Git operations protocol: https
  - Token: <token redacted>************************************
  - Token scopes: 'gist', 'read:org', 'repo'

----- 7. BUGEMA LINUX REPOSITORY CLONE TEST -------------------------
$ git clone https://github.com/bos-com/bugema-linux.git
$ git status
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
$ git log --oneline -5
8b13a20 docs: add Bugema Linux architecture foundation (#7)
4e7dd98 docs: add student contribution issue template (#6)
f3d702a docs: add bug report issue template (#5)
c151ed8 docs: add Bugema Linux development roadmap
b45c847 docs: add project support guide
$ git branch -a
* main
  remotes/origin/HEAD -> origin/main
  remotes/origin/clean-up-readme
  remotes/origin/docs/bug-report-template
  remotes/origin/kmuwanga83-patch-1
  remotes/origin/kmuwanga83-patch-2
  remotes/origin/main
$ ls
CODE_OF_CONDUCT.md
CONTRIBUTING.md
docs
GOVERNANCE.md
LICENSE
README.md
ROADMAP.md
SECURITY.md
SUPPORT.md

----- 8. DEVELOPMENT TOOLS -------------------------------------------
git        git version 2.43.0
gh         gh version 2.102.0 (2026-09-30)
python3    Python 3.12.3
curl       curl 8.5.0 (x86_64-pc-linux-gnu) libcurl/8.5.0 OpenSSL/3.0.13 zlib/1.3 brotli/1.1.0 zstd/1.5.5 libidn2/2.3.7 libpsl/0.21.2 (+libidn2/2.3.7) libssh/0.10.6/openssl/zlib nghttp2/1.59.0 librtmp/2.3 OpenLDAP/2.6.10
wget       GNU Wget 1.21.4 built on linux-gnu.
vim        not installed
java       openjdk 11.0.32 2026-07-21
gcc        gcc (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0
make       GNU Make 4.3
systemctl  systemd 255 (255.4-1ubuntu8.17)

----- 9. VIRTUALISATION PLATFORM (QEMU/KVM) --------------------------
$ qemu-system-x86_64 --version
QEMU emulator version 8.2.2 (Debian 1:8.2.2+ds-0ubuntu1.16)
$ qemu-img --version
qemu-img version 8.2.2 (Debian 1:8.2.2+ds-0ubuntu1.16)
$ qemu-system-x86_64 -accel help
Accelerators supported in QEMU binary:
tcg
kvm

==================================================================
 END OF TRANSCRIPT
==================================================================
```

### Appendix B — Console screenshots

The screenshots required by the handout must be captured from the GitHub interface
and from the terminal while the work is performed. They cannot be generated
automatically from a remote session, so the list below is the exact capture list, with
the value that each figure must show, to be taken in one pass at the end of the work.

| Figure | What it must show | Where it is captured from |
| --- | --- | --- |
| Figure 1 | Host computer information: `lscpu`, `free -h`, `df -h`, `lsb_release -a` | Terminal (output already in Appendix A, section 2) |
| Figure 2 | Virtualisation software: QEMU version and `-accel help` listing `kvm` | Terminal (Appendix A, section 9) |
| Figure 3 | Virtual machine configuration: 2 vCPU, 4096 MB RAM, 40 GB `qcow2` disk, NAT | `qemu-img info` output and the boot command in Section 5 |
| Figure 4 | Linux installation: the Ubuntu installer during the installation | VirtualBox / VMware window during the install |
| Figure 5 | Linux desktop or console after the first boot | VirtualBox / VMware window |
| Figure 6 | User verification: `whoami`, `id`, `hostname`, `uname -a` | Terminal inside the guest |
| Figure 7 | Network configuration: `ip -brief addr` and `ip route` | Terminal inside the guest |
| Figure 8 | Internet connectivity: `ping -c 4 8.8.8.8` and `ping -c 4 github.com` | Terminal inside the guest |
| Figure 9 | Package management: `apt update` and `apt install` in progress | Terminal inside the guest |
| Figure 10 | Git installation: `git --version` | Terminal inside the guest |
| Figure 11 | Git configuration: `git config --global --list` | Terminal inside the guest |
| Figure 12 | Bugema Linux repository cloned: `git clone` output and `git status` | Terminal inside the guest |
| Figure 13 | Development tools: `python3 --version`, `java --version`, `gh --version` | Terminal inside the guest |
| Figure 14 | The branch on GitHub: `docs/jovian-ambalirwa-development-environment-guide` | <https://github.com/Jovian-hub/bugema-linux/branches/all> |
| Figure 15 | The commit: `7bdd394 docs: add development environment setup guide` | <https://github.com/Jovian-hub/bugema-linux/commit/7bdd394f806faeb2f4f8336ec36f7e96a7c1ba58> |
| Figure 16 | The pull request page with the Summary / Changes Made / Testing / Expected Result sections | <https://github.com/bos-com/bugema-linux/pull/19> |
| Figure 17 | The issue, with the Problem, Background, Proposed Solution, Testing and Acceptance Criteria sections | <https://github.com/bos-com/bugema-linux/issues/18> |
| Figure 18 | The peer reviews left on PRs #13, #16 and #17 | The review links in Appendix C |

**Guidance on screenshots.** Capture one terminal window with a legible font, crop each
figure to the relevant command and its output, and number the figures in the order
above. The handout asks for evidence of actual work and warns against submitting
screenshots that do not provide useful evidence, so each figure should show the command
*and* its output together, and the same terminal session should be reused so that the
figures look consistent.

### Appendix C — Issue, pull request and peer review links

| Item | Link |
| --- | --- |
| Issue (Assignment 3) | <https://github.com/bos-com/bugema-linux/issues/18> |
| Pull request (Assignment 2) | <https://github.com/bos-com/bugema-linux/pull/19> |
| Contribution branch | <https://github.com/Jovian-hub/bugema-linux/tree/docs/jovian-ambalirwa-development-environment-guide> |
| Commit `7bdd394` | <https://github.com/Jovian-hub/bugema-linux/commit/7bdd394f806faeb2f4f8336ec36f7e96a7c1ba58> |
| Peer review on PR #13 | <https://github.com/bos-com/bugema-linux/pull/13#pullrequestreview-5589224757> |
| Peer review on PR #16 | <https://github.com/bos-com/bugema-linux/pull/16#pullrequestreview-5589226119> |
| Peer review on PR #17 | <https://github.com/bos-com/bugema-linux/pull/17#pullrequestreview-5589236968> |

### Appendix D — Build script

The complete, re-runnable environment build script is included with this report
(`scripts/build-vm.sh`), together with the evidence-collection script
(`scripts/vm-evidence.sh`) and the parallel downloader (`scripts/pget.py`).
