# TITANCORP: PERIMETER ASSESSMENT REPORT
**Operator:** Vishal Harbance  
**Target Subnet:** 172.88.0.0/24

## PHASE 1: ACTIVE ENUMERATION (NMAP)
Nmap identified three live hosts on the 172.88.0.0/24 subnet.

* **Host 1 (172.88.0.10):** 80/tcp open http - nginx 1.14.2
* **Host 2 (172.88.0.15):** 6379/tcp open redis - Redis key-value store 8.6.2
* **Host 3 (172.88.0.20):** 80/tcp open http - Apache httpd 2.4.66 ((Unix))

## PHASE 2: VULNERABILITY AUDIT (NIKTO)
Nikto was run against the two web servers discovered during the Nmap scan.

* **Web Server 1 Finding:** 172.88.0.10 is missing the anti-clickjacking X-Frame-Options header. Nikto also showed that the server leaks inode information through ETags.

* **Web Server 2 Finding:** 172.88.0.20 has the HTTP TRACE method enabled, suggesting the host may be vulnerable to Cross-Site Tracing. Nikto also showed that the X-Frame-Options header is missing and the server leaks inode information through ETags.

## PHASE 3: RISK TRIAGE
After reviewing the Nmap and Nikto results, the single highest-risk issue is the exposed Redis cache database on 172.88.0.15 running on port 6379.

* **Top Priority Remediation:** Restrict access to the Redis service on 172.88.0.15 and make sure it is protected with proper authentication and network controls.

* **Justification:** This is the highest risk because the likelihood is high since the Redis service is reachable on the scanned subnet, and the impact is high because an exposed cache database may contain sensitive information or be abused if access controls are weak. Based on Likelihood x Impact, this should be fixed before the missing web security headers.
