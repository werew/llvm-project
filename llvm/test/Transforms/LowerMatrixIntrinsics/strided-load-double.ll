; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -lower-matrix-intrinsics -S < %s | FileCheck %s
; RUN: opt -passes='lower-matrix-intrinsics' -S < %s | FileCheck %s

define <9 x double> @strided_load_3x3(<9 x double>* %in, i32 %stride) {
; CHECK-LABEL: @strided_load_3x3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast <9 x double>* [[IN:%.*]] to double*
; CHECK-NEXT:    [[TMP1:%.*]] = mul i32 0, [[STRIDE:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr double, double* [[TMP0]], i32 [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast double* [[TMP2]] to <3 x double>*
; CHECK-NEXT:    [[TMP4:%.*]] = load <3 x double>, <3 x double>* [[TMP3]], align 8
; CHECK-NEXT:    [[TMP5:%.*]] = mul i32 1, [[STRIDE]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr double, double* [[TMP0]], i32 [[TMP5]]
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast double* [[TMP6]] to <3 x double>*
; CHECK-NEXT:    [[TMP8:%.*]] = load <3 x double>, <3 x double>* [[TMP7]], align 8
; CHECK-NEXT:    [[TMP9:%.*]] = mul i32 2, [[STRIDE]]
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr double, double* [[TMP0]], i32 [[TMP9]]
; CHECK-NEXT:    [[TMP11:%.*]] = bitcast double* [[TMP10]] to <3 x double>*
; CHECK-NEXT:    [[TMP12:%.*]] = load <3 x double>, <3 x double>* [[TMP11]], align 8
; CHECK-NEXT:    [[TMP13:%.*]] = shufflevector <3 x double> [[TMP4]], <3 x double> [[TMP8]], <6 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5>
; CHECK-NEXT:    [[TMP14:%.*]] = shufflevector <3 x double> [[TMP12]], <3 x double> undef, <6 x i32> <i32 0, i32 1, i32 2, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP15:%.*]] = shufflevector <6 x double> [[TMP13]], <6 x double> [[TMP14]], <9 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8>
; CHECK-NEXT:    ret <9 x double> [[TMP15]]
;
entry:
  %load = call <9 x double> @llvm.matrix.columnwise.load(<9 x double>* %in, i32 %stride, i32 3, i32 3)
  ret <9 x double> %load
}

declare <9 x double> @llvm.matrix.columnwise.load(<9 x double>*, i32, i32, i32)

define <9 x double> @strided_load_9x1(<9 x double>* %in, i32 %stride) {
; CHECK-LABEL: @strided_load_9x1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast <9 x double>* [[IN:%.*]] to double*
; CHECK-NEXT:    [[TMP1:%.*]] = mul i32 0, [[STRIDE:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr double, double* [[TMP0]], i32 [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast double* [[TMP2]] to <9 x double>*
; CHECK-NEXT:    [[TMP4:%.*]] = load <9 x double>, <9 x double>* [[TMP3]], align 8
; CHECK-NEXT:    ret <9 x double> [[TMP4]]
;
entry:
  %load = call <9 x double> @llvm.matrix.columnwise.load(<9 x double>* %in, i32 %stride, i32 9, i32 1)
  ret <9 x double> %load
}

declare <8 x double> @llvm.matrix.columnwise.load.v8f64(<8 x double>*, i32, i32, i32)

define <8 x double> @strided_load_4x2(<8 x double>* %in, i32 %stride) {
; CHECK-LABEL: @strided_load_4x2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast <8 x double>* [[IN:%.*]] to double*
; CHECK-NEXT:    [[TMP1:%.*]] = mul i32 0, [[STRIDE:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr double, double* [[TMP0]], i32 [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast double* [[TMP2]] to <4 x double>*
; CHECK-NEXT:    [[TMP4:%.*]] = load <4 x double>, <4 x double>* [[TMP3]], align 8
; CHECK-NEXT:    [[TMP5:%.*]] = mul i32 1, [[STRIDE]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr double, double* [[TMP0]], i32 [[TMP5]]
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast double* [[TMP6]] to <4 x double>*
; CHECK-NEXT:    [[TMP8:%.*]] = load <4 x double>, <4 x double>* [[TMP7]], align 8
; CHECK-NEXT:    [[TMP9:%.*]] = shufflevector <4 x double> [[TMP4]], <4 x double> [[TMP8]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    ret <8 x double> [[TMP9]]
;
entry:
  %load = call <8 x double> @llvm.matrix.columnwise.load.v8f64(<8 x double>* %in, i32 %stride, i32 4, i32 2)
  ret <8 x double> %load
}
