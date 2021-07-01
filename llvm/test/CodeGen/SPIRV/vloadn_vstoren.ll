; RUN: llc -O0 -global-isel %s -o - | FileCheck %s

; VLOAD
; CHECK-DAG: %[[import:[0-9]+]] = OpExtInstImport "OpenCL.std"
; CHECK-DAG: %[[void:[0-9]+]] = OpTypeVoid
; CHECK-DAG: %[[uint:[0-9]+]] = OpTypeInt 32 0
; CHECK-DAG: %[[uint_0:[0-9]+]] = OpConstant %[[uint]] 0
; CHECK-DAG: %[[half:[0-9]+]] = OpTypeFloat 16
; CHECK-DAG: %[[v4half:[0-9]+]] = OpTypeVector %[[half]] 4
; CHECK-DAG: %[[_ptr_Generic_half:[0-9]+]] = OpTypePointer Generic %[[half]]
; CHECK: %[[ptr:[0-9]+]] = OpPtrCastToGeneric %[[_ptr_Generic_half]] %{{[0-9]+}}
; CHECK: %[[load:[0-9]+]] = OpExtInst %[[v4half]] %[[import]] vloadn %[[uint_0]] %[[ptr]] 4

; VSTORE
; CHECK: %{{[0-9]+}} = OpExtInst %[[void]] %[[import]] vstoren %{{[0-9]+}} %[[uint_0]] %{{[0-9]+}}


target datalayout = "e-p:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
target triple = "spirv32-unknown-unknown"

