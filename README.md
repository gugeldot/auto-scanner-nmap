# Port Scanner with Version Detection

A simple Bash script that performs **fast port scanning** and **version detection** on a target IP using `nmap`. Optional saving of results and spinner animations indicate progress.

---

## Usage

```bash
./port_scan.sh <IP> [--save]

```
Examples

Scan without saving:
```bash
./port_scan.sh 10.10.11.152

```
Scan and save results:

```bash
./port_scan.sh 10.10.11.152 --save

```
- simplescan.txt → Fast scan open ports.

- detailedscan.txt → Detailed version/script scan.

## Features
- Fast full TCP port scan (nmap -sS)
- Version and script detection (nmap -sCV)
- Optional saving of results
- Spinner animations for progress
