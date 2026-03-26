---
name: rfp-writing
description: Review and write technical RFP documents in formal, plain Chinese. Catches structural issues, redundancy, AI-isms, and vague language.
---

# Technical RFP Writing & Review

Review or draft technical RFP documents. Enforces clear structure, eliminates redundancy, and maintains formal plain-language style (Traditional Chinese).

## When to Use

- Reviewing or editing an existing RFP
- Drafting new RFP sections
- Auditing RFP language quality

## Review Checklist

Audit the document in this order. Fix issues top-down: structural problems first, then language.

### 1. Section Placement

Each section must sit under the parent that owns its concern. Common misplacements:

| Content | Wrong parent | Right parent |
|---------|-------------|-------------|
| Artifact storage, security scanning | Model inference | Deployment & release |
| Monitoring & auto-rollback | Model lifecycle | Observability |
| Canary deployment strategy | Model lifecycle | Deployment & release |
| Decommission / retirement flow | Model lifecycle | Operations |

**Action**: If a section's content belongs to 2+ other sections, it should not exist as a standalone section. Split and merge into the correct owners.

### 2. Redundancy Elimination

Before writing any requirement, check if it is already covered elsewhere:

- Cosign signing, Trivy scanning, Audit Log entries are typically covered by a general deployment/release section. Do not repeat them in domain-specific sections.
- Cross-references (e.g., "see 3.1.5.1") are acceptable. Restating the same requirement in both places is not.
- When deleting a section, grep the entire document for its section number and update all references (tables, cross-references, footnotes).

### 3. Pain Point Filter

Every requirement must address a real pain point. Ask:

- Is this specific to the domain (e.g., model artifacts are 100GB+ -- genuinely different from normal container images)?
- Or is this standard practice already covered by general infrastructure (e.g., SHA-256 checksum -- any OCI artifact has this)?

If it's standard practice, delete it. Only keep domain-specific requirements that would not be met by the general process.

### 4. Section Justification

A section earns its place by having a concrete use case in the current phase:

- **Has first-phase use case**: Keep as a full section with requirements.
- **Has second-phase use case with clear scope**: Keep as a subsection or remark (blockquote) under the related first-phase section.
- **No concrete use case, only "might need later"**: Demote to a one-sentence remark. Do not create a standalone section for speculative needs.

### 5. Reference Integrity

After any structural change (section move, delete, renumber):

1. `grep` the full document for the old section number
2. Update every reference: tables, cross-references, blockquotes, appendices
3. Verify zero remaining references to deleted sections

---

## Language Rules

### Mandatory: Complete Sentences

Every bullet point must be a complete sentence that explains **what** and **why**. Reject:

```
BAD:  - CSI / container-native persistent volumes (PV/PVC)
BAD:  - HA (control plane and critical services)
BAD:  - Backup/restore (config, data, indexes)

GOOD: - All storage must be mounted as container-native persistent volumes (PV/PVC) via CSI drivers, not dependent on node-local disks.
GOOD: - The K8s control plane and critical services (inference engine, API Gateway, vector DB) must be deployed in a high-availability architecture. Single-node failure must not interrupt service.
```

### Mandatory: Section Context

Each section must open with 1-2 sentences explaining **why this matters** before listing requirements. The reader needs to understand the problem before reading the solution.

```
BAD:
#### 3.3.2 Storage
- PV/PVC support
- High throughput
- Tiered storage

GOOD:
#### 3.3.2 Storage
The AI platform's storage needs differ from typical applications: model files are tens of GB, vector indexes require sustained high-throughput reads, and audit logs must be retained long-term and remain tamper-proof.

**Requirements:**
- All storage must be mounted via CSI...
```

### Prohibited Patterns

| Pattern | Example | Fix |
|---------|---------|-----|
| AI filler words | 確保、從而、旨在、進而、致力、賦能、全面地、有效地 | Rewrite directly. 確保 -> 使; delete filler entirely. |
| Contrarian structure | 不是 A 而是 B; 並非 A，而是 B | State B directly without negating A. |
| Hedging | 可能、若 (as uncertainty) | Use definitive language. 可能需要 -> 須; 若不大 -> delete the hedge. |
| Vague official-speak | 應審慎評估、有待觀察 | State the concrete criteria or action. |
| Noun-phrase bullets | `C: A + B` format; bold-colon shorthand | Write a full sentence. |
| "此外" as paragraph glue | 此外，大型模型... | Merge into the previous sentence or start a new paragraph without the connector. |
| Copula inflation | 作為、扮演著...的角色 | Use 是 or rewrite. Only flag when inflating a simple "is" relationship. |
| Significance inflation | 至關重要、不言而喻、眾所周知、不容忽視 | Delete or state concretely why it matters. |
| AI sentence templates | 在當今...的時代、隨著...的快速發展、值得一提的是、這不僅...更是... | Delete the frame; state the fact directly. |
| Synonym cycling | Rotating synonyms for the same concept within a paragraph (開發者...工程師...從業者...建構者) | Pick the clearest word and repeat it. |
| Superficial -ing analysis | 象徵著...的承諾、反映了...的投入、展現了...的決心 | State the specific fact or delete. |
| Formulaic challenge | 儘管面臨挑戰...仍持續成長 | Name the challenge and the response, or delete. |

### Allowed Patterns (do not flag)

| Pattern | Why it's fine |
|---------|--------------|
| Em dashes for technical explanation | `AWQ / GPTQ -- reduces model from 16-bit to 8-bit` is standard in technical docs |
| Bold labels in requirement lists | `**Identity**: each system has a unique ID...` is standard RFP format |
| Bullet-heavy sections | RFPs are list-oriented documents by nature |
| "不是" for concept boundary | `管理粒度是 collection，不是租戶` is a factual boundary, not a contrarian structure |
| "作為" in factual role assignment | `以 ArgoCD 作為 GitOps CD 引擎` is stating a technology choice, not copula inflation |
| "提升" in technical context | `用於提升排序品質` describes a component's function, not empty praise |
| 具體而言 as list intro | Acceptable when followed by concrete items; it is a list introducer, not filler |
| Structured uniformity | RFPs are inherently structured and uniform; do not break formatting conventions for the sake of "rhythm variation" |

---

## Workflow

### Reviewing an existing RFP

1. Read the full document first
2. Run structural checks (placement, redundancy, pain point filter, justification)
3. Propose structural changes as a table: section, problem, proposed action
4. Get user confirmation before editing
5. After structural edits, run language audit (grep for prohibited patterns)
6. Fix language issues
7. Final grep to verify no prohibited patterns remain

### Drafting a new section

1. Start with 1-2 sentences of context (why this section exists)
2. Add `**Requirements:**` header
3. Write each requirement as a complete sentence
4. Cross-check against existing sections for redundancy
5. Run language audit before presenting to user
