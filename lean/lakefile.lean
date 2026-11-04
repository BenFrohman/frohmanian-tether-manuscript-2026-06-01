import Lake
open Lake DSL

package «MirrorMetriplectic»

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.30.0-rc1"

@[default_target]
lean_lib «MirrorMetriplectic» where
  roots := #[`MirrorMetriplectic.Basic]
