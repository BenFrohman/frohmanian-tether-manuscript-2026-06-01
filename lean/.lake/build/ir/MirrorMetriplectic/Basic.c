// Lean compiler output
// Module: MirrorMetriplectic.Basic
// Imports: public import Init public import Mathlib
#include <lean/lean.h>
#if defined(__clang__)
#pragma clang diagnostic ignored "-Wunused-parameter"
#pragma clang diagnostic ignored "-Wunused-label"
#elif defined(__GNUC__) && !defined(__CLANG__)
#pragma GCC diagnostic ignored "-Wunused-parameter"
#pragma GCC diagnostic ignored "-Wunused-label"
#pragma GCC diagnostic ignored "-Wunused-but-set-variable"
#endif
#ifdef __cplusplus
extern "C" {
#endif
lean_object* lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_4214226450____hygCtx___hyg_8_(lean_object*, lean_object*, lean_object*);
lean_object* l_List_finRange(lean_object*);
lean_object* lp_mathlib_Finset_sum___at___00BoundingSieve_multSum_spec__0___redArg(lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_MirrorMetriplectic_MirrorMetriplectic_tether___lam__0(lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_MirrorMetriplectic_MirrorMetriplectic_tether(lean_object*, lean_object*, lean_object*, lean_object*, lean_object*);
LEAN_EXPORT lean_object* lp_MirrorMetriplectic_MirrorMetriplectic_tether___lam__0(lean_object* v_w_1_, lean_object* v_a_2_, lean_object* v_b_3_, lean_object* v_i_4_){
_start:
{
lean_object* v___x_5_; lean_object* v___x_6_; lean_object* v___f_7_; lean_object* v___x_8_; lean_object* v___f_9_; 
lean_inc_n(v_i_4_, 2);
v___x_5_ = lean_apply_1(v_w_1_, v_i_4_);
v___x_6_ = lean_apply_1(v_a_2_, v_i_4_);
v___f_7_ = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_4214226450____hygCtx___hyg_8_), 3, 2);
lean_closure_set(v___f_7_, 0, v___x_5_);
lean_closure_set(v___f_7_, 1, v___x_6_);
v___x_8_ = lean_apply_1(v_b_3_, v_i_4_);
v___f_9_ = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_4214226450____hygCtx___hyg_8_), 3, 2);
lean_closure_set(v___f_9_, 0, v___f_7_);
lean_closure_set(v___f_9_, 1, v___x_8_);
return v___f_9_;
}
}
LEAN_EXPORT lean_object* lp_MirrorMetriplectic_MirrorMetriplectic_tether(lean_object* v_n_10_, lean_object* v_00_u03ba_11_, lean_object* v_w_12_, lean_object* v_a_13_, lean_object* v_b_14_){
_start:
{
lean_object* v___f_15_; lean_object* v___x_16_; lean_object* v___x_17_; lean_object* v___f_18_; 
v___f_15_ = lean_alloc_closure((void*)(lp_MirrorMetriplectic_MirrorMetriplectic_tether___lam__0), 4, 3);
lean_closure_set(v___f_15_, 0, v_w_12_);
lean_closure_set(v___f_15_, 1, v_a_13_);
lean_closure_set(v___f_15_, 2, v_b_14_);
v___x_16_ = l_List_finRange(v_n_10_);
v___x_17_ = lp_mathlib_Finset_sum___at___00BoundingSieve_multSum_spec__0___redArg(v___x_16_, v___f_15_);
v___f_18_ = lean_alloc_closure((void*)(lp_mathlib_Real_definition___lam__0_00___x40_Mathlib_Data_Real_Basic_4214226450____hygCtx___hyg_8_), 3, 2);
lean_closure_set(v___f_18_, 0, v_00_u03ba_11_);
lean_closure_set(v___f_18_, 1, v___x_17_);
return v___f_18_;
}
}
lean_object* initialize_Init(uint8_t builtin);
lean_object* initialize_mathlib_Mathlib(uint8_t builtin);
static bool _G_initialized = false;
LEAN_EXPORT lean_object* initialize_MirrorMetriplectic_MirrorMetriplectic_Basic(uint8_t builtin) {
lean_object * res;
if (_G_initialized) return lean_io_result_mk_ok(lean_box(0));
_G_initialized = true;
res = initialize_Init(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
res = initialize_mathlib_Mathlib(builtin);
if (lean_io_result_is_error(res)) return res;
lean_dec_ref(res);
return lean_io_result_mk_ok(lean_box(0));
}
#ifdef __cplusplus
}
#endif
