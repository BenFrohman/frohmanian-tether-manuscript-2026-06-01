# TRUTH GATE — the GOD gate. Read this first.

Author: Benjamin Stanley Frohman. This file is the root instruction for every person and every
automated agent (every bot) that touches this repository. Load it before any other file.

**Only truth and honest, kernel-proved theorems pass this gate. Nothing from this repository is
published, released, deposited on Zenodo, cited or claimed unless the `truth-gate` check is green
on the exact commit being cited.** That is why it is the GOD gate: it sits above every other
check, and no other green check can stand in for it.

## The issue this gate fixes

A paper states its claim in English. Lean can only prove `formal_claim ↔ paper_claim` once
`paper_claim` is itself written in Lean. If `paper_claim` were simply *defined to be*
`formal_claim` (or an alias of it, or something that unfolds to it), the theorem
`intended_correspondence` would be `Iff.rfl`: it would be empty and prove nothing about the
paper. A green certificate could then "certify" a statement different from the one the paper
makes (drift), whether by accident or by an injected instruction.

## The fix rule (binding, permanent)

1. `paper_claim` is an **independent Lean transcription of the paper's exact claim**, written in
   the paper's own terms, with every hypothesis the paper states. The verbatim English quote,
   the paper path, its sha256 and the section are recorded in the doc comment of
   `Semantics.lean` **and** in this file (below).
2. `paper_claim` must **not** be defined as, reference, or trivially alias `formal_claim`.
3. `intended_correspondence : formal_claim ↔ paper_claim` must have a **substantive proof**. It
   may not be `Iff.rfl`, `rfl`, `exact Iff.rfl` or similar, and it may not use the main theorem
   (it is a statement-level equivalence, not "both sides happen to be provable").
4. `formal_claim` is exactly the statement of the repository's main theorem, and
   `paper_claim_holds` is the main theorem transported across the correspondence.
5. Only `propext`, `Classical.choice` and `Quot.sound`. No `sorry`, `admit`, `native_decide` or
   new `axiom` anywhere outside the draft directories in `TRUTH_GATE.lock`.
6. If the paper's English claim cannot be faithfully transcribed, or is not what Lean proves,
   the gate stays **red** and the mismatch is reported. Never patch over it: never weaken
   `paper_claim`, drop a hypothesis, or redefine it to match the formal side. If the
   formalization drifted, rewrite the formalization so it transports across the lock again.
7. Open problems stay hypotheses. No Millennium Prize problem is claimed solved; the gate only
   ensures the certificate proves precisely the locked claim and nothing else.
8. The locked region of `Semantics.lean`, the quote and `TRUTH_GATE.lock` change only with the
   author's explicit sign-off, as a PR that says "new lock" in its title.
9. Commits are authored by Benjamin Stanley Frohman only, with no AI co-author trailers. No
   force-push and no history rewriting.

## What `scripts/verify-lock.sh` checks mechanically

* `lake build` succeeds, with no `sorry` warning outside the draft directories;
* no `sorry` / `admit` / `native_decide` / `axiom` token outside the draft directories
  (comments and strings excluded);
* `Semantics.lean` has `PAPER_PATH`, `PAPER_SHA256`, `PAPER_SECTION` and a verbatim
  `PAPER_QUOTE`; the hash matches the paper file and the quote occurs in it; this file carries
  the same path, hash and quote;
* the lock region hash matches `TRUTH_GATE.lock`;
* `paper_claim`'s body does not mention `formal_claim`; the correspondence is not proved by
  `Iff.rfl`/`rfl`;
* in Lean: the bodies of `formal_claim` and `paper_claim` differ, the two are not
  definitionally equal, the correspondence proof does not reach the main theorem, the main
  theorem's statement is `formal_claim`, `paper_claim_holds` goes through the correspondence,
  and `#print axioms` shows only the three standard axioms.

What it cannot check: whether the transcription is the right reading of the English. That
reading is fixed once, in writing, below and in `Semantics.lean`, and is the author's sign-off.

## Running the gate locally

```
lake exe cache get
bash scripts/verify-lock.sh
```

Reports are written to `truth-gate-report/`.

## The locked claim of this repository

* Paper: `../two_part/tether_two_part.tex`
* sha256: `9b7ae445f0f8594e36d541ca064266e5ee718c9b5e0cf58c33dfbf305ceeb8e4`
* Section: Appendix "Lean 4 certificate" (table row riccati_bound and the scope sentence), with the constants' signs from Theorem thm:cond (Section "Conditional regularity")
* Main theorem(s): `MirrorMetriplectic.riccati_bound`
* Lock file: `TRUTH_GATE.lock`; semantics: `MirrorMetriplectic/Semantics.lean`

Verbatim quote:

```
\texttt{riccati\_bound} & $M'\le C-\kappa'M^2\Rightarrow M\le\max(M(0),\sqrt{C/\kappa'})$\\\bottomrule

Suppose there are $C\ge0,\kappa'>0$

\emph{Cited, not formalized:} the infinite-dimensional Lie--Poisson structure, the log-Sobolev/Kozono--Taniuchi inequality, Beale--Kato--Majda, parabolic smoothing, and Theorem~\ref{thm:model}. The Riccati hypothesis itself is \emph{not} proved for Navier--Stokes; Lean certifies only the implication.
```

```lean
def formal_claim : Prop :=
  ∀ (M : ℝ → ℝ) (C κ' : ℝ), 0 < κ' → 0 ≤ C → (∀ t, HasDerivAt M (deriv M t) t) →
    (∀ t, 0 ≤ t → deriv M t ≤ C - κ' * M t ^ 2) →
    ∀ t, 0 ≤ t → M t ≤ max (M 0) (Real.sqrt (C / κ'))

def paper_claim : Prop :=
  ∀ (M : ℝ → ℝ) (C κ' : ℝ), 0 ≤ C → 0 < κ' → Differentiable ℝ M →
    (∀ t : ℝ, 0 ≤ t → deriv M t ≤ C - κ' * (M t) ^ 2) →
    ∀ t : ℝ, 0 ≤ t → M t ≤ max (M 0) (Real.sqrt (C / κ'))
```

See the doc comment of `MirrorMetriplectic/Semantics.lean` for the fixed reading of the paper's terms and the scope.
