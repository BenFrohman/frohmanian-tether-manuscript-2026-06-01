/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

import MirrorMetriplectic.Basic

/-!
# lean.MirrorMetriplectic.PaperResults

One theorem for each result claimed in `two_part/tether_two_part.tex`:

* `tetherTensor_symm_psd`: Lemma `lem:sym` (a), (b);
* `sub_symm_antisymm_iff`: Lemma `lem:sym` (c);
* `tetherMetric_degenerate`: Proposition `prop:status`;
* `metriplectic_rates`: Proposition `prop:degen` (a), (b);
* `mirror_principle`: Proposition `prop:mirror` (i)–(iii);
* `conditional_regularity`: Theorem `thm:cond`, with the Beale–Kato–Majda continuation criterion
  and parabolic smoothing as named hypotheses (`hBKM`, `hPS`); `riccati_bound_Icc` is its
  comparison step on `[0, t]`.

Nothing about the Navier–Stokes equations is formalized here: `M`, `T*` and the smoothness
statements `𝒮 T` are arbitrary, and the theorem holds for every choice satisfying the hypotheses.
-/

namespace MirrorMetriplectic

open MeasureTheory Set

/-- Lemma `lem:sym` (a), (b): the tether tensor `𝔤_ω(δu, δv) = κ ∫ |ω|² δu · δv dμ` and its
projected version `𝔤_ω(Π δu, Π δv)` are symmetric and positive semidefinite. -/
theorem tetherTensor_symm_psd {X : Type} [MeasurableSpace X] (μ : Measure X) (κ : ℝ)
    (hκ : 0 < κ) (ω : X → EuclideanSpace ℝ (Fin 3))
    (Pi : (X → EuclideanSpace ℝ (Fin 3)) → X → EuclideanSpace ℝ (Fin 3)) :
    (∀ δu δv : X → EuclideanSpace ℝ (Fin 3),
      κ * ∫ x, ‖ω x‖ ^ 2 * inner ℝ (δu x) (δv x) ∂μ =
        κ * ∫ x, ‖ω x‖ ^ 2 * inner ℝ (δv x) (δu x) ∂μ) ∧
    (∀ δu : X → EuclideanSpace ℝ (Fin 3),
      0 ≤ κ * ∫ x, ‖ω x‖ ^ 2 * inner ℝ (δu x) (δu x) ∂μ) ∧
    (∀ δu δv : X → EuclideanSpace ℝ (Fin 3),
      κ * ∫ x, ‖ω x‖ ^ 2 * inner ℝ (Pi δu x) (Pi δv x) ∂μ =
        κ * ∫ x, ‖ω x‖ ^ 2 * inner ℝ (Pi δv x) (Pi δu x) ∂μ) ∧
    (∀ δu : X → EuclideanSpace ℝ (Fin 3),
      0 ≤ κ * ∫ x, ‖ω x‖ ^ 2 * inner ℝ (Pi δu x) (Pi δu x) ∂μ) := by
  have hs : ∀ a b : X → EuclideanSpace ℝ (Fin 3),
      κ * ∫ x, ‖ω x‖ ^ 2 * inner ℝ (a x) (b x) ∂μ =
        κ * ∫ x, ‖ω x‖ ^ 2 * inner ℝ (b x) (a x) ∂μ := by
    intro a b
    have h : (fun x => ‖ω x‖ ^ 2 * inner ℝ (a x) (b x)) =
        fun x => ‖ω x‖ ^ 2 * inner ℝ (b x) (a x) := by
      funext x
      rw [real_inner_comm (a x) (b x)]
    rw [h]
  have hp : ∀ a : X → EuclideanSpace ℝ (Fin 3),
      0 ≤ κ * ∫ x, ‖ω x‖ ^ 2 * inner ℝ (a x) (a x) ∂μ := fun a =>
    mul_nonneg hκ.le (integral_nonneg fun x => mul_nonneg (sq_nonneg _) real_inner_self_nonneg)
  exact ⟨hs, hp, fun a b => hs (Pi a) (Pi b), fun a => hp (Pi a)⟩

