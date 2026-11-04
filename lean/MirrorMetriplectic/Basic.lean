/-
Copyright (c) 2026 Benjamin Stanley Frohman. Released under Apache-2.0.
Authors: Benjamin Stanley Frohman
Finite-dimensional metriplectic split and Frohman's mirror principle.
-/
import Mathlib

namespace MirrorMetriplectic

variable {V : Type*} [AddCommGroup V] [Module ℝ V]

/-- A bilinear form is antisymmetric ("2-form"). -/
def IsAntisymm (B : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) : Prop := ∀ a b, B a b = - B b a
/-- A bilinear form is symmetric. -/
def IsSymm (B : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) : Prop := ∀ a b, B a b = B b a
/-- Positive semidefinite. -/
def IsPSD (B : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) : Prop := ∀ a, 0 ≤ B a a

/-- Metriplectic data: Poisson-type `J`, tether metric `G`, energy/entropy gradients. -/
structure Metriplectic (V : Type*) [AddCommGroup V] [Module ℝ V] where
  J : V →ₗ[ℝ] V →ₗ[ℝ] ℝ
  G : V →ₗ[ℝ] V →ₗ[ℝ] ℝ
  dH : V
  dS : V
  J_antisymm : IsAntisymm J
  G_symm : IsSymm G
  G_psd : IsPSD G
  degen_J : ∀ a, J a dS = 0
  degen_G : ∀ a, G a dH = 0

/-- Rate of change of an observable with gradient `dF`. -/
noncomputable def Metriplectic.rate (M : Metriplectic V) (dF : V) : ℝ := M.J dF M.dH + M.G dF M.dS

/-- Energy conservation: `dH/dt = 0`. -/
theorem energy_conserved (M : Metriplectic V) : M.rate M.dH = 0 := by
  have h := M.J_antisymm M.dH M.dH
  have hJ : M.J M.dH M.dH = 0 := by linarith
  simp [Metriplectic.rate, hJ, M.G_symm M.dH M.dS, M.degen_G]

/-- Entropy monotonicity: `dS/dt ≥ 0`. -/
theorem entropy_monotone (M : Metriplectic V) : 0 ≤ M.rate M.dS := by
  have h := M.J_antisymm M.dS M.dH
  simp only [Metriplectic.rate, h, M.degen_J, neg_zero, zero_add]
  exact M.G_psd M.dS

