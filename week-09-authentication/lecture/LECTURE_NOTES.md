# Week 9 Lecture: JWT, OAuth2, Secure Storage & Regulatory Compliance

**Course:** Multiplatform Mobile Software Engineering in Practice
**Duration:** ~2 hours (including Q&A)
**Format:** Student-facing notes with presenter cues

> Lines marked with `> PRESENTER NOTE:` are for the instructor only. Students can
> ignore these or treat them as bonus context.

---

## Table of Contents

1. [Authentication vs Authorization](#1-authentication-vs-authorization-10-min) (10 min)
2. [JWT Deep Dive](#2-jwt-deep-dive-25-min) (25 min)
3. [OAuth2 and OpenID Connect](#3-oauth2-and-openid-connect-20-min) (20 min)
4. [Secure Storage on Mobile Devices](#4-secure-storage-on-mobile-devices-15-min) (15 min)
5. [HIPAA and GDPR Compliance -- A Case Study from Healthcare](#5-hipaa-and-gdpr-compliance--a-case-study-from-healthcare-20-min) (20 min)
6. [Threat Modeling for Mobile Apps](#6-threat-modeling-for-mobile-apps-10-min) (10 min)
7. [Key Takeaways](#7-key-takeaways-5-min) (5 min)

---

## 1. Authentication vs Authorization (10 min)

### Two Separate Questions

Every time a user interacts with a system, two questions get asked -- often so quickly that we do not notice they are separate:

- **Authentication (AuthN):** "Who are you?" -- proving identity
- **Authorization (AuthZ):** "What are you allowed to do?" -- checking permissions after identity is verified

These are separate concerns, but they are confused so often that even experienced developers muddle them. Let's untangle them.

### Authentication: Proving Identity

Authentication is the act of proving you are who you claim to be. You have already done this in this course:

- In **Week 1**, you set up SSH keys for GitHub. That was authentication -- proving to GitHub that you are who you claim to be. Your private key served as your proof of identity.
- Username and password: the most common (and weakest) form of authentication
- Biometrics: fingerprint, face recognition
- Multi-factor: combining two or more of the above

### Authorization: Checking Permissions

Once the system knows who you are, the next question is: what are you allowed to do?

- On your GitHub repos, collaborators have "Write" access. The public has "Read" access. That is authorization.
- Admin vs regular user
- Patient vs clinician -- a patient can see their own records, a clinician can see their patients' records

### The Healthcare Example

A nurse arrives at the hospital and authenticates by tapping their badge and entering a PIN. The system now knows the nurse is Maria Nowak from the cardiology department. Authorization then determines which patient records Maria can access -- only patients in cardiology, not the psychiatric ward. Same login, different access depending on role and department.

```d2
direction: down

user: "User: I'm Dr. Smith" {style.fill: "#E3F2FD"; style.bold: true}

authn: "Authentication" {
  style.fill: "#BBDEFB"
  label: |md
    **Authentication**
    Verify identity:
    - Password correct?
    - 2FA code valid?
  |
}

authz: "Authorization" {
  style.fill: "#FFF9C4"
  label: |md
    **Authorization**
    Check permissions:
    - Role: Cardiologist
    - Can access: cardiac patients only
    - Can prescribe: yes
  |
}

granted: "Access Granted\nShow patient record" {style.fill: "#C8E6C9"; style.bold: true}
reject: "Reject" {style.fill: "#FFCDD2"; style.bold: true}
forbidden: "403 Forbidden" {style.fill: "#FFCDD2"; style.bold: true}

user -> authn
authn -> reject: "NO"
authn -> authz: "YES"
authz -> forbidden: "NO"
authz -> granted: "YES"
```

The diagram shows a clean separation: first prove identity, then check permissions. A 401 (Unauthorized) response really means "unauthenticated" -- the server does not know who you are. A 403 (Forbidden) response means "authenticated but not authorized" -- the server knows who you are, but you do not have permission.

> PRESENTER NOTE: Ask students: "In your project, what's the authentication method?
> What authorization rules do you need?" Most projects will have simple username/password
> auth with maybe a user/admin role distinction. This is a good moment to get them
> thinking about their own app's security model before diving into the technical details.

---

## 2. JWT Deep Dive (25 min)

### The Problem: Stateless Authentication

In **Week 2**, your FastAPI backend had no authentication. Anyone could create and read mood entries. That is fine for a demo, but in any real application -- especially one handling health data -- you need to know who is making each request.

The traditional approach is **server-side sessions**: the server stores a session ID and associates it with a user. But sessions have downsides:

- The server must store session data (memory or database)
- Scaling to multiple server instances means sharing session state
- Mobile apps and APIs work better with token-based authentication

JWT -- JSON Web Token -- is the modern alternative.

### What is JWT?

A JWT is a compact, self-contained token for securely transmitting information between parties. It is a string that looks like this:

```
eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1c2VyMTIzIiwiZXhwIjoxNjk5...signature
```

Three parts, separated by dots. Each part is base64url-encoded.

### The Three Parts

````d2
direction: right

header: "Header" {
  style.fill: "#E3F2FD"
  content: |md
    ```json
    {
      "alg": "HS256",
      "typ": "JWT"
    }
    ```
    base64url encoded
  |
}

payload: "Payload" {
  style.fill: "#FFF9C4"
  content: |md
    ```json
    {
      "sub": "user123",
      "role": "patient",
      "exp": 1699999999,
      "iat": 1699996399
    }
    ```
    base64url encoded
  |
}

signature: "Signature" {
  style.fill: "#E8F5E9"
  content: |md
    HMAC-SHA256(
      base64(header) +
      "." +
      base64(payload),
      secret
    )
  |
}

header -> payload -> signature: "."
````

1. **Header:** Declares the algorithm (e.g., HS256) and the token type (JWT). This tells the server how to verify the signature.

2. **Payload:** Contains "claims" -- pieces of information about the user. Standard claims include `sub` (subject -- who the token is about), `exp` (expiration time), and `iat` (issued at). You can add custom claims like `role` or `department`.

3. **Signature:** A cryptographic hash of the header and payload, combined with a secret key that only the server knows. This ensures the token has not been tampered with.

### How JWT Authentication Works

Here is the full flow from login to authenticated API calls:

1. User sends username + password to the `/login` endpoint
2. Server verifies the credentials against the database
3. Server creates a JWT with user info in the payload and signs it with a secret key
4. Server sends the JWT back to the client
5. Client stores the JWT (securely -- more on this in Section 4)
6. Client includes the JWT in every subsequent request via the `Authorization: Bearer <token>` header
7. Server verifies the signature and extracts user info from the payload -- no database lookup needed

**Analogy:** Think of a JWT like a hospital ID badge. When you arrive at work, the front desk verifies your identity (authentication) and gives you a badge. The badge has your name, photo, department, and access level printed on it. Every time you approach a door, the scanner reads your badge -- it does not call the front desk to ask who you are. The badge is self-contained.

The "signature" is like a holographic seal on the badge. If someone tries to alter the badge (change "intern" to "chief surgeon"), the seal breaks and the door scanner rejects it.

### JWT Advantages

- **Stateless:** The server does not need to store sessions. All the information is in the token itself.
- **Self-contained:** The payload carries user info, so the server can make authorization decisions without querying a database on every request.
- **Scalable:** Because no server-side state is required, any server instance can verify the token. This matters when you have multiple backend servers behind a load balancer.

### JWT Pitfalls -- The Things That Bite You

- **Tokens cannot be easily revoked.** Once issued, a JWT is valid until it expires. If a user logs out, the token is still technically valid. To revoke tokens, you need a blacklist -- which reintroduces server-side state and partially defeats the purpose of JWTs.

- **The payload is NOT encrypted -- just encoded.** Anyone who intercepts a JWT can decode the payload with a simple base64 decode. The signature ensures integrity (no tampering), not confidentiality (no reading).

  **NEVER put sensitive data in the JWT payload.** No passwords, no social security numbers, no diagnosis codes. The payload should contain only what is needed for identity and authorization: user ID, role, expiration.

- **Token expiration must be managed carefully.** The standard pattern is:
  - Short-lived **access tokens** (15 minutes) -- used for API requests
  - Long-lived **refresh tokens** (7 days) -- used to get new access tokens without re-login
  - When the access token expires, the client uses the refresh token to request a new one

> PRESENTER NOTE: Decode a JWT live using jwt.io. Copy a real JWT token from your demo
> app and paste it in. Show that the payload is readable by anyone -- the name, role,
> expiration are all visible. Emphasize: JWT is for integrity (preventing tampering),
> not confidentiality (hiding data). This is the single most important point about JWT
> that students get wrong.

### The Refresh Token Pattern

```d2
shape: sequence_diagram

client: "Client"
server: "Server"

client -> server: "1. Login (username + password)"
server -> client: "2. Access token (15 min) + Refresh token (7 days)"

client -> server: "3. API call (Authorization: Bearer)"
server -> client: "4. Data response"

client -> client: "... 15 minutes pass ..."

client -> server: "5. API call (expired access token)"
server -> client: "6. 401 Unauthorized"

client -> server: "7. Send refresh token to /refresh"
server -> client: "8. New access token (15 min)"

client -> server: "9. Retry API call with new token"
```

Why two tokens? The access token is sent with every request, so it has higher exposure. If someone intercepts it, the damage is limited to 15 minutes. The refresh token is only sent to one endpoint (`/refresh`), reducing its exposure. If the refresh token is compromised, the user will need to log in again after the server revokes it.

### JWT in Your Project

Your FastAPI backend from earlier weeks can add JWT auth with the `python-jose` or `PyJWT` library. FastAPI has built-in support for OAuth2 bearer tokens through its security utilities. In the lab this week, you are implementing exactly this flow -- register, login, and protected endpoints.

In a hospital system, a JWT might carry claims like `{"role": "nurse", "department": "cardiology", "access_level": "read_write"}`. The server can make authorization decisions from the token without querying a database on every request. When the nurse moves to a different department, you issue a new token -- the old one expires naturally.

---

## 3. OAuth2 and OpenID Connect (20 min)

### The Problem OAuth2 Solves

Imagine you are building a health app, and you want users to log in with their Google account. The naive approach: ask the user for their Google email and password, then log in to Google on their behalf. This is obviously terrible:

- The user is trusting your app with their Google password
- You now have access to their entire Google account, not just what you need
- If your app is compromised, their Google account is compromised

OAuth2 solves this: **grant an app access to your data without sharing your password.**

### OAuth2 Authorization Code Flow

This is the most common and most secure OAuth2 flow. Here is how it works:

```d2
shape: sequence_diagram

app: "Your App"
auth: "Auth Server\n(Google, Auth0, Firebase)"
resource: "Resource Server\n(your API)"

app -> auth: "1. Redirect user to login"
auth -> auth: "2. User logs in"
auth -> app: "3. Authorization code"
app -> auth: "4. Exchange code for token"
auth -> app: "5. Access token"
app -> resource: "6. API call with token"
resource -> app: "7. Data response"
```

**Step by step:**

1. Your app redirects the user to the auth server's login page (e.g., Google's sign-in page)
2. The user authenticates directly with the auth server -- your app never sees the password
3. The auth server redirects back to your app with a short-lived **authorization code**
4. Your app's backend exchanges the authorization code for an **access token** (this is a server-to-server call, invisible to the user)
5. The auth server returns the access token
6. Your app uses the access token to call APIs on behalf of the user
7. The resource server validates the token and returns the requested data

The critical insight: **your app never sees the user's password.** The user authenticates directly with a trusted provider (Google, Apple, etc.), and your app receives a limited-scope token.

### OpenID Connect: Authentication on Top of OAuth2

OAuth2 was designed for **authorization** -- granting access to resources. It answers "what can this app do?" but not "who is this user?"

OpenID Connect (OIDC) is a thin authentication layer built on top of OAuth2. It adds:

- An **ID token** (a JWT) that contains the user's identity information (name, email, profile picture)
- A standard `/userinfo` endpoint
- Standardized "scopes" like `openid`, `profile`, `email`

In short:
- **OAuth2** = authorization ("What can the app access?")
- **OIDC** = authentication ("Who is the user?") built on top of OAuth2

When someone says "Login with Google," they are using OIDC. The app gets both an access token (to access Google APIs) and an ID token (to know who the user is).

### For Your Course Project

You have several options, from simplest to most robust:

- **Simple approach:** Custom JWT auth with your FastAPI backend. You handle registration, login, and token generation yourself. This is what you are implementing in the lab this week, and it is sufficient for the course project.

- **Intermediate:** Firebase Auth or Supabase Auth. These services handle user management, token generation, email verification, password resets, and social login for you. The `firebase_auth` Flutter package makes Google Sign-In about 20 lines of code.

- **Production:** A managed auth provider like Auth0, Okta, or AWS Cognito. These are enterprise-grade solutions with compliance certifications.

**The golden rule: do not build your own auth system from scratch in production.** Authentication is one of the hardest things to get right in software. Use a battle-tested solution. For learning purposes in this course, rolling your own JWT auth teaches you the fundamentals. For a real health app, delegate to a proven provider.

> PRESENTER NOTE: If time allows, show Firebase Auth setup in Flutter as a quick demo.
> The firebase_auth package makes Google Sign-In straightforward. Contrast this with
> implementing OAuth2 from scratch -- the difference in complexity is dramatic and makes
> the case for using managed auth services. Don't spend more than 5 minutes on this demo.

### Healthcare Connection: Single Sign-On

In clinical environments, Single Sign-On (SSO) with OAuth2/OIDC is standard. A clinician logs in once and can access the EHR, the lab system, and the scheduling system without re-authenticating. This reduces **password fatigue** -- clinicians who have to log in 20 times per shift will inevitably choose weak passwords or write them on sticky notes. SSO improves both security and workflow efficiency.

---

## 4. Secure Storage on Mobile Devices (15 min)

### The Question You Must Answer

You have a JWT token after login. Now where do you store it?

This seems like a trivial question, but getting it wrong can expose every user's authentication credentials. Let's look at the options.

### Wrong Answers

**SharedPreferences (Android) / UserDefaults (iOS):**
Stored as plaintext XML or plist files on disk. Anyone with physical access to the device (or a backup) can read them. On rooted/jailbroken devices, any app can read another app's SharedPreferences.

**Hardcoded in source code:**
This is worse than it sounds. Your source code ends up in git repositories and compiled APK/IPA files. APKs can be decompiled in minutes. If you hardcode an API key or token, it is public.

**Global variable in memory:**
Lost on app restart. The user has to log in every time they open the app. Not a security risk per se, but terrible user experience.

### The Right Answer: Platform Secure Storage

Flutter provides the `flutter_secure_storage` package, which wraps each platform's native secure storage mechanism:

- **iOS: Keychain** -- Hardware-backed encryption. Data is encrypted using keys derived from the device's Secure Enclave (a dedicated security chip). Even if someone clones the device's storage, they cannot decrypt Keychain items without the hardware.

- **Android: Keystore + EncryptedSharedPreferences** -- The Android Keystore generates and stores cryptographic keys in hardware (on devices that support it). EncryptedSharedPreferences uses these keys to encrypt the data at rest.

Both approaches ensure that stored secrets are:
- Encrypted at rest (unreadable without the device lock)
- Protected by the device's PIN, password, or biometric lock
- Inaccessible to other apps (sandboxed)

### What to Store Securely

- Access tokens and refresh tokens
- Encryption keys for local databases
- API keys (if they absolutely must be on the client)
- Biometric authentication configuration

### What NOT to Store -- Even in Secure Storage

- **Passwords:** Passwords should only exist momentarily during the login request and then be discarded. The server stores a hash, never the plaintext password. The client should not persist passwords at all.

- **Large datasets:** Secure storage is designed for small secrets (keys, tokens), not bulk data. If you need to encrypt a local SQLite database with patient records, use a database-level encryption solution like SQLCipher, not secure storage.

### Biometric Authentication

Modern devices support fingerprint and face recognition. The `flutter_secure_storage` package can require biometric verification before releasing a stored secret:

"Unlock the health app with your fingerprint" -- this is both convenient and secure.

But biometric auth has an important limitation: it verifies the **device user**, not the **server user**. A fingerprint unlock proves that the person holding the phone is its owner. It does not prove anything to your backend server. Biometric auth is a complement to server-side authentication (JWT), not a replacement.

> PRESENTER NOTE: Demo flutter_secure_storage in a quick code example -- write a token,
> read it back, clear it. If you have time, show that the stored value does not appear
> in SharedPreferences or app data files. Emphasize the difference between "encrypted at
> rest" (secure storage) and "plaintext" (SharedPreferences). Students who have used
> SharedPreferences before will understand the contrast immediately.

### Healthcare Connection

If a nurse's phone with a health app is stolen, the authentication tokens should be unreadable without the device lock (PIN/biometric). `flutter_secure_storage` provides this protection automatically. Combined with short-lived access tokens (from Section 2), the exposure window is limited: even if someone bypasses the device lock, the access token expires in 15 minutes, and the refresh token can be revoked server-side.

---

## 5. HIPAA and GDPR Compliance -- A Case Study from Healthcare (20 min)

### Why Developers Need to Understand Regulations

You are building a health app. The data you handle -- mood entries, symptoms, medications, vitals -- is among the most sensitive personal information that exists. Two regulatory frameworks govern how you must handle this data, depending on your users' location.

Your course project will not be audited for compliance. But if you are building health apps professionally, these regulations are non-negotiable. Violations carry fines that can bankrupt a company and, more importantly, erode patient trust in digital health tools.

### GDPR Recap (European Union)

The General Data Protection Regulation applies to all personal data of EU residents, regardless of where the organization is based. Health data is classified as "special category data" requiring extra protections.

Key requirements:

- **Consent:** Explicit, informed consent before collecting health data. Pre-ticked checkboxes do not count.
- **Data minimization:** Collect only what you need. If your mood tracker does not need the user's home address, do not ask for it.
- **Right to access:** Users can request a copy of all their data.
- **Right to deletion:** Users can request that their data be permanently deleted ("right to be forgotten").
- **Breach notification:** You must notify the relevant data protection authority within 72 hours of discovering a breach.
- **Data Protection Impact Assessment (DPIA):** Required for high-risk processing, which includes health data.

### HIPAA (United States)

The Health Insurance Portability and Accountability Act applies to "covered entities" (hospitals, clinics, health insurers) and their "business associates" -- any company that handles Protected Health Information (PHI) on their behalf.

**Protected Health Information (PHI):** Any health information that can be linked to a specific individual. This includes:

- Medical records and diagnoses
- Treatment information
- Lab results
- Mental health notes
- Billing information for health services
- Even the fact that someone is a patient at a particular facility

**HIPAA has three main rules:**

1. **Security Rule** -- Technical safeguards for electronic PHI (ePHI):
   - Encryption in transit (HTTPS -- you have been doing this already)
   - Encryption at rest (encrypted databases, secure storage)
   - Access controls (role-based, minimum necessary access)
   - Audit logs (who accessed what, when, and why)
   - Backup and disaster recovery procedures

2. **Privacy Rule** -- Limits who can access PHI and for what purpose:
   - Minimum necessary standard: only access the PHI you need for your specific task
   - Patient rights: access, amendment, accounting of disclosures
   - Notice of Privacy Practices: inform patients how their data is used

3. **Breach Notification Rule:**
   - Notify affected individuals within 60 days
   - Notify the Department of Health and Human Services
   - If the breach affects 500+ individuals, notify the media

### GDPR vs HIPAA: Key Differences

| Aspect | GDPR | HIPAA |
|---|---|---|
| Scope | All personal data (EU residents) | Health data only (US) |
| Applies to | All organizations | Covered entities + business associates |
| Right to deletion | Yes | No -- requires 6-year retention |
| Breach notification | 72 hours | 60 days |
| Consent | Explicit consent required | Authorization for uses beyond treatment/payment/operations |
| Fines | Up to 4% of global revenue or 20M EUR | Up to $1.9M per violation category per year |
| Encryption | Required for sensitive data | "Addressable" -- must implement or document why not |

Both frameworks share the core principles: encrypt data, control access, log activity, and notify people when things go wrong.

> PRESENTER NOTE: Show real examples of HIPAA/GDPR violations and their fines. The numbers
> are attention-grabbing and make the point that compliance matters. For example: "In 2023,
> a healthcare provider was fined $1.3 million for storing patient data on an unencrypted
> laptop that was stolen from an employee's car." Another: "A health app was fined under
> GDPR for sharing user mental health data with advertising networks without explicit
> consent." These stories stick with students.

### Practical Implications for Your App

Even though your course project is not subject to regulatory audit, building with compliance in mind teaches good habits:

1. **Use HTTPS everywhere** -- never transmit health data over plain HTTP
2. **Encrypt local health data** -- use SQLCipher or an encrypted database for any stored patient information
3. **Store tokens in secure storage** -- as discussed in Section 4
4. **Implement proper logout** -- clear tokens, cached data, and any locally stored health information
5. **Never log patient data to console or crash reports** -- a `print(patient_record)` statement during debugging can end up in crash analytics services
6. **Add timestamps to all records** -- this creates an audit trail showing when data was created and modified
7. **Implement role-based access** -- even if your app only has two roles (patient/clinician), the pattern matters

---

## 6. Threat Modeling for Mobile Apps (10 min)

### Thinking Like an Attacker

Before you deploy a health app, you need to think about who might attack it and how. This is called **threat modeling** -- systematically identifying what could go wrong and planning mitigations before they happen.

Security is much cheaper to build in than to bolt on later. Retrofitting security into a finished app is like adding a fire escape to a building after construction -- possible, but expensive and ugly.

### The STRIDE Model

Microsoft's STRIDE model provides a structured way to think about threats. Each letter represents a category:

| Threat | Question | Health App Example |
|---|---|---|
| **S**poofing | Can someone pretend to be another user? | Attacker logs in as a patient and reads their records |
| **T**ampering | Can someone modify data? | Attacker changes a medication dosage in transit |
| **R**epudiation | Can someone deny performing an action? | Clinician claims they never prescribed a dangerous drug |
| **I**nformation Disclosure | Can sensitive data leak? | Patient mental health notes appear in a data breach |
| **D**enial of Service | Can the system be made unavailable? | Attack floods the server during a medical emergency |
| **E**levation of Privilege | Can someone gain unauthorized access? | Patient account gains admin/clinician privileges |

You do not need to memorize the STRIDE categories. The point is to have a structured way to brainstorm threats rather than hoping you will think of everything ad hoc.

### Common Attack Vectors for Mobile Health Apps

**Stolen device:** Physical access to the phone. The attacker can try to extract data from the app's local storage, read cached files, or use the app if it has no lock screen.

**Man-in-the-middle (MITM):** Intercepting network traffic between the app and the server. On public Wi-Fi, this is straightforward without HTTPS.

**Reverse engineering:** Decompiling the APK (Android) or IPA (iOS) to extract hardcoded secrets, API keys, or understand the app's logic. Tools like `jadx` (Android) and `Hopper` (iOS) make this surprisingly easy.

**Server compromise:** Attacking the backend through SQL injection, authentication bypass, or exploiting unpatched vulnerabilities.

**Social engineering:** Tricking users into revealing credentials. Phishing emails that mimic the app's login screen, fake "security alerts" that ask users to re-enter their password.

### Mitigations You Already Know

The good news: most of what you have learned in this lecture directly mitigates these threats.

| Threat | Mitigation |
|--------|-----------|
| Stolen device | Secure storage, biometric lock, short-lived tokens |
| Man-in-the-middle | HTTPS, certificate pinning |
| Reverse engineering | Don't store secrets in the app, keep sensitive logic server-side |
| Server compromise | Encrypt stored data, hash passwords, parameterized queries (no SQL injection) |
| Social engineering | Clear UI that users trust, email verification, multi-factor auth |

None of these mitigations are perfect individually. Security is about **layers** -- each layer makes the attacker's job harder. The goal is not to be unbreakable (nothing is) but to be hard enough to attack that adversaries move on to easier targets.

### Healthcare Connection

A threat model for a mental health app should consider: what happens if a user's therapy notes are leaked? The emotional and social harm could be devastating -- stigma around mental health conditions, impact on employment, damage to personal relationships. Security is not just about regulatory compliance or technical elegance. It is about protecting vulnerable people who trusted your app with their most sensitive information.

> PRESENTER NOTE: This section is intentionally high-level. Don't go deep into any
> single attack vector. The goal is awareness -- students should think about security
> proactively, not as an afterthought. If a student asks about a specific attack in
> detail, suggest they look at the OWASP Mobile Security Top 10 in the Further Reading.

---

## 7. Key Takeaways (5 min)

1. **Authentication verifies identity** (who you are); **authorization controls access** (what you can do) -- keep them separate in your thinking and your code

2. **JWT provides stateless, self-contained authentication tokens** -- but they are NOT encrypted, just signed. Never put sensitive data in the payload.

3. **OAuth2/OIDC delegates authentication to trusted providers** -- do not build auth from scratch in production. For learning, implement it yourself; for shipping, use Firebase, Auth0, or similar.

4. **Store tokens in secure storage** (Keychain on iOS, Keystore on Android via flutter_secure_storage), never in SharedPreferences or source code

5. **HIPAA (US) and GDPR (EU) mandate encryption, access controls, audit logs, and breach notification** for health data -- violations carry severe fines and erode patient trust

6. **Think about threats early** -- security is much cheaper to build in than to bolt on later. Use structured approaches like STRIDE to identify risks before they become incidents.

### What's Next

In the lab this week, you are putting all of this into practice. You will add login and registration to your project app, implement JWT authentication on your FastAPI backend, store tokens using `flutter_secure_storage`, and protect your API endpoints so that unauthenticated requests receive a 401 response. The mood data that was previously open to anyone will now require authentication.

> PRESENTER NOTE: Add a login screen to the Mood Tracker demo. Show: (1) register
> endpoint on FastAPI that hashes the password and returns a JWT, (2) login endpoint
> that verifies credentials and returns a JWT, (3) Flutter login screen that stores the
> token in secure storage, (4) API client that includes the token in the Authorization
> header. Emphasize that the mood data endpoints now require authentication --
> unauthenticated requests get 401. Walk through the code, pointing out where each
> concept from the lecture appears in practice.

---

## Further Reading

If you want to go deeper on any topic covered today:

- **JWT interactive debugger:** [JWT.io](https://jwt.io/) -- paste a token and see its decoded contents
- **OAuth2 simplified:** [Aaron Parecki's OAuth2 Guide](https://aaronparecki.com/oauth-2-simplified/) -- the clearest explanation of OAuth2 on the internet
- **flutter_secure_storage:** [pub.dev/packages/flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) -- API docs and platform-specific details
- **HIPAA for developers:** [HHS HIPAA Security Rule](https://www.hhs.gov/hipaa/for-professionals/security/index.html) -- the official source
- **GDPR for developers:** [GDPR.eu](https://gdpr.eu/) -- plain-language guide to GDPR requirements
- **OWASP Mobile Security Top 10:** [OWASP Mobile Top 10](https://owasp.org/www-project-mobile-top-10/) -- the most common mobile security risks
- **Firebase Auth for Flutter:** [Firebase Auth Getting Started](https://firebase.google.com/docs/auth/flutter/start) -- if you want to use a managed auth provider