/-- Lemma `lem:sym` (c): for an antisymmetric `Ω` and a symmetric `g`, `Ω - g` is antisymmetric
if and only if `g` vanishes. -/
theorem sub_symm_antisymm_iff {V : Type} (Ω g : V → V → ℝ) (hΩ : ∀ a b, Ω a b = -Ω b a)
    (hg : ∀ a b, g a b = g b a) :
    (∀ a b, Ω a b - g a b = -(Ω b a - g b a)) ↔ ∀ a b, g a b = 0 := by
  constructor
  · intro h a b
    have h1 := h a b
    have h2 := hΩ a b
    have h3 := hg a b
    linarith
  · intro h a b
    have h2 := hΩ a b
    rw [h a b, h b a]
    linarith

/-- Proposition `prop:status`: if `Π δH = 0`, the projected tether `𝔤(Π ·, Π ·)` annihilates `δH`,
and the metriplectic rate `{δF, δH} - 𝔤(Π δF, Π δS)` vanishes at `δF = δH`. -/
theorem tetherMetric_degenerate {V : Type} [AddCommGroup V] [Module ℝ V]
    (J : V → V → ℝ) (g : LinearMap.BilinForm ℝ V) (P : V →ₗ[ℝ] V) (δH δS : V)
    (hJ : ∀ a b, J a b = -J b a) (hP : P δH = 0) :
    (∀ δF, g (P δF) (P δH) = 0) ∧ J δH δH - g (P δH) (P δS) = 0 := by
  have hHH : J δH δH = 0 := by
    have h := hJ δH δH
    linarith
  refine ⟨fun δF => ?_, ?_⟩
  · rw [hP, map_zero]
  · rw [hP, map_zero, LinearMap.zero_apply, hHH, sub_zero]

/-- Proposition `prop:degen` (a), (b): under the degeneracy conditions, `Ḣ = 0` and
`Ṡ = (δS, δS) ≥ 0`. -/
theorem metriplectic_rates {V : Type} [AddCommGroup V] [Module ℝ V] (M : Metriplectic V) :
    M.rate M.dH = 0 ∧ M.rate M.dS = M.G M.dS M.dS ∧ 0 ≤ M.rate M.dS := by
  refine ⟨energy_conserved M, ?_, entropy_monotone M⟩
  have h := M.J_antisymm M.dS M.dH
  simp only [Metriplectic.rate, h, M.degen_J, neg_zero, zero_add]

/-- Proposition `prop:mirror` (i)–(iii), Frohman's mirror principle in its sound form, for the
generator `Ḟ = {δF, δH} - 𝔤(Π δF, Π δS)`. -/
theorem mirror_principle {V : Type} [AddCommGroup V] [Module ℝ V]
    (J : V → V → ℝ) (g : LinearMap.BilinForm ℝ V) (P : V →ₗ[ℝ] V) (δH δS : V)
    (hJ : ∀ a b, J a b = -J b a) (hpsd : ∀ a, 0 ≤ g a a) :
    (J δH δH = 0 ∧ (∀ δC, (∀ a, J δC a = 0) → J δC δH = 0) ∧
      ((∀ a, J a δS = 0) →
        J δS δH - g (P δS) (P δS) = -g (P δS) (P δS) ∧ J δS δH - g (P δS) (P δS) ≤ 0)) ∧
    ((∀ a, J a δS = 0) → P δH = 0 →
      J δH δH - g (P δH) (P δS) = 0 ∧ ∀ δF, g (P δF) (P δH) = 0) ∧
    (∀ B : V → V → ℝ, ∃ A S : V → V → ℝ, (∀ a b, A a b = -A b a) ∧ (∀ a b, S a b = S b a) ∧
      ∀ a b, B a b = A a b + S a b) ∧
    (∀ A₁ S₁ A₂ S₂ : V → V → ℝ, (∀ a b, A₁ a b = -A₁ b a) → (∀ a b, S₁ a b = S₁ b a) →
      (∀ a b, A₂ a b = -A₂ b a) → (∀ a b, S₂ a b = S₂ b a) →
      (∀ a b, A₁ a b + S₁ a b = A₂ a b + S₂ a b) → ∀ a b, A₁ a b = A₂ a b ∧ S₁ a b = S₂ a b) := by
  have hHH : J δH δH = 0 := by
    have h := hJ δH δH
    linarith
  refine ⟨⟨hHH, fun δC hC => hC δH, fun hD1 => ?_⟩, fun hD1 hP => ?_, fun B => ?_, ?_⟩
  · have h1 : J δS δH = 0 := by
      rw [hJ δS δH, hD1 δH, neg_zero]
    rw [h1, zero_sub]
    exact ⟨rfl, neg_nonpos.mpr (hpsd _)⟩
  · have hst := tetherMetric_degenerate J g P δH δS hJ hP
    exact ⟨hst.2, hst.1⟩
  · refine ⟨fun a b => (B a b - B b a) / 2, fun a b => (B a b + B b a) / 2,
      fun a b => by ring, fun a b => by ring, fun a b => by ring⟩
  · intro A₁ S₁ A₂ S₂ h1 h2 h3 h4 h a b
    have e1 := h a b
    have e2 := h b a
    have f1 := h1 a b
    have f2 := h2 a b
    have f3 := h3 a b
    have f4 := h4 a b
    constructor <;> linarith

