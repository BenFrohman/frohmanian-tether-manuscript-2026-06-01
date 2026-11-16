/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

import MirrorMetriplectic.Basic

/-!
# Truth Gate: semantics lock (see `TRUTH_GATE.md`)

PAPER_PATH: ../two_part/tether_two_part.tex
PAPER_SECTION: Appendix "Lean 4 certificate" (table row riccati_bound and the scope sentence), with the constants' signs from Theorem thm:cond (Section "Conditional regularity")
PAPER_SHA256: 9b7ae445f0f8594e36d541ca064266e5ee718c9b5e0cf58c33dfbf305ceeb8e4

Locked paper claim, quoted verbatim (the Lean-certified row, the signs of `C` and `κ'`, and the
scope):

PAPER_QUOTE_BEGIN
\texttt{riccati\_bound} & $M'\le C-\kappa'M^2\Rightarrow M\le\max(M(0),\sqrt{C/\kappa'})$\\\bottomrule
PAPER_QUOTE_END

PAPER_QUOTE_BEGIN
Suppose there are $C\ge0,\kappa'>0$
PAPER_QUOTE_END

PAPER_QUOTE_BEGIN
\emph{Cited, not formalized:} the infinite-dimensional Lie--Poisson structure, the log-Sobolev/Kozono--Taniuchi inequality, Beale--Kato--Majda, parabolic smoothing, and Theorem~\ref{thm:model}. The Riccati hypothesis itself is \emph{not} proved for Navier--Stokes; Lean certifies only the implication.
PAPER_QUOTE_END

Reading of the paper's terms:
* `M : ℝ → ℝ` is differentiable and `M'` is its derivative (`deriv M`);
* `C ≥ 0`, `κ' > 0` (Theorem thm:cond);
* the differential inequality `M' ≤ C - κ' M²` holds for all times `t ≥ 0`, and the conclusion
  `M(t) ≤ max(M(0), √(C/κ'))` is claimed for all `t ≥ 0`.

What is locked is the appendix row, i.e. the one-variable comparison lemma. Theorem thm:cond itself
(Dini derivative `D⁺M` on `[0,T*)`, `T* = ∞`, smoothness of the Navier–Stokes solution) is NOT
locked: its Navier–Stokes steps (BKM, log-Sobolev, parabolic smoothing) are cited, not formalized,
and the Riccati hypothesis is not proved for Navier–Stokes. This says nothing about the Clay problem.

`formal_claim` is the statement of `MirrorMetriplectic.riccati_bound` (differentiability written as
`∀ t, HasDerivAt M (deriv M t) t`, `0 < κ'` before `0 ≤ C`). `paper_claim` writes differentiability
as `Differentiable ℝ M` and orders the hypotheses as the paper does.
-/

namespace TruthGate

-- TRUTH-GATE LOCK BEGIN
/-- The repository's statement (`riccati_bound`). -/
def formal_claim : Prop :=
  ∀ (M : ℝ → ℝ) (C κ' : ℝ), 0 < κ' → 0 ≤ C → (∀ t, HasDerivAt M (deriv M t) t) →
    (∀ t, 0 ≤ t → deriv M t ≤ C - κ' * M t ^ 2) →
    ∀ t, 0 ≤ t → M t ≤ max (M 0) (Real.sqrt (C / κ'))

/-- Paper: `C ≥ 0, κ' > 0`, `M' ≤ C - κ'M² ⇒ M ≤ max(M(0), √(C/κ'))`. -/
def paper_claim : Prop :=
  ∀ (M : ℝ → ℝ) (C κ' : ℝ), 0 ≤ C → 0 < κ' → Differentiable ℝ M →
    (∀ t : ℝ, 0 ≤ t → deriv M t ≤ C - κ' * (M t) ^ 2) →
    ∀ t : ℝ, 0 ≤ t → M t ≤ max (M 0) (Real.sqrt (C / κ'))

/-- The fixed correspondence between the formal statement and the paper's claim. -/
theorem intended_correspondence : formal_claim ↔ paper_claim := by
  constructor
  · intro h M C κ' hC hκ hdiff hR
    exact h M C κ' hκ hC (fun t => (hdiff t).hasDerivAt) hR
  · intro h M C κ' hκ hC hd hR
    exact h M C κ' hC hκ (fun t => (hd t).differentiableAt) hR
-- TRUTH-GATE LOCK END

/-- The repository's theorem proves `formal_claim`. -/
theorem formal_claim_holds : formal_claim := by
  intro M C κ' hκ hC hd hR
  exact MirrorMetriplectic.riccati_bound M C κ' hκ hC hd hR

/-- The paper's claim, transported across the correspondence. -/
theorem paper_claim_holds : paper_claim :=
  intended_correspondence.mp formal_claim_holds

end TruthGate
