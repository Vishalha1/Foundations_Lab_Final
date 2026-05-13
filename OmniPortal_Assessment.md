# OMNI-PORTAL ASSESSMENT REPORT

**Operator:** Vishal Harbance  
**Deadline:** April 5 @ 11:59 PM  

---

## PHASE 1: AUTH BYPASS (SQLi)

* **Payload Used:** `' OR '1'='1' --`

* **Result:** Successfully bypassed the login page and obtained an `auth_token` cookie.

* **Explanation:**  
The login form was vulnerable to SQL Injection because user input was not safely handled before being placed into the SQL query. The payload created a true condition, which allowed the login check to be bypassed without using a valid password.

---

## PHASE 2: CLIENT-SIDE HIJACK (XSS)

* **Stored XSS Payload:** `<script>alert(document.cookie)</script>`

* **Secret Cookie Captured:** auth_token=SUPPORT_TIER_1_SECRET_TOKEN

* **Explanation:**  
The support board was vulnerable to Stored Cross-Site Scripting because it allowed JavaScript code to be saved as a comment and executed when the page loaded. When the payload ran, it displayed the browser cookie, including the `auth_token`.

---

## PHASE 3: API ENUMERATION (BOLA)

* **Original Order Endpoint:** `/api/v2/orders/502`

* **Insecure Order ID Found:** PASTE_THE_ORDER_ID_HERE

* **Confidential Data Leaked:**  

Order ID: PASTE_ID_HERE  
Order Name: Confidential Server Lease  
Dollar Amount: PASTE_DOLLAR_AMOUNT_HERE  
Details: PASTE_FULL_CONFIDENTIAL_ORDER_DETAILS_HERE  

* **Explanation:**  
The API was vulnerable to Broken Object Level Authorization, also called BOLA. The order ID in the URL could be changed to view orders that did not belong to the logged-in user. The backend did not properly check whether the user connected to the `auth_token` was allowed to access the requested order.

---

## PHASE 4: THE REMEDIATION

* **Fix for SQLi:**  
The developer should use parameterized queries or prepared statements. User input should never be directly placed inside SQL commands. Prepared statements separate user input from SQL logic, which prevents SQL Injection.

* **Fix for XSS:**  
The developer should sanitize and encode user input before displaying it on the page. User comments should be treated as plain text, not executable JavaScript. The application should also block dangerous tags like `<script>` and use output encoding.

* **Fix for API BOLA:**  
The orders endpoint needs object-level authorization checks. Before returning an order, the backend should verify that the logged-in user owns that specific order ID. The backend should check both the `auth_token` user identity and the requested order ID before sending any private order data.

---

## FINAL SUMMARY

The Titan Omni-Portal had three major vulnerabilities: SQL Injection, Stored XSS, and API BOLA. First, I bypassed the login page using a SQL tautology payload. Next, I used Stored XSS on the support board to reveal the `auth_token` cookie. Finally, I used Burp Suite Repeater to change the order ID in the API request and access confidential order data that should not have been visible to my account.

These issues could be fixed by using prepared statements, encoding user input, and enforcing proper object-level authorization on the backend API.
