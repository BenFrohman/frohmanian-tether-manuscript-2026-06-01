/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

import MirrorMetriplectic.PaperResults

/-!
# Truth Gate: semantics lock (see `TRUTH_GATE.md`)

PAPER_PATH: ../two_part/tether_two_part.tex
PAPER_SECTION: Whole paper. Every result the paper claims (its "Scope of claims" paragraph): Lemma lem:sym (a)-(c), Proposition prop:status, Proposition prop:degen (a)-(b), Proposition prop:mirror (i)-(iii), Theorem thm:cond
PAPER_SHA256: ba337a9ff6040dbc1ff4772947779901abd89e96654344abb578b71b63ebf53d

Locked paper text, quoted verbatim (the scope paragraph and the statement of every claimed result):

PAPER_QUOTE_BEGIN
\noindent\textbf{Scope of claims.} The results this paper claims are exactly Lemma~\ref{lem:sym}, Propositions~\ref{prop:status},
\ref{prop:degen} and~\ref{prop:mirror}, and Theorem~\ref{thm:cond}.
PAPER_QUOTE_END

PAPER_QUOTE_BEGIN
(a) For all $\delta u,\delta v$: $\mathfrak g_\omega(\delta u,\delta v)=\mathfrak g_\omega(\delta v,\delta u)$ and $\mathfrak g_\omega(\delta u,\delta u)\ge0$.
(b) For all $\delta u,\delta v$: $\mathfrak g^\Pi_\omega(\delta u,\delta v)=\mathfrak g^\Pi_\omega(\delta v,\delta u)$ and $\mathfrak g^\Pi_\omega(\delta u,\delta u)\ge0$.
(c) Let $V$ be any set, $\Omega\colon V\times V\to\mathbb R$ antisymmetric ($\Omega(a,b)+\Omega(b,a)=0$) and $\mathfrak g\colon V\times V\to\mathbb R$
symmetric. Then $\Omega-\mathfrak g$ is antisymmetric if and only if $\mathfrak g=0$.
PAPER_QUOTE_END

PAPER_QUOTE_BEGIN
Let $V$ be a real vector space, $\{\cdot,\cdot\}\colon V\times V\to\mathbb R$ antisymmetric ($\{a,b\}+\{b,a\}=0$),
$\mathfrak g$ a real bilinear form on $V$, $\Pi\colon V\to V$ linear, and $\delta H,\delta S\in V$ with $\Pi\,\delta H=0$
(as for $\Pi=\Pi_u$). Write $\mathfrak g^\Pi(a,b)=\mathfrak g(\Pi a,\Pi b)$. Then $\mathfrak g^\Pi(\delta F,\delta H)=0$ for every $\delta F\in V$,
and the metriplectic rate $\dot F=\{\delta F,\delta H\}-\mathfrak g^\Pi(\delta F,\delta S)$ gives $\dot H=0$ for every $\delta S$.
PAPER_QUOTE_END

PAPER_QUOTE_BEGIN
Let $V$ be a real vector space of gradients, $\{\cdot,\cdot\}$ and $(\cdot,\cdot)$ real bilinear forms on $V$ with $\{\cdot,\cdot\}$
antisymmetric and $(\cdot,\cdot)$ symmetric and positive semidefinite, $\delta H,\delta S\in V$, and
$\dot F=\{\delta F,\delta H\}+(\delta F,\delta S)$. Under (D1) $\{\delta F,\delta S\}=0$ for all $\delta F$ and (D2) $(\delta F,\delta H)=0$ for all $\delta F$:
(a) $\dot H=0$; (b) $\dot S=(\delta S,\delta S)\ge0$.
PAPER_QUOTE_END

PAPER_QUOTE_BEGIN
(i) $\{\delta H,\delta H\}_{\rm LP}=0$, and $\{\delta C,\delta H\}_{\rm LP}=0$ for every Casimir $\delta C$ (that is, $\{\delta C,\cdot\}_{\rm LP}=0$), so the
antisymmetric part conserves $H$ and every Casimir; and if $\{\delta F,\delta S\}_{\rm LP}=0$ for all $\delta F$, then
$\frac{d}{dt}S=-\mathfrak g^\Pi(\delta S,\delta S)\le0$: the symmetric part is the dissipative ``mirror'' term;
(ii) if $\{\delta F,\delta S\}_{\rm LP}=0$ for all $\delta F$ and $\Pi\,\delta H=0$, then $\dot H=0$ and $\mathfrak g^\Pi(\delta F,\delta H)=0$ for every $\delta F$:
the mirror term does not change $H$;
(iii) every $B\colon V\times V\to\mathbb R$ is $B=A+S$ with $A$ antisymmetric and $S$ symmetric, and this decomposition is unique.
PAPER_QUOTE_END

PAPER_QUOTE_BEGIN
(R) \emph{Riccati hypothesis.} $M$ is continuous on $[0,t]$ for every $t\in[0,T^*)$, and for every $t\in(0,T^*)$, $M$ is differentiable at $t$ with $M'(t)\le C-\kappa'M(t)^2$;
PAPER_QUOTE_END

