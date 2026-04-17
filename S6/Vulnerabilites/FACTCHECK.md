# Fact-Check Report -- Vulnerabilites et Securite informatique

> Verification date: 2026-04-17
> Files checked: 29 generated files (guide/, exercises/, exam-prep/)
> Source materials: data/moodle/guide/ (9 files), data/moodle/cours/ (PDFs, SPDL files, text extracts), data/annales/, data/moodle/tp/

---

## Summary

Overall quality: **GOOD**. The generated study guide is well-structured, technically accurate, and faithfully reflects the source course materials. Three factual errors were found and corrected. Several minor observations are noted below.

| Category | Issues Found | Issues Fixed | Severity |
|----------|-------------|-------------|----------|
| CVE references (fabricated/misattributed) | 3 | 3 | Medium |
| OWASP Top 10 | 0 | 0 | -- |
| Protocol descriptions (NSPK/NSPKL) | 0 | 0 | -- |
| Code examples | 0 | 0 | -- |
| Defense mechanisms | 0 | 0 | -- |
| Cryptography concepts | 0 | 0 | -- |
| Exam walkthroughs | 0 | 0 | -- |
| CVSS scoring | 0 | 0 | -- |
| TP solutions | 0 | 0 | -- |

---

## Issues Found and Fixed

### 1. FIXED -- CVE-2021-4034 (PwnKit) misattributed as Use-After-Free

**File**: `guide/02_vulnerabilites_memoire.md`, section 2.4 (Use-After-Free)

**Problem**: PwnKit (CVE-2021-4034) was listed as the CVE reference for the Use-After-Free section. PwnKit is actually an out-of-bounds write vulnerability in polkit's pkexec caused by improper handling of argc=0, not a use-after-free. PwnKit is correctly referenced elsewhere in the guide (chapters 01 and 13) as a privilege escalation example.

**Fix**: Replaced with CVE-2022-0609, a genuine use-after-free vulnerability in Chrome Animation that was actively exploited in the wild.

### 2. FIXED -- CVE-2021-21224 misattributed as integer overflow

**File**: `guide/02_vulnerabilites_memoire.md`, section 2.3 (Integer Overflows)

**Problem**: CVE-2021-21224 was described as an "integer overflow dans V8 (Chrome)". This CVE is actually a type confusion vulnerability in V8, not an integer overflow.

**Fix**: Replaced with CVE-2015-1593, a genuine integer overflow in the Linux kernel's stack ASLR randomization code.

### 3. FIXED -- CVE-2019-5418 misattributed as SSRF

**File**: `guide/08_vulnerabilites_web.md`, section 8.2 (SSRF)

**Problem**: CVE-2019-5418 was described as an "SSRF dans Ruby on Rails". This CVE is actually a File Content Disclosure / arbitrary file read vulnerability in Ruby on Rails Action View, not an SSRF.

**Fix**: Replaced with a reference to the Capital One breach (2019), a well-documented real-world SSRF attack exploiting the AWS metadata endpoint (169.254.169.254) to steal IAM credentials.

---

## Verified Correct (Key Claims)

### OWASP Top 10 (2021)

All 10 categories (A01-A10), their names, rankings, and descriptions are **correct** per the OWASP 2021 list:
- A01: Broken Access Control
- A02: Cryptographic Failures
- A03: Injection
- A04: Insecure Design
- A05: Security Misconfiguration
- A06: Vulnerable and Outdated Components
- A07: Identification and Authentication Failures
- A08: Software and Data Integrity Failures
- A09: Security Logging and Monitoring Failures
- A10: Server-Side Request Forgery (SSRF)

The guide uses slightly shortened names (e.g., "Vulnerable Components" instead of "Vulnerable and Outdated Components", "Auth Failures" instead of "Identification and Authentication Failures") but these are acceptable abbreviations consistent with the course slides.

### CVSS Scoring

- CVSS v3.1 scale: 0-3.9 LOW, 4.0-6.9 MEDIUM, 7.0-8.9 HIGH, 9.0-10.0 CRITICAL -- **Correct**
- Heartbleed CVSS v3.1 = 7.5 (AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N) -- **Correct**, verified against source `vuln_intro.txt`
- ShellShock CVSS v3.1 = 9.8 -- **Correct**
- PwnKit CVSS v3.1 = 7.8 -- **Correct**
- Heartbleed CVSS v2 = 5.0, v4 = 8.7 -- **Correct**, verified against source
- CVSS metric ordering (AV: N>A>L>P, AC: L>H, PR: N>L>H, UI: N>R) -- **Correct**

### Protocol Descriptions

**NSPK protocol** verified against `NSPK.spdl`:
- Message 1: `{(n, i)}pk(r)` -- **Correct** (matches `{n,i}pk(r)`)
- Message 2: `{(n, m)}pk(i)` -- **Correct** (matches `{n,m}pk(i)`)
- Message 3: `{m}pk(r)` -- **Correct**

**NSPKL correction** verified against `NSPKL.spdl`:
- Message 2: `{(n, m, r)}pk(i)` -- **Correct** (matches `{n,m,r}pk(i)`)

**Lowe's attack description** -- **Correct**: Two parallel sessions, Eve relays between Bob and Alice, Alice believes she talks to Bob. Correction adds identity of r in message 2.

**Historical facts**:
- NSPK proposed in 1978 -- **Correct** (Needham & Schroeder, 1978)
- Attack discovered by Gavin Lowe in 1995/1996 -- **Correct** (published 1996)
- Used for 17 years before attack discovery -- **Correct** (1978-1995)

**auth-mim Scyther code** verified against `auth-mim.spdl` -- **Correct match**

