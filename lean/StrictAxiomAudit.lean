/-
Copyright (c) 2026 Benjamin Stanley Frohman. Apache-2.0.
Author: Benjamin Stanley Frohman.
-/
import MirrorMetriplectic.Basic
open Lean Elab Command

/-!
# Strict whole-library axiom audit

For every non-internal declaration (theorems, definitions, structures, instances, ...)
defined in a module whose name starts with one of the prefixes below, compute the axioms
it depends on (`collectAxioms`). The command raises an error, so
`lake env lean StrictAxiomAudit.lean` exits non-zero, if

* any declaration depends on an axiom other than `propext`, `Classical.choice`,
  `Quot.sound` (this includes `sorryAx` from `sorry`/`admit` and `Lean.ofReduceBool`
  from `native_decide`), or
* any `axiom` declaration is made inside the audited modules, or
* no declaration at all is found (a vacuous audit).

A pass means only that the Lean kernel accepts these definitions and proofs from the
three standard axioms. It says nothing about whether the definitions match the
mathematics or physics they are named after.
-/

elab "#strict_library_audit" : command => do
  let env ← getEnv
  let std : List Name := [``propext, ``Classical.choice, ``Quot.sound]
  let prefixes : List Name := [`MirrorMetriplectic]
  let excluded : List Name := []
  let mut nThm := 0
  let mut nDecl := 0
  let mut mods : Array Name := #[]
  let mut bad : Array String := #[]
  for (c, ci) in env.constants.toList do
    let some idx := env.getModuleIdxFor? c | continue
    let mod := env.header.moduleNames[idx.toNat]!
    unless prefixes.any (fun p => p.isPrefixOf mod) do continue
    if excluded.contains mod then continue
    if c.isInternal then continue
    unless mods.contains mod do mods := mods.push mod
    nDecl := nDecl + 1
    if ci matches .axiomInfo _ then
      bad := bad.push s!"axiom declaration: {c} ({mod})"
    if ci matches .thmInfo _ then
      nThm := nThm + 1
    let axs ← liftCoreM (collectAxioms c)
    for a in axs do
      unless std.contains a do
        bad := bad.push s!"{c} ({mod}) depends on nonstandard axiom {a}"
  for m in (mods.map toString).qsort (· < ·) do
    IO.println s!"STRICT AUDIT MODULE: {m}"
  for m in excluded do
    IO.println s!"STRICT AUDIT EXCLUDED MODULE: {m}"
  IO.println s!"STRICT AUDIT SUMMARY: modules: {mods.size}; declarations: {nDecl}; theorems: {nThm}; violations: {bad.size}"
  if nDecl == 0 then
    throwError "strict axiom audit found no declarations (vacuous audit)"
  if bad.isEmpty then
    IO.println "STRICT AUDIT PASS: only propext, Classical.choice, Quot.sound; no sorryAx; no axiom declarations"
  else
    for b in bad do IO.println s!"STRICT AUDIT FAIL: {b}"
    throwError m!"strict axiom audit failed with {bad.size} violation(s)"

#strict_library_audit