; Function Attrs: convergent norecurse nounwind
define dso_local spir_kernel void @depthwise_convolution_3x3_nhwc_stride1(i8 addrspace(1)* %0, i32 %1, i32 %2, i32 %3, i32 %4, i32 %5, i32 %6, i32 %7, i32 %8, i32 %9, i8 addrspace(1)* %10, i32 %11, i32 %12, i32 %13, i32 %14, i32 %15, i32 %16, i32 %17, i32 %18, i32 %19, i8 addrspace(1)* %20, i32 %21, i32 %22, i32 %23, i32 %24, i32 %25, i32 %26, i32 %27, i32 %28) local_unnamed_addr #0 !kernel_arg_addr_space !3 !kernel_arg_access_qual !4 !kernel_arg_type !5 !kernel_arg_base_type !5 !kernel_arg_type_qual !6 {
  %30 = tail call spir_func i32 @_Z13get_global_idj(i32 0) #3
  %31 = tail call spir_func i32 @_Z13get_global_idj(i32 1) #3
  %32 = tail call spir_func i32 @_Z13get_global_idj(i32 2) #3
  %33 = mul i32 %30, %22
  %34 = add i32 %33, %27
  %35 = getelementptr inbounds i8, i8 addrspace(1)* %20, i32 %34
  %36 = getelementptr inbounds i8, i8 addrspace(1)* %0, i32 %9
  %37 = shl i32 %30, 3
  %38 = getelementptr inbounds i8, i8 addrspace(1)* %36, i32 %37
  %39 = shl nsw i32 %31, 1
  %40 = insertelement <4 x i32> undef, i32 %39, i32 0
  %41 = shufflevector <4 x i32> %40, <4 x i32> undef, <4 x i32> zeroinitializer
  %42 = add <4 x i32> %41, <i32 -1, i32 0, i32 1, i32 2>
  %43 = insertelement <4 x i32> undef, i32 %3, i32 0
  %44 = shufflevector <4 x i32> %43, <4 x i32> undef, <4 x i32> zeroinitializer
  %45 = mul <4 x i32> %42, %44
  %46 = bitcast i8 addrspace(1)* %35 to half addrspace(1)*
  %47 = addrspacecast half addrspace(1)* %46 to half addrspace(4)*
  %48 = tail call spir_func <4 x half> @_Z6vload4jPU3AS4KDh(i32 0, half addrspace(4)* %47) #4
  %49 = getelementptr inbounds i8, i8 addrspace(1)* %35, i32 %23
  %50 = bitcast i8 addrspace(1)* %49 to half addrspace(1)*
  %51 = addrspacecast half addrspace(1)* %50 to half addrspace(4)*
  %52 = tail call spir_func <4 x half> @_Z6vload4jPU3AS4KDh(i32 0, half addrspace(4)* %51) #4
  %53 = shl i32 %23, 1
  %54 = getelementptr inbounds i8, i8 addrspace(1)* %35, i32 %53
  %55 = bitcast i8 addrspace(1)* %54 to half addrspace(1)*
  %56 = addrspacecast half addrspace(1)* %55 to half addrspace(4)*
  %57 = tail call spir_func <4 x half> @_Z6vload4jPU3AS4KDh(i32 0, half addrspace(4)* %56) #4
  %58 = getelementptr inbounds i8, i8 addrspace(1)* %35, i32 %25
  %59 = bitcast i8 addrspace(1)* %58 to half addrspace(1)*
  %60 = addrspacecast half addrspace(1)* %59 to half addrspace(4)*
  %61 = tail call spir_func <4 x half> @_Z6vload4jPU3AS4KDh(i32 0, half addrspace(4)* %60) #4
  %62 = getelementptr inbounds i8, i8 addrspace(1)* %49, i32 %25
  %63 = bitcast i8 addrspace(1)* %62 to half addrspace(1)*
  %64 = addrspacecast half addrspace(1)* %63 to half addrspace(4)*
  %65 = tail call spir_func <4 x half> @_Z6vload4jPU3AS4KDh(i32 0, half addrspace(4)* %64) #4
  %66 = getelementptr inbounds i8, i8 addrspace(1)* %54, i32 %25
  %67 = bitcast i8 addrspace(1)* %66 to half addrspace(1)*
  %68 = addrspacecast half addrspace(1)* %67 to half addrspace(4)*
  %69 = tail call spir_func <4 x half> @_Z6vload4jPU3AS4KDh(i32 0, half addrspace(4)* %68) #4
  %70 = shl i32 %25, 1
  %71 = getelementptr inbounds i8, i8 addrspace(1)* %35, i32 %70
  %72 = bitcast i8 addrspace(1)* %71 to half addrspace(1)*
  %73 = addrspacecast half addrspace(1)* %72 to half addrspace(4)*
  %74 = tail call spir_func <4 x half> @_Z6vload4jPU3AS4KDh(i32 0, half addrspace(4)* %73) #4
  %75 = getelementptr inbounds i8, i8 addrspace(1)* %49, i32 %70
  %76 = bitcast i8 addrspace(1)* %75 to half addrspace(1)*
  %77 = addrspacecast half addrspace(1)* %76 to half addrspace(4)*
  %78 = tail call spir_func <4 x half> @_Z6vload4jPU3AS4KDh(i32 0, half addrspace(4)* %77) #4
  %79 = getelementptr inbounds i8, i8 addrspace(1)* %54, i32 %70
  %80 = bitcast i8 addrspace(1)* %79 to half addrspace(1)*
  %81 = addrspacecast half addrspace(1)* %80 to half addrspace(4)*
  %82 = tail call spir_func <4 x half> @_Z6vload4jPU3AS4KDh(i32 0, half addrspace(4)* %81) #4
  %83 = shl nsw i32 %32, 1
  %84 = add nsw i32 %83, -1
  %85 = tail call spir_func i32 @_Z3minjj(i32 %84, i32 7) #3
  %86 = mul i32 %85, %5
  %87 = insertelement <4 x i32> undef, i32 %86, i32 0
  %88 = shufflevector <4 x i32> %87, <4 x i32> undef, <4 x i32> zeroinitializer
  %89 = add <4 x i32> %88, %45
  %90 = insertelement <4 x i32> undef, i32 %28, i32 0
  %91 = shufflevector <4 x i32> %90, <4 x i32> undef, <4 x i32> zeroinitializer
  %92 = tail call spir_func <4 x i32> @_Z3minDv4_iS_(<4 x i32> %89, <4 x i32> %91) #3
  %93 = extractelement <4 x i32> %92, i32 0
  %94 = getelementptr inbounds i8, i8 addrspace(1)* %38, i32 %93
  %95 = bitcast i8 addrspace(1)* %94 to half addrspace(1)*
  %96 = addrspacecast half addrspace(1)* %95 to half addrspace(4)*
  %97 = tail call spir_func <4 x half> @_Z6vload4jPU3AS4KDh(i32 0, half addrspace(4)* %96) #4
  %98 = extractelement <4 x i32> %92, i32 1
  %99 = getelementptr inbounds i8, i8 addrspace(1)* %38, i32 %98
  %100 = bitcast i8 addrspace(1)* %99 to half addrspace(1)*
  %101 = addrspacecast half addrspace(1)* %100 to half addrspace(4)*
  %102 = tail call spir_func <4 x half> @_Z6vload4jPU3AS4KDh(i32 0, half addrspace(4)* %101) #4
  %103 = extractelement <4 x i32> %92, i32 2
  %104 = getelementptr inbounds i8, i8 addrspace(1)* %38, i32 %103
  %105 = bitcast i8 addrspace(1)* %104 to half addrspace(1)*
  %106 = addrspacecast half addrspace(1)* %105 to half addrspace(4)*
  %107 = tail call spir_func <4 x half> @_Z6vload4jPU3AS4KDh(i32 0, half addrspace(4)* %106) #4
  %108 = extractelement <4 x i32> %92, i32 3
  %109 = getelementptr inbounds i8, i8 addrspace(1)* %38, i32 %108
  %110 = bitcast i8 addrspace(1)* %109 to half addrspace(1)*
  %111 = addrspacecast half addrspace(1)* %110 to half addrspace(4)*
  %112 = tail call spir_func <4 x half> @_Z6vload4jPU3AS4KDh(i32 0, half addrspace(4)* %111) #4
  %113 = mul i32 %83, %5
  %114 = insertelement <4 x i32> undef, i32 %113, i32 0
  %115 = shufflevector <4 x i32> %114, <4 x i32> undef, <4 x i32> zeroinitializer
  %116 = add <4 x i32> %45, %115
  %117 = extractelement <4 x i32> %116, i32 0
  %118 = getelementptr inbounds i8, i8 addrspace(1)* %38, i32 %117
  %119 = bitcast i8 addrspace(1)* %118 to half addrspace(1)*
  %120 = addrspacecast half addrspace(1)* %119 to half addrspace(4)*
  %121 = tail call spir_func <4 x half> @_Z6vload4jPU3AS4KDh(i32 0, half addrspace(4)* %120) #4
  %122 = extractelement <4 x i32> %116, i32 1
  %123 = getelementptr inbounds i8, i8 addrspace(1)* %38, i32 %122
  %124 = bitcast i8 addrspace(1)* %123 to half addrspace(1)*
  %125 = addrspacecast half addrspace(1)* %124 to half addrspace(4)*
  %126 = tail call spir_func <4 x half> @_Z6vload4jPU3AS4KDh(i32 0, half addrspace(4)* %125) #4
  %127 = extractelement <4 x i32> %116, i32 2
  %128 = getelementptr inbounds i8, i8 addrspace(1)* %38, i32 %127
  %129 = bitcast i8 addrspace(1)* %128 to half addrspace(1)*
  %130 = addrspacecast half addrspace(1)* %129 to half addrspace(4)*
  %131 = tail call spir_func <4 x half> @_Z6vload4jPU3AS4KDh(i32 0, half addrspace(4)* %130) #4
  %132 = extractelement <4 x i32> %116, i32 3
  %133 = getelementptr inbounds i8, i8 addrspace(1)* %38, i32 %132
  %134 = bitcast i8 addrspace(1)* %133 to half addrspace(1)*
  %135 = addrspacecast half addrspace(1)* %134 to half addrspace(4)*
  %136 = tail call spir_func <4 x half> @_Z6vload4jPU3AS4KDh(i32 0, half addrspace(4)* %135) #4
  %137 = insertelement <4 x i32> undef, i32 %5, i32 0
  %138 = shufflevector <4 x i32> %137, <4 x i32> undef, <4 x i32> zeroinitializer
  %139 = add <4 x i32> %116, %138
  %140 = tail call spir_func <4 x i32> @_Z3minDv4_iS_(<4 x i32> %139, <4 x i32> %91) #3
  %141 = extractelement <4 x i32> %140, i32 0
  %142 = getelementptr inbounds i8, i8 addrspace(1)* %38, i32 %141
  %143 = bitcast i8 addrspace(1)* %142 to half addrspace(1)*
  %144 = addrspacecast half addrspace(1)* %143 to half addrspace(4)*
  %145 = tail call spir_func <4 x half> @_Z6vload4jPU3AS4KDh(i32 0, half addrspace(4)* %144) #4
  %146 = extractelement <4 x i32> %140, i32 1
  %147 = getelementptr inbounds i8, i8 addrspace(1)* %38, i32 %146
  %148 = bitcast i8 addrspace(1)* %147 to half addrspace(1)*
  %149 = addrspacecast half addrspace(1)* %148 to half addrspace(4)*
  %150 = tail call spir_func <4 x half> @_Z6vload4jPU3AS4KDh(i32 0, half addrspace(4)* %149) #4
  %151 = extractelement <4 x i32> %140, i32 2
  %152 = getelementptr inbounds i8, i8 addrspace(1)* %38, i32 %151
  %153 = bitcast i8 addrspace(1)* %152 to half addrspace(1)*
  %154 = addrspacecast half addrspace(1)* %153 to half addrspace(4)*
  %155 = tail call spir_func <4 x half> @_Z6vload4jPU3AS4KDh(i32 0, half addrspace(4)* %154) #4
  %156 = extractelement <4 x i32> %140, i32 3
  %157 = getelementptr inbounds i8, i8 addrspace(1)* %38, i32 %156
  %158 = bitcast i8 addrspace(1)* %157 to half addrspace(1)*
  %159 = addrspacecast half addrspace(1)* %158 to half addrspace(4)*
  %160 = tail call spir_func <4 x half> @_Z6vload4jPU3AS4KDh(i32 0, half addrspace(4)* %159) #4
  %161 = add <4 x i32> %140, %138
  %162 = tail call spir_func <4 x i32> @_Z3minDv4_iS_(<4 x i32> %161, <4 x i32> %91) #3
  %163 = extractelement <4 x i32> %162, i32 0
  %164 = getelementptr inbounds i8, i8 addrspace(1)* %38, i32 %163
  %165 = bitcast i8 addrspace(1)* %164 to half addrspace(1)*
  %166 = addrspacecast half addrspace(1)* %165 to half addrspace(4)*
  %167 = tail call spir_func <4 x half> @_Z6vload4jPU3AS4KDh(i32 0, half addrspace(4)* %166) #4
  %168 = extractelement <4 x i32> %162, i32 1
  %169 = getelementptr inbounds i8, i8 addrspace(1)* %38, i32 %168
  %170 = bitcast i8 addrspace(1)* %169 to half addrspace(1)*
  %171 = addrspacecast half addrspace(1)* %170 to half addrspace(4)*
  %172 = tail call spir_func <4 x half> @_Z6vload4jPU3AS4KDh(i32 0, half addrspace(4)* %171) #4
  %173 = extractelement <4 x i32> %162, i32 2
  %174 = getelementptr inbounds i8, i8 addrspace(1)* %38, i32 %173
  %175 = bitcast i8 addrspace(1)* %174 to half addrspace(1)*
  %176 = addrspacecast half addrspace(1)* %175 to half addrspace(4)*
  %177 = tail call spir_func <4 x half> @_Z6vload4jPU3AS4KDh(i32 0, half addrspace(4)* %176) #4
  %178 = extractelement <4 x i32> %162, i32 3
  %179 = getelementptr inbounds i8, i8 addrspace(1)* %38, i32 %178
  %180 = bitcast i8 addrspace(1)* %179 to half addrspace(1)*
  %181 = addrspacecast half addrspace(1)* %180 to half addrspace(4)*
  %182 = tail call spir_func <4 x half> @_Z6vload4jPU3AS4KDh(i32 0, half addrspace(4)* %181) #4
  %183 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %97, <4 x half> %48, <4 x half> zeroinitializer) #3
  %184 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %102, <4 x half> %52, <4 x half> %183) #3
  %185 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %107, <4 x half> %57, <4 x half> %184) #3
  %186 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %102, <4 x half> %48, <4 x half> zeroinitializer) #3
  %187 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %107, <4 x half> %52, <4 x half> %186) #3
  %188 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %112, <4 x half> %57, <4 x half> %187) #3
  %189 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %121, <4 x half> %61, <4 x half> %185) #3
  %190 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %126, <4 x half> %65, <4 x half> %189) #3
  %191 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %131, <4 x half> %69, <4 x half> %190) #3
  %192 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %126, <4 x half> %61, <4 x half> %188) #3
  %193 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %131, <4 x half> %65, <4 x half> %192) #3
  %194 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %136, <4 x half> %69, <4 x half> %193) #3
  %195 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %145, <4 x half> %74, <4 x half> %191) #3
  %196 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %150, <4 x half> %78, <4 x half> %195) #3
  %197 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %155, <4 x half> %82, <4 x half> %196) #3
  %198 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %150, <4 x half> %74, <4 x half> %194) #3
  %199 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %155, <4 x half> %78, <4 x half> %198) #3
  %200 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %160, <4 x half> %82, <4 x half> %199) #3
  %201 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %121, <4 x half> %48, <4 x half> zeroinitializer) #3
  %202 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %126, <4 x half> %52, <4 x half> %201) #3
  %203 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %131, <4 x half> %57, <4 x half> %202) #3
  %204 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %126, <4 x half> %48, <4 x half> zeroinitializer) #3
  %205 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %131, <4 x half> %52, <4 x half> %204) #3
  %206 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %136, <4 x half> %57, <4 x half> %205) #3
  %207 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %145, <4 x half> %61, <4 x half> %203) #3
  %208 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %150, <4 x half> %65, <4 x half> %207) #3
  %209 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %155, <4 x half> %69, <4 x half> %208) #3
  %210 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %150, <4 x half> %61, <4 x half> %206) #3
  %211 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %155, <4 x half> %65, <4 x half> %210) #3
  %212 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %160, <4 x half> %69, <4 x half> %211) #3
  %213 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %167, <4 x half> %74, <4 x half> %209) #3
  %214 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %172, <4 x half> %78, <4 x half> %213) #3
  %215 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %177, <4 x half> %82, <4 x half> %214) #3
  %216 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %172, <4 x half> %74, <4 x half> %212) #3
  %217 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %177, <4 x half> %78, <4 x half> %216) #3
  %218 = tail call spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half> %182, <4 x half> %82, <4 x half> %217) #3
  %219 = getelementptr inbounds i8, i8 addrspace(1)* %10, i32 %19
  %220 = mul i32 %30, %12
  %221 = getelementptr inbounds i8, i8 addrspace(1)* %219, i32 %220
  %222 = mul i32 %31, %14
  %223 = getelementptr inbounds i8, i8 addrspace(1)* %221, i32 %222
  %224 = mul i32 %83, %16
  %225 = getelementptr inbounds i8, i8 addrspace(1)* %223, i32 %224
  %226 = bitcast i8 addrspace(1)* %225 to half addrspace(1)*
  %227 = addrspacecast half addrspace(1)* %226 to half addrspace(4)*
  tail call spir_func void @_Z7vstore4Dv4_DhjPU3AS4Dh(<4 x half> %197, i32 0, half addrspace(4)* %227) #4
  %228 = getelementptr inbounds i8, i8 addrspace(1)* %225, i32 %13
  %229 = bitcast i8 addrspace(1)* %228 to half addrspace(1)*
  %230 = addrspacecast half addrspace(1)* %229 to half addrspace(4)*
  tail call spir_func void @_Z7vstore4Dv4_DhjPU3AS4Dh(<4 x half> %200, i32 0, half addrspace(4)* %230) #4
  %231 = or i32 %83, 1
  %232 = icmp slt i32 %231, 7
  br i1 %232, label %233, label %240