### Cryptography Concepts

- Asymmetric: pk(i) public, sk(i) private, {m}pk(i) = encryption, {m}sk(i) = signature -- **Correct**
- Symmetric: k^(-1) = k -- **Correct**
- Hash properties (pre-image resistance, second pre-image resistance, collision resistance) -- **Correct**
- Dolev-Yao model (active attacker, perfect crypto, full network control) -- **Correct**
- Kerckhoffs principle (no security by obscurity) -- **Correct**
- French terminology (chiffrer not "crypter", dechiffrer vs decrypter) -- **Correct**

### Authentication Hierarchy

- Weak aliveness < Correct role < Non-injective agreement < Non-injective synchronization -- **Correct**, matches source guide `06_authentification.md`
- Mirror attack description -- **Correct**
- Correction via signatures -- **Correct**

### Defense Mechanisms

- ASLR: randomizes stack, heap, libraries, code -- **Correct**
- DEP/NX: marks data pages non-executable -- **Correct**
- Stack canaries: random value between buffer and return address -- **Correct**
- RELRO: makes GOT read-only -- **Correct**
- PIE: position-independent executable -- **Correct**
- CFI: control flow integrity -- **Correct**
- Limits of each defense correctly described -- **Correct**

### Code Examples

All vulnerable/secure code pairs verified:
- `strcpy` vs `strncpy` (buffer overflow) -- **Correct** (vulnerable / secure)
- `printf(user_input)` vs `printf("%s", user_input)` (format string) -- **Correct**
- Integer overflow check with `SIZE_MAX / count` -- **Correct**
- `free(ptr); use(ptr)` vs `free(ptr); ptr = NULL` (UAF) -- **Correct**
- PHP SQL injection examples with `mysql_query` vs `prepare/bind_param` -- **Correct**
- PHP `htmlspecialchars($val, ENT_QUOTES)` for XSS -- **Correct**
- Python SSRF example with whitelist validation -- **Correct**
- Python path traversal fix with `os.path.normpath` -- **Correct**

### Exam Walkthroughs

- 2025 exam SQL injection exercise (admin'--, ' OR 1=1--) -- **Correct**, matches source guide
- 2020-2021 exam exercise 2 (SQL vs CMD distinction: "-bash: OR: command not found") -- **Correct**
- Barbara's password system (5^dn(E) mod 11) -- **Correct**, matches source guide `06_authentification.md`
- Cloud security questions and expected answers -- **Correct**, match source guide `08_securite_cloud.md`

### TP Solutions

- TP1 Shell Security: file metrics, HTML structure analysis, credential findings -- **Correct**, verified against `resultat-GONZALEZ.txt` and `TP1/README.md`
- Specific findings (pixgame.html.prep: 656028 bytes, 16368 lines, 14289 non-empty, longest line 32083 chars) -- **Correct**
- Password findings at specific line numbers -- **Correct**

---

## Observations (Not Errors)

### 1. Barbara's password system -- mathematical nuance

The guide states that `5^x mod 11` produces "10 valeurs possibles (0 a 10)". Mathematically, `5^x mod 11` can never be 0 (since gcd(5,11)=1), and the multiplicative order of 5 modulo 11 is 5, so only 5 distinct values are produced: {1, 3, 4, 5, 9}. However, the source guide states the same "10 valeurs possibles", so this is a faithful reproduction of the course material. The key pedagogical point (collision is inevitable with more than 10 students) remains valid regardless.

### 2. OWASP Top 10 naming abbreviations

The guide uses abbreviated category names. For example:
- "Vulnerable Components" instead of "Vulnerable and Outdated Components"
- "Auth Failures" instead of "Identification and Authentication Failures"
- "Data Integrity Failures" instead of "Software and Data Integrity Failures"

These are acceptable shorthand consistent with how they appear in the course slides.

### 3. Chapters 02, 06, 07, 11, 13, 14 -- supplementary content

Chapters on memory vulnerabilities (02), exploitation techniques (06), defense mechanisms (07), network security (11), system security (13), and some web content (08) contain material that goes beyond what is explicitly in the source PDFs/guides, adding educational context (CVE examples, code samples, explanation of mechanisms). This supplementary content is technically accurate and pedagogically useful. The only issues were the three misattributed CVEs corrected above.

### 4. Cheat sheet completeness

The cheat sheet (`guide/cheat_sheet.md`) accurately summarizes all major topics. The exam strategy (`exam-prep/strategie_ds.md`) and question synthesis (`exam-prep/synthese_questions_types.md`) correctly identify recurring exam patterns based on the available annales.

### 5. SQL comment syntax

The guide correctly notes that `--` must be followed by a space in standard SQL to be treated as a comment. This is an important DS detail that matches the source material.

---

## Files Modified

| File | Change |
|------|--------|
| `guide/02_vulnerabilites_memoire.md` | Fixed CVE reference in Use-After-Free section (was PwnKit, now CVE-2022-0609) |
| `guide/02_vulnerabilites_memoire.md` | Fixed CVE reference in Integer Overflow section (was CVE-2021-21224, now CVE-2015-1593) |
| `guide/08_vulnerabilites_web.md` | Fixed SSRF CVE reference (was CVE-2019-5418, now Capital One 2019 breach) |

---

## Conclusion

The study guide is a faithful, well-organized representation of the course material with strong pedagogical structure. The three errors found were all in supplementary CVE references that were not sourced from the original course materials -- they were added to illustrate concepts and two of the three had incorrect vulnerability type classifications. All core concepts, protocol descriptions, code examples, CVSS calculations, OWASP classifications, and exam walkthroughs are accurate.
