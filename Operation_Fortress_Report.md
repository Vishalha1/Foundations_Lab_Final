cat > ~/TLAB11/Operation_Fortress_Report.md <<'EOF'
# OPERATION FORTRESS: DEFENSE IN DEPTH REPORT

**Operator:** Vishal Harbance  
**Assignment:** W11 TLAB 11 — Operation Fortress  
**Topic:** Defense in Depth  

---

## LAYER 1: PERIMETER FIREWALL — iptables

**Objective:** Block egress to C2 Subnet 198.51.100.0/24

**Rule Used:**  
iptables -A OUTPUT -d 198.51.100.0/24 -j DROP

**Explanation:**  
This rule blocks outbound traffic from the host to the attacker Command and Control subnet 198.51.100.0/24. The rule uses the OUTPUT chain because the goal is to stop traffic leaving the machine. This is the first layer of defense because it prevents the endpoint from communicating with known attacker infrastructure.

---

## LAYER 2: NETWORK IDS — Suricata

**Objective:** Detect web shell execution cmd=whoami

**Signature Used:**  
alert tcp any any -> any 80 (msg:"Operation Fortress web shell cmd whoami detected"; content:"cmd=whoami"; sid:1000001; rev:1;)

**Explanation:**  
This Suricata rule alerts on TCP traffic going to port 80 when the exact content string cmd=whoami appears. This detects the web shell exploit attempt at the network layer. It is the second layer of defense because it can alert defenders when suspicious web traffic crosses the network.

---

## LAYER 3: ENDPOINT SECURITY — Sysmon

**Objective:** Alert on payload download via curl

**XML Condition Used:**  
<CommandLine condition="contains">curl http://198.51.100.5</CommandLine>

**Explanation:**  
This Sysmon condition detects a process creation event when the command line contains curl http://198.51.100.5. This catches post-exploitation behavior on the endpoint when the attacker tries to download a payload. It is the third layer of defense because it can detect malicious activity directly on the host.

---

## DEFENSE IN DEPTH SUMMARY

Operation Fortress uses three independent layers of defense. The firewall blocks outbound communication to the attacker Command and Control subnet. The Suricata IDS rule detects the web shell exploit string cmd=whoami in HTTP traffic. The Sysmon XML rule detects the payload download command running on the endpoint. Together, these controls create Defense in Depth because each layer gives defenders another chance to block, detect, or respond to the attack if another layer fails.
EOF