233:                                              ; preds = %29
  %234 = getelementptr inbounds i8, i8 addrspace(1)* %225, i32 %15
  %235 = bitcast i8 addrspace(1)* %234 to half addrspace(1)*
  %236 = addrspacecast half addrspace(1)* %235 to half addrspace(4)*
  tail call spir_func void @_Z7vstore4Dv4_DhjPU3AS4Dh(<4 x half> %215, i32 0, half addrspace(4)* %236) #4
  %237 = getelementptr inbounds i8, i8 addrspace(1)* %228, i32 %15
  %238 = bitcast i8 addrspace(1)* %237 to half addrspace(1)*
  %239 = addrspacecast half addrspace(1)* %238 to half addrspace(4)*
  tail call spir_func void @_Z7vstore4Dv4_DhjPU3AS4Dh(<4 x half> %218, i32 0, half addrspace(4)* %239) #4
  br label %240

240:                                              ; preds = %233, %29
  ret void
}

; Function Attrs: convergent nounwind readnone willreturn
declare dso_local spir_func i32 @_Z13get_global_idj(i32) local_unnamed_addr #1

; Function Attrs: convergent
declare dso_local spir_func <4 x half> @_Z6vload4jPU3AS4KDh(i32, half addrspace(4)*) local_unnamed_addr #2