/-- The comparison step of Theorem `thm:cond` on `[0, t]`: if `M` is continuous on `[0, t]`,
differentiable on `(0, t)` with `M' ≤ C - κ' M²` there, then `M t ≤ max (M 0) √(C/κ')`. -/
theorem riccati_bound_Icc (M : ℝ → ℝ) (C κ' t : ℝ) (hκ : 0 < κ') (hC : 0 ≤ C) (ht : 0 ≤ t)
    (hcont : ContinuousOn M (Icc 0 t))
    (hd : ∀ s ∈ Ioo 0 t, HasDerivAt M (deriv M s) s)
    (hR : ∀ s ∈ Ioo 0 t, deriv M s ≤ C - κ' * M s ^ 2) :
    M t ≤ max (M 0) (Real.sqrt (C / κ')) := by
  set K := max (M 0) (Real.sqrt (C / κ'))
  by_contra hlt
  push_neg at hlt
  set S := {s | s ∈ Icc 0 t ∧ M s ≤ K}
  have h0 : (0:ℝ) ∈ S := ⟨⟨le_refl _, ht⟩, le_max_left _ _⟩
  have hbdd : BddAbove S := ⟨t, fun s hs => hs.1.2⟩
  have hclosed : IsClosed S := by
    have hS : S = Icc 0 t ∩ M ⁻¹' Iic K := rfl
    rw [hS]
    exact hcont.preimage_isClosed_of_isClosed isClosed_Icc isClosed_Iic
  have hs₀ : sSup S ∈ S := hclosed.csSup_mem ⟨0, h0⟩ hbdd
  have hs₀t : sSup S < t :=
    lt_of_le_of_ne hs₀.1.2 (fun h => by have := hs₀.2; rw [h] at this; linarith)
  have hgt : ∀ u ∈ Ioc (sSup S) t, K < M u := by
    intro u hu
    by_contra hle
    push_neg at hle
    have : u ≤ sSup S := le_csSup hbdd ⟨⟨by linarith [hs₀.1.1, hu.1], hu.2⟩, hle⟩
    linarith [hu.1]
  have hsq : Real.sqrt (C / κ') ≤ K := le_max_right _ _
  have hneg : ∀ u ∈ Ioo (sSup S) t, deriv M u < 0 := by
    intro u hu
    have hKu := hgt u ⟨hu.1, hu.2.le⟩
    have hpos : 0 ≤ Real.sqrt (C / κ') := Real.sqrt_nonneg _
    have hM : Real.sqrt (C / κ') < M u := lt_of_le_of_lt hsq hKu
    have hs2 := Real.sq_sqrt (div_nonneg hC hκ.le)
    have h2 : C / κ' < M u ^ 2 := by nlinarith
    have h3 : C < κ' * M u ^ 2 := by
      rw [div_lt_iff₀ hκ] at h2
      linarith
    linarith [hR u ⟨by linarith [hs₀.1.1, hu.1], hu.2⟩]
  have hsub : Icc (sSup S) t ⊆ Icc 0 t := Icc_subset_Icc hs₀.1.1 le_rfl
  obtain ⟨c, hc, hderiv⟩ := exists_deriv_eq_slope M hs₀t (hcont.mono hsub)
    (fun u hu => (hd u ⟨by linarith [hs₀.1.1, hu.1], hu.2⟩).differentiableAt.differentiableWithinAt)
  have hne : t - sSup S ≠ 0 := sub_ne_zero.2 hs₀t.ne'
  have key : deriv M c * (t - sSup S) = M t - M (sSup S) := by
    rw [hderiv]
    field_simp
  have hdc := hneg c hc
  nlinarith [hs₀.2, sub_pos.2 hs₀t]

/-- Theorem `thm:cond` (conditional regularity). `Tstar` is the lifespan `T* ∈ (0, ∞]`, `M` the
quantity `‖ω‖_∞`, and `𝒮 T` the statement "`u ∈ C^∞((0,T] × 𝕋³)`". Hypotheses: the Riccati
hypothesis (`hcont`, `hd`, `hR`); the Beale–Kato–Majda continuation criterion `hBKM` (if `T* < ∞`
then `M` is unbounded on `[0, T*)`); parabolic smoothing `hPS`. Conclusion: the bound
`M ≤ max (M 0) √(C/κ')` on `[0, T*)`, `T* = ∞`, and `𝒮 T` for every `T > 0`. -/
theorem conditional_regularity (M : ℝ → ℝ) (Tstar : EReal) (C κ' : ℝ) (𝒮 : ℝ → Prop)
    (_hT : 0 < Tstar) (hC : 0 ≤ C) (hκ : 0 < κ')
    (hcont : ∀ t : ℝ, 0 ≤ t → (t : EReal) < Tstar → ContinuousOn M (Icc 0 t))
    (hd : ∀ t : ℝ, 0 < t → (t : EReal) < Tstar → HasDerivAt M (deriv M t) t)
    (hR : ∀ t : ℝ, 0 < t → (t : EReal) < Tstar → deriv M t ≤ C - κ' * M t ^ 2)
    (hBKM : Tstar ≠ ⊤ → ¬ BddAbove (M '' {t : ℝ | 0 ≤ t ∧ (t : EReal) < Tstar}))
    (hPS : ∀ T : ℝ, 0 < T → (T : EReal) < Tstar → 𝒮 T) :
    (∀ t : ℝ, 0 ≤ t → (t : EReal) < Tstar → M t ≤ max (M 0) (Real.sqrt (C / κ'))) ∧
      Tstar = ⊤ ∧ ∀ T : ℝ, 0 < T → 𝒮 T := by
  have hb : ∀ t : ℝ, 0 ≤ t → (t : EReal) < Tstar →
      M t ≤ max (M 0) (Real.sqrt (C / κ')) := by
    intro t ht htT
    exact riccati_bound_Icc M C κ' t hκ hC ht (hcont t ht htT)
      (fun s hs => hd s hs.1 (lt_trans (EReal.coe_lt_coe_iff.mpr hs.2) htT))
      (fun s hs => hR s hs.1 (lt_trans (EReal.coe_lt_coe_iff.mpr hs.2) htT))
  have hT : Tstar = ⊤ := by
    by_contra hne
    apply hBKM hne
    refine ⟨max (M 0) (Real.sqrt (C / κ')), ?_⟩
    rintro _ ⟨t, ⟨ht, htT⟩, rfl⟩
    exact hb t ht htT
  refine ⟨hb, hT, fun T hT0 => hPS T hT0 ?_⟩
  rw [hT]
  exact EReal.coe_lt_top T

end MirrorMetriplectic
