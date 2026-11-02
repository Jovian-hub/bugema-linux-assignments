# ASSIGNMENT — CROSS-VM QA, PEER TESTING, AND PULL REQUEST REVIEW

**Student Name:** NAMBALIRWA JOVIA  
**Registration Number:** 24/BCC/BU/R/0003  
**Programme:** Bachelor of Computer Science (BCC)  
**Course:** Open-Source Systems and Linux Development  
**GitHub Username:** [Jovian-hub](https://github.com/Jovian-hub)  
**Assignment:** Week 2 — Quality Assurance and Collaborative Development  
**Deadline:** 2 November 2026  
**Date Submitted:** 2 November 2026  

---

## 1. Practical Deliverables Summary

| Deliverable | Value / Evidence Link |
|---|---|
| **Classmate Contribution Tested** | Sharon Talemwa (`talemwasharon`) — Linux VM Administration and Diagnostics Report |
| **Contribution Issue** | [bos-com/bugema-linux#27](https://github.com/bos-com/bugema-linux/issues/27) (*Safe Diagnostic Scenario A*) / Issue #8 |
| **Contribution Pull Request** | [bos-com/bugema-linux#30](https://github.com/bos-com/bugema-linux/pull/30) |
| **Contribution Commit Tested** | [`d585d312c583fbfab87a0a2dca81fe4a90da9855`](https://github.com/bos-com/bugema-linux/commit/d585d312c583fbfab87a0a2dca81fe4a90da9855) |
| **QA Test Branch** | `test/issue-27-peer-qa` |
| **QA Peer Review Pull Request** | [bos-com/bugema-linux#36](https://github.com/bos-com/bugema-linux/pull/36) |
| **Substantive Review Comment on PR #30** | [PR #30 Comment Link](https://github.com/bos-com/bugema-linux/pull/30#issuecomment-6583854200) |
| **Primary Submission Report** | [`docs/testing/peer-test-report.md`](docs/testing/peer-test-report.md) |
| **Test Environment** | Dell Latitude 7390, Ubuntu 24.04.4 LTS, Kernel Linux 7.0.0-31-generic, 7.6 GiB RAM |

---

## 2. Objective & Scope

The objective of this assignment is to validate a classmate's contribution on an independent Linux system, record reproducible test results with zero fabrication, and provide constructive, substantive peer review via GitHub.

The selected contribution is **talemwasharon's** Pull Request [#30](https://github.com/bos-com/bugema-linux/pull/30) (`docs: add VM administration and diagnostics report`), which documents system identification, 10 diagnostic commands, and two diagnostic scenarios (USB device initialisation errors and memory pressure analysis).

---

## 3. Test Environment Specifications

Independent host environment used for testing on 2 November 2026:
- **Operating System:** Ubuntu 24.04.4 LTS (Noble Numbat)
- **Kernel Version:** Linux `7.0.0-31-generic` x86_64 (`#31~24.04.1-Ubuntu SMP PREEMPT_DYNAMIC`)
- **Hardware Platform:** Dell Inc. Latitude 7390 (physical laptop)
- **CPU:** Intel(R) Core(TM) i5-8350U CPU @ 1.70GHz (4 cores, 8 threads, VT-x hardware virtualization)
- **Memory (RAM):** 7.6 GiB total (5.0 GiB used, 771 MiB free, 2.7 GiB available), 4.0 GiB swap (958 MiB used)
- **Storage:** 238.5 GB NVMe SSD (`/dev/mapper/ubuntu--vg-ubuntu--lv` 231 GB total, 138 GB available / 38% used)
- **Network Configuration:** Ethernet `enp0s31f6` (UP, `192.168.1.188/24`), Wi-Fi `wlp2s0` (UP, `192.168.1.57/24`), `docker0` (DOWN)
- **Shell:** GNU bash 5.2.21(1)-release

---

## 4. Summary of Verification & Peer Review Findings

### 4.1 Diagnostic Commands Verification
All 10 commands documented in Section 2 of PR #30 were re-run live and confirmed reproducible:
1. `hostnamectl` — **PASS**
2. `cat /etc/os-release` — **PASS**
3. `uname -a` — **PASS**
4. `lscpu` — **PASS**
5. `free -h` — **PASS**
6. `df -h` — **PASS**
7. `lsblk` — **PASS**
8. `ip addr` — **PASS**
9. `systemctl --failed` — **PASS** (reflects host state; 1 unit `vmware.service` failed on reviewer env vs 0 on author env)
10. `journalctl -b -p warning --no-pager` — **PASS**

### 4.2 Key Findings Submitted in Peer Review
- **Finding 1 (Issue Reference):** The PR description contains the template placeholder `Closes #N` and Section 1 cites `Issue: #31` (which is Agatha's PR). Recommended updating to Issue #27 / #8.
- **Finding 2 (Missing Evidence Files):** Section 2 documents 10 diagnostic commands, but only 2 raw text evidence files (`hostnamectl.txt` and `usb-kernel.txt`) are committed under `docs/administration/evidence/`. The other 8 commands lack `.txt` evidence files.
- **Finding 3 (Sensitive Identifiers):** In `evidence/hostnamectl.txt`, `Machine ID` and `Boot ID` are unredacted while the hostname is redacted. Recommended masking Machine ID for privacy compliance.
- **Finding 4 (Host Context):** `hostnamectl` indicates a physical Dell OptiPlex desktop rather than a VM. Recommended adding an explanatory note in Section 1.

### 4.3 Tooling & Automated Checks
- **Bash Health-Check Script:** PR #30 contains documentation only; no shell script is present (`bash -n` is N/A).
- **ShellCheck:** Checked locally; ShellCheck is not installed in the reviewer environment (recorded per instructions).

---

## 5. Peer Review Record

- **PR Reviewed:** [bos-com/bugema-linux#30](https://github.com/bos-com/bugema-linux/pull/30)
- **Reviewer:** [Jovian-hub](https://github.com/Jovian-hub)
- **Review Type:** Substantive Review Comment
- **Direct Link:** [https://github.com/bos-com/bugema-linux/pull/30#issuecomment-6583854200](https://github.com/bos-com/bugema-linux/pull/30#issuecomment-6583854200)

---

## 6. Full Report Document

The full, unabridged peer QA test report is maintained in:
- Upstream Pull Request: [bos-com/bugema-linux#36](https://github.com/bos-com/bugema-linux/pull/36)
- Local Path: [`docs/testing/peer-test-report.md`](docs/testing/peer-test-report.md)
