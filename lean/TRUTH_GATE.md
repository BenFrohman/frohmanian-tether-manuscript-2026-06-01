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

## Failure classes (what a red Truth Gate means)

A red Truth Gate is not automatically a math failure. Since 2026-11-17, `lean/scripts/verify-lock.sh`
runs every phase even after one fails. `lean/scripts/truth_gate_classify.py` then sorts each failure
into exactly one class and prints a `TRUTH GATE VERDICT` block at the end of the log. The block
also goes to the job summary and to `truth-gate-report/classification.json`.

This exists because of frohmanian-tether-sdiff PR #13 (run 44039231121). That PR changed only CI,
but its merge ref was built on a main whose lock still had the old `paper_claim` form. The gate
printed `TRUTH GATE FAIL: this lock is NOT certifying` and `TRUTH GATE STATIC FAIL`, which read like
a proof failure, though every kernel check was green.

| Class | Raised by | What the verdict prints | What fixes it |
|---|---|---|---|
| **KERNEL/PROOF** | `lake build` fails; `sorry`/`admit`/`native_decide`/`axiom` outside the draft dirs; nonstandard axioms; a missing or ill-typed locked declaration; `intended_correspondence` fails to check | `KERNEL/PROOF FAILURE (a proof does not check)` and `This is a proof failure`, with the failing lines | Fix the proof. **This is the only class ever described as a proof failure.** |
| **LOCK-FORM** | `paper_claim` reuses a repository Prop or definition; a vacuous alias of `formal_claim`; an `rfl` correspondence; a partial lock; a lock marked `"certifying": false`; an edited lock region; missing `PAPER_*` fields | `LOCK-FORM: lock wording/form problem, not a math failure`, each offending identifier with `file:line` in the Semantics file and the `file:line` of its repository declaration, then the independent transcription that is required | Rewrite the paper side from the paper's own definition, in the paper's symbols, and prove `intended_correspondence` with real reasoning. A new lock needs the author's sign-off. |
| **PAPER-HASH** | the paper's sha256 differs from the lock | `PAPER-HASH: the paper changed after the lock (not a math failure)`, the commit whose bytes match the lock, every changed line, whether only copyright/license/attribution lines changed, and whether the locked quote is still verbatim | If the edit is intended, update `paper_sha256` in `TRUTH_GATE.lock`, the `PAPER_SHA256:` line in the Semantics file and the hash in this file, all in one commit. If the quote changed, that is a statement change and needs sign-off. |
| **STALE-BASE** | a PR's merge ref was built on an older main, and main has since changed the lock, a Semantics file, a paper or a gate script | `STALE-BASE: branch is behind main's lock; update branch (not a math failure)` | The workflow re-merges the PR head onto the current main and judges that merge, which is what would actually land. It goes red only if that merge conflicts, and then it says to update the branch. |

Two more labels can appear in the verdict:

* **`[INHERITED]`** appears when the PR touches no lock, vocabulary, Semantics or paper file but a
  LOCK-FORM or PAPER-HASH failure remains. The failure comes from main, so it has to be fixed on
  main.
* **`UNCLASSIFIED`** appears when a checker crashed or printed a message no rule recognises. It is
  shown verbatim and is never presumed to be a math failure.

The last line always states the classes, for example
`VERDICT: FAIL (LOCK-FORM). Kernel checks passed: no math was found false.`

### Lock-form lint (runs on every PR, no Lean needed)

The `lock-form-lint` job in `.github/workflows/truth-gate.yml` runs
`python3 scripts/truth_gate_classify.py lint --fetch-deps`. It collects every declaration in
`lean_roots` and in the author's own Lake dependencies (every non-Mathlib package in
`lake-manifest.json`), then reads `paper_claim` and any paper-side helper defined in the Semantics
file. It rejects:

1. any Prop that is a whole hypothesis or the conclusion of `formal_claim` (for example the old
   sdiff form `(∀ ν > 0, PeriodicTetherClosingBound ν) → …`). This is never allowed, with or without
   a vocabulary entry;
2. any other repository name that is not listed, with a reason, in `TRUTH_GATE.vocabulary.json`
   (basic notions such as the velocity-field type);
3. any name in `paper_forbidden_names`, and any mention of `formal_claim`.

`TRUTH_GATE.vocabulary.json` is lint configuration. It cannot change the locked claim, because the
lock region hash still pins `paper_claim`. For an existing author-approved lock, it records only the
basic names that the approved claim already uses. Any new name on the paper side goes into the
new-lock PR together with the author's sign-off.

### Tests

`lean/scripts/tests/test_truth_gate_classify.py` has one throw-away fixture repository per class:

* KERNEL/PROOF: build error, sorry, nonstandard axioms;
* LOCK-FORM: named hypothesis Prop, unlisted repository name, alias, non-certifying,
  partial lock, vacuous lock;
* PAPER-HASH: copyright-only change, and a change to the quote;
* STALE-BASE: re-merge onto the current main, and a merge conflict;
* `[INHERITED]` label.

The `lock-form-lint` job runs them on every PR:

```
python3 -m unittest discover -s scripts/tests -p 'test_truth_gate_classify.py' -v
```

## The locked claim of this repository

* Paper: `../two_part/tether_two_part.tex`
* sha256: `372f53bad6d3b047ae3c5b29ae048ea1f999d5ae58818c05633c45276fe55dca`
* Section: Whole paper. Every result the paper claims (its "Scope of claims" paragraph): Lemma lem:sym (a)-(c), Proposition prop:status, Proposition prop:degen (a)-(b), Proposition prop:mirror (i)-(iii), Theorem thm:cond
* Main theorem(s): `MirrorMetriplectic.tetherTensor_symm_psd`, `MirrorMetriplectic.sub_symm_antisymm_iff`, `MirrorMetriplectic.tetherMetric_degenerate`, `MirrorMetriplectic.metriplectic_rates`, `MirrorMetriplectic.mirror_principle`, `MirrorMetriplectic.conditional_regularity`
* Lock file: `TRUTH_GATE.lock`; semantics: `MirrorMetriplectic/Semantics.lean`

This is a whole-paper lock: the paper's "Scope of claims" paragraph lists exactly the claimed
results, and every one of them is locked. Theorem thm:cond carries the Beale--Kato--Majda
continuation criterion (BKM) and parabolic smoothing (PS) as named hypotheses, alongside the Riccati
hypothesis (R); none of the three is proved here. Everything else in the paper is cited literature,
an assessment of the source manuscript, a remark, or Conjecture thm:model, and is not claimed.

Verbatim quote:

```
\noindent\textbf{Scope of claims.} The results this paper claims are exactly Lemma~\ref{lem:sym}, Propositions~\ref{prop:status},
\ref{prop:degen} and~\ref{prop:mirror}, and Theorem~\ref{thm:cond}.

