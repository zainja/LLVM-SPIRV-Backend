//===- IntrinsicsSPIRV.td - Defines SPIRV intrinsics -------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines all of the SPIRV-specific intrinsics.
//
//===----------------------------------------------------------------------===//

//TODO define some intrinsics

let TargetPrefix = "spirv" in {
    def int_spirv_builtin_ext : Intrinsic<[llvm_any_ty], [llvm_i32_ty, llvm_vararg_ty], []>;
    def int_spirv_workgroup : Intrinsic<[llvm_any_ty], [llvm_i32_ty], [ImmArg<ArgIndex<0>>]>;
    def int_spirv_read_sampled_image : Intrinsic<[llvm_anyvector_ty], [llvm_anyptr_ty, llvm_anyptr_ty, llvm_anyvector_ty]>;
    def int_spirv_read_image : Intrinsic<[llvm_anyvector_ty], [llvm_anyptr_ty, llvm_anyvector_ty]>;
}