PAPER_QUOTE_BEGIN
(BKM) \emph{Beale--Kato--Majda continuation criterion.} If $T^*<\infty$, then $\sup_{0\le t<T^*}M(t)=\infty$;
PAPER_QUOTE_END

PAPER_QUOTE_BEGIN
(PS) \emph{Parabolic smoothing.} $\mathcal S(T)$ holds for every $T\in(0,T^*)$.
PAPER_QUOTE_END

PAPER_QUOTE_BEGIN
Then $M(t)\le\max\{M(0),\sqrt{C/\kappa'}\}$ for all $t\in[0,T^*)$, $T^*=\infty$, and $\mathcal S(T)$ holds for every $T>0$, i.e.\ $u\in C^\infty((0,\infty)\times\T)$.
PAPER_QUOTE_END

Reading of the paper's terms (fixed here, once):
* Lemma lem:sym (a), (b): `(X, μ)` is any measure space; `ω, δu, δv : X → ℝ³` with `ℝ³` the
  Euclidean space `EuclideanSpace ℝ (Fin 3)`; `|ω|² = ∑ᵢ ωᵢ²` and `δu · δv = ∑ᵢ δuᵢ δvᵢ` are written
  in coordinates; `∫` is the Bochner (Lebesgue) integral, `0` on non-integrable integrands as the
  Definition says; `Π` is any map of vector fields.
* Lemma lem:sym (c): "antisymmetric" is `Ω a b + Ω b a = 0`, "symmetric" is `g a b = g b a`,
  "`Ω - g` is antisymmetric" is `(Ω a b - g a b) + (Ω b a - g b a) = 0` for all `a, b`, and
  "`g = 0`" is equality of functions `g = fun _ _ => 0`.
* Proposition prop:status / prop:mirror: `{·,·}` is a function `V → V → ℝ`, antisymmetric in the
  paper's form `{a,b} + {b,a} = 0`; `𝔤` is `LinearMap.BilinForm ℝ V`; `Π` is `V →ₗ[ℝ] V`;
  `Ḟ = {δF, δH} - 𝔤(Π δF, Π δS)`; "positive semidefinite" is `0 ≤ 𝔤 a a`; a Casimir `δC` is
  `∀ a, {δC, a} = 0`; "(iii) unique" is: two decompositions agree at every `(a, b)`.
* Proposition prop:degen: `{·,·}` and `(·,·)` are bilinear forms `V →ₗ[ℝ] V →ₗ[ℝ] ℝ`;
  `Ḟ = {δF, δH} + (δF, δS)`.
* Theorem thm:cond: `T* ∈ (0, ∞]` is an extended real `0 < T*`; `t ∈ [0, T*)` is
  `0 ≤ t ∧ (t : EReal) < T*`; "differentiable at `t` with `M'(t) ≤ …`" is
  `DifferentiableAt ℝ M t ∧ deriv M t ≤ C - κ' * M t ^ 2`; "`sup M = ∞`" is "for every `B` there is
  `t ∈ [0, T*)` with `B < M t`"; `𝒮 : ℝ → Prop` is the statement `𝒮(T)`; `T* = ∞` is `T* = ⊤`.

`formal_claim` is the conjunction, in the order above, of the statements of the six main theorems
in `MirrorMetriplectic/PaperResults.lean`. `paper_claim` is written from the paper's text with
Mathlib notions only. `intended_correspondence` converts between the two readings: norm-squared
and inner product versus coordinate sums (`EuclideanSpace.real_norm_sq_eq`, `PiLp.inner_apply`),
`x = -y` versus `x + y = 0`, pointwise vanishing versus function equality, the bundled
`Metriplectic` structure versus unbundled hypotheses, `HasDerivAt` versus `DifferentiableAt`, and
`¬ BddAbove` versus "for every bound there is a larger value". It does not use the main theorems.

Scope: these are the paper's claimed results only. Hypotheses (R), (BKM), (PS) of thm:cond are
named hypotheses, not proved; nothing here concerns the Clay problem.
-/

namespace TruthGate

open MeasureTheory Set

-- TRUTH-GATE LOCK BEGIN
/-- Pointwise identity behind Lemma lem:sym: `‖ω‖² ⟪a, b⟫ = (∑ ωᵢ²)(∑ aᵢ bᵢ)` in `ℝ³`. -/
theorem integrand_coords (w a b : EuclideanSpace ℝ (Fin 3)) :
    ‖w‖ ^ 2 * inner ℝ a b = (∑ i, w i ^ 2) * ∑ i, a i * b i := by
  rw [EuclideanSpace.real_norm_sq_eq, EuclideanSpace.inner_eq_star_dotProduct]
  congr 1
  simp only [dotProduct, Pi.star_apply, star_trivial]
  exact Finset.sum_congr rfl fun i _ => mul_comm _ _

/-- The statements of the six main theorems of `MirrorMetriplectic/PaperResults.lean`. -/
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

/-- The paper's claimed results, transcribed from its text with Mathlib notions only. -/
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

/-- The fixed correspondence between the formal statement and the paper's claim. -/
theorem intended_correspondence : formal_claim ↔ paper_claim := by
  unfold formal_claim paper_claim
  refine and_congr ?_ (and_congr ?_ (and_congr ?_ (and_congr ?_ (and_congr ?_ ?_))))
  · -- Lemma lem:sym (a), (b): norm and inner product in coordinates
    simp only [integrand_coords]
  · -- Lemma lem:sym (c)
    constructor
    · intro h V Ω g hΩ hg
      have hΩ' : ∀ a b, Ω a b = -Ω b a := fun a b => eq_neg_of_add_eq_zero_left (hΩ a b)
      have e := h V Ω g hΩ' hg
      constructor
      · intro hs
        funext a b
        exact e.mp (fun a b => eq_neg_of_add_eq_zero_left (hs a b)) a b
      · intro hz a b
        have h0 := e.mpr (fun a b => congrFun (congrFun hz a) b) a b
        linarith
    · intro h V Ω g hΩ hg
      have hΩ' : ∀ a b, Ω a b + Ω b a = 0 := fun a b => by rw [hΩ a b]; ring
      have e := h V Ω g hΩ' hg
      constructor
      · intro hs a b
        exact congrFun (congrFun (e.mp (fun a b => by rw [hs a b]; ring)) a) b
      · intro hz a b
        have h0 := e.mpr (funext fun a => funext fun b => hz a b) a b
        linarith
  · -- Proposition prop:status
    constructor
    · intro h V _ _ J g P δH δS hJ hP
      exact h V J g P δH δS (fun a b => eq_neg_of_add_eq_zero_left (hJ a b)) hP
    · intro h V _ _ J g P δH δS hJ hP
      exact h V J g P δH δS (fun a b => by rw [hJ a b]; ring) hP
  · -- Proposition prop:degen: bundled structure versus unbundled hypotheses
    constructor
    · intro h V _ _ J G δH δS hJ hG hpsd hD1 hD2
      exact h V ⟨J, G, δH, δS, fun a b => eq_neg_of_add_eq_zero_left (hJ a b), hG, hpsd,
        hD1, hD2⟩
    · intro h V _ _ M
      exact h V M.J M.G M.dH M.dS
        (fun a b => by have := M.J_antisymm a b; linarith) M.G_symm M.G_psd M.degen_J M.degen_G
  · -- Proposition prop:mirror
    constructor
    · intro h V _ _ J g P δH δS hJ hpsd
      exact h V J g P δH δS (fun a b => eq_neg_of_add_eq_zero_left (hJ a b)) hpsd
    · intro h V _ _ J g P δH δS hJ hpsd
      exact h V J g P δH δS (fun a b => by rw [hJ a b]; ring) hpsd
  · -- Theorem thm:cond
    constructor
    · intro h M Tstar C κ' 𝒮 hT hC hκ hcont hdR hBKM hPS
      refine h M Tstar C κ' 𝒮 hT hC hκ hcont
        (fun t h0 h1 => (hdR t h0 h1).1.hasDerivAt) (fun t h0 h1 => (hdR t h0 h1).2) ?_ hPS
      intro hne hbdd
      obtain ⟨B, hB⟩ := hbdd
      obtain ⟨t, ht0, htT, hlt⟩ := hBKM hne B
      exact absurd (hB ⟨t, ⟨ht0, htT⟩, rfl⟩) (not_le.mpr hlt)
    · intro h M Tstar C κ' 𝒮 hT hC hκ hcont hd hR hBKM hPS
      refine h M Tstar C κ' 𝒮 hT hC hκ hcont
        (fun t h0 h1 => ⟨(hd t h0 h1).differentiableAt, hR t h0 h1⟩) ?_ hPS
      intro hne B
      by_contra hcon
      push_neg at hcon
      exact hBKM hne ⟨B, by
        rintro _ ⟨t, ⟨ht0, htT⟩, rfl⟩
        exact hcon t ht0 htT⟩
-- TRUTH-GATE LOCK END

/-- The six main theorems prove `formal_claim`. -/
theorem formal_claim_holds : formal_claim := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro X _ μ κ hκ ω Pi
    exact MirrorMetriplectic.tetherTensor_symm_psd μ κ hκ ω Pi
  · intro V Ω g hΩ hg
    exact MirrorMetriplectic.sub_symm_antisymm_iff Ω g hΩ hg
  · intro V _ _ J g P δH δS hJ hP
    exact MirrorMetriplectic.tetherMetric_degenerate J g P δH δS hJ hP
  · intro V _ _ M
    exact MirrorMetriplectic.metriplectic_rates M
  · intro V _ _ J g P δH δS hJ hpsd
    exact MirrorMetriplectic.mirror_principle J g P δH δS hJ hpsd
  · intro M Tstar C κ' 𝒮 hT hC hκ hcont hd hR hBKM hPS
    exact MirrorMetriplectic.conditional_regularity M Tstar C κ' 𝒮 hT hC hκ hcont hd hR hBKM hPS

/-- The paper's claim, transported across the correspondence. -/
theorem paper_claim_holds : paper_claim :=
  intended_correspondence.mp formal_claim_holds

end TruthGate