(a) For all $\delta u,\delta v$: $\mathfrak g_\omega(\delta u,\delta v)=\mathfrak g_\omega(\delta v,\delta u)$ and $\mathfrak g_\omega(\delta u,\delta u)\ge0$.
(b) For all $\delta u,\delta v$: $\mathfrak g^\Pi_\omega(\delta u,\delta v)=\mathfrak g^\Pi_\omega(\delta v,\delta u)$ and $\mathfrak g^\Pi_\omega(\delta u,\delta u)\ge0$.
(c) Let $V$ be any set, $\Omega\colon V\times V\to\mathbb R$ antisymmetric ($\Omega(a,b)+\Omega(b,a)=0$) and $\mathfrak g\colon V\times V\to\mathbb R$
symmetric. Then $\Omega-\mathfrak g$ is antisymmetric if and only if $\mathfrak g=0$.

Let $V$ be a real vector space, $\{\cdot,\cdot\}\colon V\times V\to\mathbb R$ antisymmetric ($\{a,b\}+\{b,a\}=0$),
$\mathfrak g$ a real bilinear form on $V$, $\Pi\colon V\to V$ linear, and $\delta H,\delta S\in V$ with $\Pi\,\delta H=0$
(as for $\Pi=\Pi_u$). Write $\mathfrak g^\Pi(a,b)=\mathfrak g(\Pi a,\Pi b)$. Then $\mathfrak g^\Pi(\delta F,\delta H)=0$ for every $\delta F\in V$,
and the metriplectic rate $\dot F=\{\delta F,\delta H\}-\mathfrak g^\Pi(\delta F,\delta S)$ gives $\dot H=0$ for every $\delta S$.