; Function Attrs: convergent nounwind readnone willreturn
declare dso_local spir_func i32 @_Z3minjj(i32, i32) local_unnamed_addr #1

; Function Attrs: convergent nounwind readnone willreturn
declare dso_local spir_func <4 x i32> @_Z3minDv4_iS_(<4 x i32>, <4 x i32>) local_unnamed_addr #1

; Function Attrs: convergent nounwind readnone willreturn
declare dso_local spir_func <4 x half> @_Z3fmaDv4_DhS_S_(<4 x half>, <4 x half>, <4 x half>) local_unnamed_addr #1

; Function Attrs: convergent
declare dso_local spir_func void @_Z7vstore4Dv4_DhjPU3AS4Dh(<4 x half>, i32, half addrspace(4)*) local_unnamed_addr #2

attributes #0 = { convergent norecurse nounwind "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="128" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "uniform-work-group-size"="false" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { convergent nounwind readnone willreturn "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { convergent "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { convergent nounwind readnone willreturn }
attributes #4 = { convergent nounwind }

!llvm.module.flags = !{!0}
!opencl.ocl.version = !{!1}
!opencl.spir.version = !{!1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 2, i32 0}
!2 = !{!"Ubuntu clang version 12.0.1-++20210605063015+0826268d59c6-1~exp1~20210605043739.106"}
!3 = !{i32 1, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0}
!4 = !{!"none", !"none", !"none", !"none", !"none", !"none", !"none", !"none", !"none", !"none", !"none", !"none", !"none", !"none", !"none", !"none", !"none", !"none", !"none", !"none", !"none", !"none", !"none", !"none", !"none", !"none", !"none", !"none", !"none"}
!5 = !{!"uchar*", !"uint", !"uint", !"uint", !"uint", !"uint", !"uint", !"uint", !"uint", !"uint", !"uchar*", !"uint", !"uint", !"uint", !"uint", !"uint", !"uint", !"uint", !"uint", !"uint", !"uchar*", !"uint", !"uint", !"uint", !"uint", !"uint", !"uint", !"uint", !"int"}
!6 = !{!"", !"", !"", !"", !"", !"", !"", !"", !"", !"", !"", !"", !"", !"", !"", !"", !"", !"", !"", !"", !"", !"", !"", !"", !"", !"", !"", !"", !""}
