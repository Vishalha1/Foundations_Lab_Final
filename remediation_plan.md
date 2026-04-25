# CLOUDNANO REMEDIATION PLAN

**Operator:** Vishal  
## TOP 5 CRITICAL FIXES

1. **Unauthenticated AWS S3 Bucket Containing Customer PII**
   * **Justification:** I picked this first because the likelihood and impact are both very high. If the bucket is public, an attacker could access customer personal information without needing to exploit a server.

2. **Remote Code Execution in Apache Struts on Internet-Facing Web Server**
   * **Justification:** I picked this because it is internet-facing and could allow an attacker to run commands on the server. This creates a high chance of full system compromise.

3. **SQL Injection in Login Page on Customer Database Portal**
   * **Justification:** I picked this because the login page connects to customer data. If exploited, an attacker could bypass authentication, steal data, or modify database records.

4. **Outdated PHP Version 5.4 on Public Marketing Blog**
   * **Justification:** I picked this because the system is public-facing and uses very old software. Even if it is only a marketing blog, attackers could use it as an entry point into the company.

5. **Cross-Site Scripting on Support Forum**
   * **Justification:** I picked this because a support forum is likely used by real customers or employees. An attacker could use XSS to steal sessions, redirect users, or perform actions as another user.

## Lower Priority Findings

- **Default Credentials on Internal Router:** This has a CVSS 10.0 score, but the router is air-gapped with no physical access, so the real-world likelihood is lower.
- **SMBv1 Enabled on Internal HR File Server:** This is serious, but it is internal and not as immediately reachable as the public-facing and customer-data issues.
- **Missing HSTS Header:** This should be fixed, but it is less urgent than direct data exposure, RCE, or SQL injection.
- **Directory Listing Enabled on Internal Wiki:** This is a weakness, but it is internal and has lower impact than the top five.
- **TLS 1.0 Supported on Legacy Mail Server:** This should be remediated, but it is not as urgent as exposed customer PII or internet-facing compromise paths.

## Summary

The top five fixes were chosen based on realistic business risk, not CVSS score alone. I prioritized vulnerabilities that are public-facing, expose customer data, or could lead to full system compromise. The highest priority is the unauthenticated S3 bucket because it directly exposes customer PII.