Let $V$ be a real vector space of gradients, $\{\cdot,\cdot\}$ and $(\cdot,\cdot)$ real bilinear forms on $V$ with $\{\cdot,\cdot\}$
antisymmetric and $(\cdot,\cdot)$ symmetric and positive semidefinite, $\delta H,\delta S\in V$, and
$\dot F=\{\delta F,\delta H\}+(\delta F,\delta S)$. Under (D1) $\{\delta F,\delta S\}=0$ for all $\delta F$ and (D2) $(\delta F,\delta H)=0$ for all $\delta F$:
(a) $\dot H=0$; (b) $\dot S=(\delta S,\delta S)\ge0$.

(i) $\{\delta H,\delta H\}_{\rm LP}=0$, and $\{\delta C,\delta H\}_{\rm LP}=0$ for every Casimir $\delta C$ (that is, $\{\delta C,\cdot\}_{\rm LP}=0$), so the
antisymmetric part conserves $H$ and every Casimir; and if $\{\delta F,\delta S\}_{\rm LP}=0$ for all $\delta F$, then
$\frac{d}{dt}S=-\mathfrak g^\Pi(\delta S,\delta S)\le0$: the symmetric part is the dissipative ``mirror'' term;
(ii) if $\{\delta F,\delta S\}_{\rm LP}=0$ for all $\delta F$ and $\Pi\,\delta H=0$, then $\dot H=0$ and $\mathfrak g^\Pi(\delta F,\delta H)=0$ for every $\delta F$:
the mirror term does not change $H$;
(iii) every $B\colon V\times V\to\mathbb R$ is $B=A+S$ with $A$ antisymmetric and $S$ symmetric, and this decomposition is unique.

(R) \emph{Riccati hypothesis.} $M$ is continuous on $[0,t]$ for every $t\in[0,T^*)$, and for every $t\in(0,T^*)$, $M$ is differentiable at $t$ with $M'(t)\le C-\kappa'M(t)^2$;

(BKM) \emph{Beale--Kato--Majda continuation criterion.} If $T^*<\infty$, then $\sup_{0\le t<T^*}M(t)=\infty$;

(PS) \emph{Parabolic smoothing.} $\mathcal S(T)$ holds for every $T\in(0,T^*)$.