/-- Mirror lemma: a symmetric form plus any scaled mirror `c • G` stays symmetric. -/
theorem mirror_symm (G : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (hG : IsSymm G) (c : ℝ) :
    IsSymm (G + c • G) := by
  intro a b; simp [hG a b]

/-- A form that is both symmetric and antisymmetric is zero. -/
theorem symm_antisymm_zero (B : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (hs : IsSymm B) (ha : IsAntisymm B) :
    ∀ a b, B a b = 0 := by
  intro a b; have h1 := ha a b; have h2 := hs a b; linarith

/-- Hence symmetric + mirror is a 2-form only if it vanishes. -/
theorem mirror_not_two_form (G : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (hG : IsSymm G) (c : ℝ)
    (ha : IsAntisymm (G + c • G)) : ∀ a b, (G + c • G) a b = 0 :=
  symm_antisymm_zero _ (mirror_symm G hG c) ha

/-- Symmetric part. -/
noncomputable def symPart (B : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (a b : V) : ℝ := (B a b + B b a) / 2

/-- A bracket is a 2-form iff its symmetric part vanishes. -/
theorem antisymm_iff_symPart_zero (B : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) :
    IsAntisymm B ↔ ∀ a b, symPart B a b = 0 := by
  constructor
  · intro h a b; simp [symPart, h a b]
  · intro h a b; have := h a b; simp [symPart] at this; linarith

/-- Projection lemma: if `P dH = 0` then `G(P·,P·)` annihilates `dH`. -/
theorem proj_degenerate (G : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (P : V →ₗ[ℝ] V) (dH : V)
    (hP : P dH = 0) : ∀ a, G (P a) (P dH) = 0 := by
  intro a; simp [hP]

theorem proj_symm (G : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (hG : IsSymm G) (P : V →ₗ[ℝ] V) :
    ∀ a b, G (P a) (P b) = G (P b) (P a) := fun _ _ => hG _ _

theorem proj_psd (G : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (hG : IsPSD G) (P : V →ₗ[ℝ] V) :
    ∀ a, 0 ≤ G (P a) (P a) := fun _ => hG _

/-! ### Galerkin instance: the `|ω|²`-weighted tether on `Fin n → ℝ`. -/

/-- Weighted tether `g_w(a,b) = κ Σ wᵢ aᵢ bᵢ` with `wᵢ = |ωᵢ|²`. -/
def tether {n : ℕ} (κ : ℝ) (w : Fin n → ℝ) (a b : Fin n → ℝ) : ℝ :=
  κ * ∑ i, w i * a i * b i

theorem tether_symm {n : ℕ} (κ : ℝ) (w a b : Fin n → ℝ) :
    tether κ w a b = tether κ w b a := by
  unfold tether; congr 1; exact Finset.sum_congr rfl (fun i _ => by ring)

theorem tether_psd {n : ℕ} (κ : ℝ) (hκ : 0 ≤ κ) (ω a : Fin n → ℝ) :
    0 ≤ tether κ (fun i => ω i ^ 2) a a := by
  unfold tether
  exact mul_nonneg hκ (Finset.sum_nonneg (fun i _ => by nlinarith [sq_nonneg (ω i * a i)]))

/-- Projected tether annihilates `dH` when the projection kills `dH`. -/
theorem tether_proj_degenerate {n : ℕ} (κ : ℝ) (w : Fin n → ℝ)
    (P : (Fin n → ℝ) → (Fin n → ℝ)) (dH : Fin n → ℝ) (hP : P dH = 0) (a : Fin n → ℝ) :
    tether κ w (P a) (P dH) = 0 := by
  simp [tether, hP]

/-! ### Conditional regularity: comparison step only.
Log-Sobolev and BKM are cited, not formalized. -/

theorem riccati_bound (M : ℝ → ℝ) (C κ' : ℝ) (hκ : 0 < κ') (hC : 0 ≤ C)
    (hd : ∀ t, HasDerivAt M (deriv M t) t)
    (hR : ∀ t, 0 ≤ t → deriv M t ≤ C - κ' * M t ^ 2) :
    ∀ t, 0 ≤ t → M t ≤ max (M 0) (Real.sqrt (C / κ')) := by
  set K := max (M 0) (Real.sqrt (C / κ'))
  intro t ht
  by_contra hlt
  push_neg at hlt
  have hcont : Continuous M := continuous_iff_continuousAt.2 (fun s => (hd s).continuousAt)
  set S := {s | s ∈ Set.Icc 0 t ∧ M s ≤ K}
  have h0 : (0:ℝ) ∈ S := ⟨⟨le_refl _, ht⟩, le_max_left _ _⟩
  have hbdd : BddAbove S := ⟨t, fun s hs => hs.1.2⟩
  have hclosed : IsClosed S :=
    (isClosed_Icc).inter (isClosed_le hcont continuous_const)
  have hs₀ : sSup S ∈ S := hclosed.csSup_mem ⟨0, h0⟩ hbdd
  have hs₀t : sSup S < t :=
    lt_of_le_of_ne hs₀.1.2 (fun h => by have := hs₀.2; rw [h] at this; linarith)
  have hgt : ∀ u ∈ Set.Ioc (sSup S) t, K < M u := by
    intro u hu; by_contra hle; push_neg at hle
    have : u ≤ sSup S := le_csSup hbdd ⟨⟨by linarith [hs₀.1.1, hu.1], hu.2⟩, hle⟩
    linarith [hu.1]
  have hsq : Real.sqrt (C / κ') ≤ K := le_max_right _ _
  have hneg : ∀ u ∈ Set.Ioo (sSup S) t, deriv M u < 0 := by
    intro u hu
    have hKu := hgt u ⟨hu.1, hu.2.le⟩
    have hpos : 0 ≤ Real.sqrt (C / κ') := Real.sqrt_nonneg _
    have hM : Real.sqrt (C / κ') < M u := lt_of_le_of_lt hsq hKu
    have hs2 := Real.sq_sqrt (div_nonneg hC hκ.le)
    have h2 : C / κ' < M u ^ 2 := by nlinarith
    have h3 : C < κ' * M u ^ 2 := by
      rw [div_lt_iff₀ hκ] at h2; linarith
    linarith [hR u (by linarith [hs₀.1.1, hu.1])]
  obtain ⟨c, hc, hderiv⟩ := exists_deriv_eq_slope M hs₀t hcont.continuousOn
    (fun u _ => (hd u).differentiableAt.differentiableWithinAt)
  have hne : t - sSup S ≠ 0 := sub_ne_zero.2 hs₀t.ne'
  have key : deriv M c * (t - sSup S) = M t - M (sSup S) := by
    rw [hderiv]; field_simp
  have hdc := hneg c hc
  nlinarith [hs₀.2, sub_pos.2 hs₀t]

end MirrorMetriplectic
