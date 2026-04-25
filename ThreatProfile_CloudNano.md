# TARGET THREAT PROFILE: CloudNano

**Classification:** Passive Security Audit  
**Operator:** Vishal  

---

## 1. Subdomain Discovery

**Tool Used:** Sublist3r  
**Proxy Target Used:** yahoo.com  

**Subdomains Found:**
* weather.yahoo.com
* sports.yahoo.com
* shopping.yahoo.com
* travel.yahoo.com
* tech.yahoo.com
* uk.yahoo.com
* sg.yahoo.com
* video.search.yahoo.com

These subdomains show that the target has many public-facing services. A large number of subdomains increases the attack surface because each service must be secured, updated, and monitored.

---

## 2. Tech Stack Mapping

**Tool Used:** BuiltWith / Wappalyzer  

**Identified Technologies:**
* HTTPS / TLS encryption
* CDN or edge caching service
* JavaScript-based web application components
* Web analytics or advertising tracking technologies

These technologies show that the target uses modern web infrastructure. However, public technology information can help attackers understand what tools, frameworks, and services the organization depends on.

---

## 3. Major Exposure Points & Dangers

1. **Large Public Subdomain Footprint:**  
   Sublist3r discovered many public subdomains, including weather.yahoo.com, sports.yahoo.com, shopping.yahoo.com, travel.yahoo.com, and tech.yahoo.com. This is dangerous because every public subdomain is another possible place for outdated software, weak login pages, or misconfigured services.

2. **Public Technology Fingerprinting:**  
   Tools like BuiltWith and Wappalyzer can reveal technologies used by a website without directly attacking it. This is dangerous because attackers can use the same information to plan targeted attacks against known technologies.

3. **Credential Leak Risk:**  
   If employee emails or old accounts connected to the domain appear in breach databases, attackers may try password reuse or credential stuffing. This is dangerous because one leaked password could lead to unauthorized access if MFA is not enabled.

---

## Summary

This passive security audit mapped public-facing assets without directly attacking the target. The main risks found were a large public subdomain footprint, public technology fingerprinting, and possible credential exposure. The organization should monitor public assets, reduce unnecessary exposure, enforce MFA, and regularly check for leaked credentials.