Then $M(t)\le\max\{M(0),\sqrt{C/\kappa'}\}$ for all $t\in[0,T^*)$, $T^*=\infty$, and $\mathcal S(T)$ holds for every $T>0$, i.e.\ $u\in C^\infty((0,\infty)\times\T)$.
```

```lean
def formal_claim : Prop :=
  (∀ (X : Type) [MeasurableSpace X] (μ : Measure X) (κ : ℝ), 0 < κ →
    ∀ (ω : X → EuclideanSpace ℝ (Fin 3))
      (Pi : (X → EuclideanSpace ℝ (Fin 3)) → X → EuclideanSpace ℝ (Fin 3)),
    (∀ δu δv : X → EuclideanSpace ℝ (Fin 3),
      κ * ∫ x, ‖ω x‖ ^ 2 * inner ℝ (δu x) (δv x) ∂μ =
        κ * ∫ x, ‖ω x‖ ^ 2 * inner ℝ (δv x) (δu x) ∂μ) ∧
    (∀ δu : X → EuclideanSpace ℝ (Fin 3),
      0 ≤ κ * ∫ x, ‖ω x‖ ^ 2 * inner ℝ (δu x) (δu x) ∂μ) ∧
    (∀ δu δv : X → EuclideanSpace ℝ (Fin 3),
      κ * ∫ x, ‖ω x‖ ^ 2 * inner ℝ (Pi δu x) (Pi δv x) ∂μ =
        κ * ∫ x, ‖ω x‖ ^ 2 * inner ℝ (Pi δv x) (Pi δu x) ∂μ) ∧
    (∀ δu : X → EuclideanSpace ℝ (Fin 3),
      0 ≤ κ * ∫ x, ‖ω x‖ ^ 2 * inner ℝ (Pi δu x) (Pi δu x) ∂μ)) ∧
  (∀ (V : Type) (Ω g : V → V → ℝ), (∀ a b, Ω a b = -Ω b a) → (∀ a b, g a b = g b a) →
    ((∀ a b, Ω a b - g a b = -(Ω b a - g b a)) ↔ ∀ a b, g a b = 0)) ∧
  (∀ (V : Type) [AddCommGroup V] [Module ℝ V] (J : V → V → ℝ) (g : LinearMap.BilinForm ℝ V)
    (P : V →ₗ[ℝ] V) (δH δS : V), (∀ a b, J a b = -J b a) → P δH = 0 →
    (∀ δF, g (P δF) (P δH) = 0) ∧ J δH δH - g (P δH) (P δS) = 0) ∧
  (∀ (V : Type) [AddCommGroup V] [Module ℝ V] (M : MirrorMetriplectic.Metriplectic V),
    M.rate M.dH = 0 ∧ M.rate M.dS = M.G M.dS M.dS ∧ 0 ≤ M.rate M.dS) ∧
  (∀ (V : Type) [AddCommGroup V] [Module ℝ V] (J : V → V → ℝ) (g : LinearMap.BilinForm ℝ V)
    (P : V →ₗ[ℝ] V) (δH δS : V), (∀ a b, J a b = -J b a) → (∀ a, 0 ≤ g a a) →
    (J δH δH = 0 ∧ (∀ δC, (∀ a, J δC a = 0) → J δC δH = 0) ∧
      ((∀ a, J a δS = 0) →
        J δS δH - g (P δS) (P δS) = -g (P δS) (P δS) ∧ J δS δH - g (P δS) (P δS) ≤ 0)) ∧
    ((∀ a, J a δS = 0) → P δH = 0 →
      J δH δH - g (P δH) (P δS) = 0 ∧ ∀ δF, g (P δF) (P δH) = 0) ∧
    (∀ B : V → V → ℝ, ∃ A S : V → V → ℝ, (∀ a b, A a b = -A b a) ∧ (∀ a b, S a b = S b a) ∧
      ∀ a b, B a b = A a b + S a b) ∧
    (∀ A₁ S₁ A₂ S₂ : V → V → ℝ, (∀ a b, A₁ a b = -A₁ b a) → (∀ a b, S₁ a b = S₁ b a) →
      (∀ a b, A₂ a b = -A₂ b a) → (∀ a b, S₂ a b = S₂ b a) →
      (∀ a b, A₁ a b + S₁ a b = A₂ a b + S₂ a b) → ∀ a b, A₁ a b = A₂ a b ∧ S₁ a b = S₂ a b)) ∧
  (∀ (M : ℝ → ℝ) (Tstar : EReal) (C κ' : ℝ) (𝒮 : ℝ → Prop), 0 < Tstar → 0 ≤ C → 0 < κ' →
    (∀ t : ℝ, 0 ≤ t → (t : EReal) < Tstar → ContinuousOn M (Icc 0 t)) →
    (∀ t : ℝ, 0 < t → (t : EReal) < Tstar → HasDerivAt M (deriv M t) t) →
    (∀ t : ℝ, 0 < t → (t : EReal) < Tstar → deriv M t ≤ C - κ' * M t ^ 2) →
    (Tstar ≠ ⊤ → ¬ BddAbove (M '' {t : ℝ | 0 ≤ t ∧ (t : EReal) < Tstar})) →
    (∀ T : ℝ, 0 < T → (T : EReal) < Tstar → 𝒮 T) →
    (∀ t : ℝ, 0 ≤ t → (t : EReal) < Tstar → M t ≤ max (M 0) (Real.sqrt (C / κ'))) ∧
      Tstar = ⊤ ∧ ∀ T : ℝ, 0 < T → 𝒮 T)

def paper_claim : Prop :=
  -- Lemma lem:sym (a), (b), with |ω|² = ∑ ωᵢ² and δu·δv = ∑ δuᵢ δvᵢ
  (∀ (X : Type) [MeasurableSpace X] (μ : Measure X) (κ : ℝ), 0 < κ →
    ∀ (ω : X → EuclideanSpace ℝ (Fin 3))
      (Pi : (X → EuclideanSpace ℝ (Fin 3)) → X → EuclideanSpace ℝ (Fin 3)),
    (∀ δu δv : X → EuclideanSpace ℝ (Fin 3),
      κ * ∫ x, (∑ i, ω x i ^ 2) * (∑ i, δu x i * δv x i) ∂μ =
        κ * ∫ x, (∑ i, ω x i ^ 2) * (∑ i, δv x i * δu x i) ∂μ) ∧
    (∀ δu : X → EuclideanSpace ℝ (Fin 3),
      0 ≤ κ * ∫ x, (∑ i, ω x i ^ 2) * (∑ i, δu x i * δu x i) ∂μ) ∧
    (∀ δu δv : X → EuclideanSpace ℝ (Fin 3),
      κ * ∫ x, (∑ i, ω x i ^ 2) * (∑ i, Pi δu x i * Pi δv x i) ∂μ =
        κ * ∫ x, (∑ i, ω x i ^ 2) * (∑ i, Pi δv x i * Pi δu x i) ∂μ) ∧
    (∀ δu : X → EuclideanSpace ℝ (Fin 3),
      0 ≤ κ * ∫ x, (∑ i, ω x i ^ 2) * (∑ i, Pi δu x i * Pi δu x i) ∂μ)) ∧
  -- Lemma lem:sym (c)
  (∀ (V : Type) (Ω g : V → V → ℝ), (∀ a b, Ω a b + Ω b a = 0) → (∀ a b, g a b = g b a) →
    ((∀ a b, (Ω a b - g a b) + (Ω b a - g b a) = 0) ↔ g = fun _ _ => 0)) ∧
  -- Proposition prop:status
  (∀ (V : Type) [AddCommGroup V] [Module ℝ V] (J : V → V → ℝ) (g : LinearMap.BilinForm ℝ V)
    (P : V →ₗ[ℝ] V) (δH δS : V), (∀ a b, J a b + J b a = 0) → P δH = 0 →
    (∀ δF, g (P δF) (P δH) = 0) ∧ J δH δH - g (P δH) (P δS) = 0) ∧
  -- Proposition prop:degen (a), (b)
  (∀ (V : Type) [AddCommGroup V] [Module ℝ V] (J G : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (δH δS : V),
    (∀ a b, J a b + J b a = 0) → (∀ a b, G a b = G b a) → (∀ a, 0 ≤ G a a) →
    (∀ δF, J δF δS = 0) → (∀ δF, G δF δH = 0) →
    J δH δH + G δH δS = 0 ∧ J δS δH + G δS δS = G δS δS ∧ 0 ≤ J δS δH + G δS δS) ∧
  -- Proposition prop:mirror (i)-(iii)
  (∀ (V : Type) [AddCommGroup V] [Module ℝ V] (J : V → V → ℝ) (g : LinearMap.BilinForm ℝ V)
    (P : V →ₗ[ℝ] V) (δH δS : V), (∀ a b, J a b + J b a = 0) → (∀ a, 0 ≤ g a a) →
    (J δH δH = 0 ∧ (∀ δC, (∀ a, J δC a = 0) → J δC δH = 0) ∧
      ((∀ a, J a δS = 0) →
        J δS δH - g (P δS) (P δS) = -g (P δS) (P δS) ∧ J δS δH - g (P δS) (P δS) ≤ 0)) ∧
    ((∀ a, J a δS = 0) → P δH = 0 →
      J δH δH - g (P δH) (P δS) = 0 ∧ ∀ δF, g (P δF) (P δH) = 0) ∧
    (∀ B : V → V → ℝ, ∃ A S : V → V → ℝ, (∀ a b, A a b = -A b a) ∧ (∀ a b, S a b = S b a) ∧
      ∀ a b, B a b = A a b + S a b) ∧
    (∀ A₁ S₁ A₂ S₂ : V → V → ℝ, (∀ a b, A₁ a b = -A₁ b a) → (∀ a b, S₁ a b = S₁ b a) →
      (∀ a b, A₂ a b = -A₂ b a) → (∀ a b, S₂ a b = S₂ b a) →
      (∀ a b, A₁ a b + S₁ a b = A₂ a b + S₂ a b) → ∀ a b, A₁ a b = A₂ a b ∧ S₁ a b = S₂ a b)) ∧
  -- Theorem thm:cond, with (R), (BKM), (PS)
  (∀ (M : ℝ → ℝ) (Tstar : EReal) (C κ' : ℝ) (𝒮 : ℝ → Prop), 0 < Tstar → 0 ≤ C → 0 < κ' →
    (∀ t : ℝ, 0 ≤ t → (t : EReal) < Tstar → ContinuousOn M (Icc 0 t)) →
    (∀ t : ℝ, 0 < t → (t : EReal) < Tstar →
      DifferentiableAt ℝ M t ∧ deriv M t ≤ C - κ' * M t ^ 2) →
    (Tstar ≠ ⊤ → ∀ B : ℝ, ∃ t : ℝ, 0 ≤ t ∧ (t : EReal) < Tstar ∧ B < M t) →
    (∀ T : ℝ, 0 < T → (T : EReal) < Tstar → 𝒮 T) →
    (∀ t : ℝ, 0 ≤ t → (t : EReal) < Tstar → M t ≤ max (M 0) (Real.sqrt (C / κ'))) ∧
      Tstar = ⊤ ∧ ∀ T : ℝ, 0 < T → 𝒮 T)
```

See the doc comment of `MirrorMetriplectic/Semantics.lean` for the fixed reading of the paper's terms and the scope.

## Re-audit (2026-11-16): history

Resolved on 2026-11-23 by the whole-paper lock above (Theorem thm:cond is now locked with its
named hypotheses; `"certifying": true`). The 2026-11-16 record is kept below unchanged.


Status: **REOPENED. The gate is red on purpose.** `TRUTH_GATE.lock` carries `"certifying": false`, and
`scripts/truth_gate_check.py` fails while it does. Nothing was deleted: `Semantics.lean`, the quotes,
the hashes and the history are unchanged.

Rule applied (Benjamin Stanley Frohman, 2026-11-16):
* There are no partial locks. A lock certifies only a step on the correct path to the full theorem
  that is kernel-proved as the actual true answer, so that the next step can build on it.
* Drifted, dummy, placeholder or stand-in types, names or categories are rejected.
* Cross-ontology connections are not rejected for looking unrelated. The kernel check, and whether
  the piece genuinely helps reach the full structured proof, decide.
* `paper_claim` is an independent transcription of the verbatim paper quote, never an alias of
  `formal_claim`, and the correspondence is never `rfl`/`Iff.rfl`.

Locked claim under review: riccati_bound (appendix table row only)

Why it is reopened:
* Partial lock. Only the `riccati_bound` row of the Lean appendix table is locked. Theorem thm:cond, which the row serves, is not.
* Not a step on a realized path. The paper says the hypothesis M′ ≤ C − κ′M² "has no derivation and is equivalent to an a priori bound that would settle the Clay problem". It also says the tether, "shown in Part I not to modify the NS vector field … cannot produce" the −κ′M² term.

What would re-certify it: A lock needs a complete stated theorem of the paper on a path the paper does not itself declare unrealized.
