// RUN: mlir-opt -split-input-file -verify-diagnostics %s | FileCheck %s

//===----------------------------------------------------------------------===//
// spv.CompositeConstruct
//===----------------------------------------------------------------------===//

func @composite_construct_vector(%arg0: f32, %arg1: f32, %arg2 : f32) -> vector<3xf32> {
  // CHECK: spv.CompositeConstruct {{%.*}}, {{%.*}}, {{%.*}} : vector<3xf32>
  %0 = spv.CompositeConstruct %arg0, %arg1, %arg2 : vector<3xf32>
  return %0: vector<3xf32>
}

// -----

func @composite_construct_struct(%arg0: vector<3xf32>, %arg1: !spv.array<4xf32>, %arg2 : !spv.struct<f32>) -> !spv.struct<vector<3xf32>, !spv.array<4xf32>, !spv.struct<f32>> {
  // CHECK: spv.CompositeConstruct %arg0, %arg1, %arg2 : !spv.struct<vector<3xf32>, !spv.array<4 x f32>, !spv.struct<f32>>
  %0 = spv.CompositeConstruct %arg0, %arg1, %arg2 : !spv.struct<vector<3xf32>, !spv.array<4xf32>, !spv.struct<f32>>
  return %0: !spv.struct<vector<3xf32>, !spv.array<4xf32>, !spv.struct<f32>>
}

// -----

func @composite_construct_empty_struct() -> !spv.struct<> {
  // CHECK: spv.CompositeConstruct : !spv.struct<>
  %0 = spv.CompositeConstruct : !spv.struct<>
  return %0: !spv.struct<>
}

// -----

func @composite_construct_invalid_num_of_elements(%arg0: f32) -> f32 {
  // expected-error @+1 {{result type must be a composite type, but provided 'f32'}}
  %0 = spv.CompositeConstruct %arg0 : f32
  return %0: f32
}

// -----

func @composite_construct_invalid_result_type(%arg0: f32, %arg1: f32, %arg2 : f32) -> vector<3xf32> {
  // expected-error @+1 {{has incorrect number of operands: expected 3, but provided 2}}
  %0 = spv.CompositeConstruct %arg0, %arg2 : vector<3xf32>
  return %0: vector<3xf32>
}

// -----

func @composite_construct_invalid_operand_type(%arg0: f32, %arg1: f32, %arg2 : f32) -> vector<3xi32> {
  // expected-error @+1 {{operand type mismatch: expected operand type 'i32', but provided 'f32'}}
  %0 = "spv.CompositeConstruct" (%arg0, %arg1, %arg2) : (f32, f32, f32) -> vector<3xi32>
  return %0: vector<3xi32>
}

// -----

//===----------------------------------------------------------------------===//
// spv.CompositeExtractOp
//===----------------------------------------------------------------------===//

func @composite_extract_array(%arg0: !spv.array<4xf32>) -> f32 {
  // CHECK: {{%.*}} = spv.CompositeExtract {{%.*}}[1 : i32] : !spv.array<4 x f32>
  %0 = spv.CompositeExtract %arg0[1 : i32] : !spv.array<4xf32>
  return %0: f32
}

// -----

func @composite_extract_struct(%arg0 : !spv.struct<f32, !spv.array<4xf32>>) -> f32 {
  // CHECK: {{%.*}} = spv.CompositeExtract {{%.*}}[1 : i32, 2 : i32] : !spv.struct<f32, !spv.array<4 x f32>>
  %0 = spv.CompositeExtract %arg0[1 : i32, 2 : i32] : !spv.struct<f32, !spv.array<4xf32>>
  return %0 : f32
}

// -----

func @composite_extract_vector(%arg0 : vector<4xf32>) -> f32 {
  // CHECK: {{%.*}} = spv.CompositeExtract {{%.*}}[1 : i32] : vector<4xf32>
  %0 = spv.CompositeExtract %arg0[1 : i32] : vector<4xf32>
  return %0 : f32
}

// -----

func @composite_extract_no_ssa_operand() -> () {
  // expected-error @+1 {{expected SSA operand}}
  %0 = spv.CompositeExtract [4 : i32, 1 : i32] : !spv.array<4x!spv.array<4xf32>>
  return
}

// -----

func @composite_extract_invalid_index_type_1() -> () {
  %0 = spv.constant 10 : i32
  %1 = spv.Variable : !spv.ptr<!spv.array<4x!spv.array<4xf32>>, Function>
  %2 = spv.Load "Function" %1 ["Volatile"] : !spv.array<4x!spv.array<4xf32>>
  // expected-error @+1 {{expected non-function type}}
  %3 = spv.CompositeExtract %2[%0] : !spv.array<4x!spv.array<4xf32>>
  return
}

// -----

func @composite_extract_invalid_index_type_2(%arg0 : !spv.array<4x!spv.array<4xf32>>) -> () {
  // expected-error @+1 {{op attribute 'indices' failed to satisfy constraint: 32-bit integer array attribute}}
  %0 = spv.CompositeExtract %arg0[1] : !spv.array<4x!spv.array<4xf32>>
  return
}

// -----

func @composite_extract_invalid_index_identifier(%arg0 : !spv.array<4x!spv.array<4xf32>>) -> () {
  // expected-error @+1 {{expected bare identifier}}
  %0 = spv.CompositeExtract %arg0(1 : i32) : !spv.array<4x!spv.array<4xf32>>
  return
}

// -----

func @composite_extract_2D_array_out_of_bounds_access_1(%arg0: !spv.array<4x!spv.array<4xf32>>) -> () {
  // expected-error @+1 {{index 4 out of bounds for '!spv.array<4 x !spv.array<4 x f32>>'}}
  %0 = spv.CompositeExtract %arg0[4 : i32, 1 : i32] : !spv.array<4x!spv.array<4xf32>>
  return
}

// -----

func @composite_extract_2D_array_out_of_bounds_access_2(%arg0: !spv.array<4x!spv.array<4xf32>>
) -> () {
  // expected-error @+1 {{index 4 out of bounds for '!spv.array<4 x f32>'}}
  %0 = spv.CompositeExtract %arg0[1 : i32, 4 : i32] : !spv.array<4x!spv.array<4xf32>>
  return
}

// -----

func @composite_extract_struct_element_out_of_bounds_access(%arg0 : !spv.struct<f32, !spv.array<4xf32>>) -> () {
  // expected-error @+1 {{index 2 out of bounds for '!spv.struct<f32, !spv.array<4 x f32>>'}}
  %0 = spv.CompositeExtract %arg0[2 : i32, 0 : i32] : !spv.struct<f32, !spv.array<4xf32>>
  return
}

// -----

func @composite_extract_vector_out_of_bounds_access(%arg0: vector<4xf32>) -> () {
  // expected-error @+1 {{index 4 out of bounds for 'vector<4xf32>'}}
  %0 = spv.CompositeExtract %arg0[4 : i32] : vector<4xf32>
  return
}

// -----

func @composite_extract_invalid_types_1(%arg0: !spv.array<4x!spv.array<4xf32>>) -> () {
  // expected-error @+1 {{cannot extract from non-composite type 'f32' with index 3}}
  %0 = spv.CompositeExtract %arg0[1 : i32, 2 : i32, 3 : i32] : !spv.array<4x!spv.array<4xf32>>
  return
}

// -----

func @composite_extract_invalid_types_2(%arg0: f32) -> () {
  // expected-error @+1 {{cannot extract from non-composite type 'f32' with index 1}}
  %0 = spv.CompositeExtract %arg0[1 : i32] : f32
  return
}

// -----

func @composite_extract_invalid_extracted_type(%arg0: !spv.array<4x!spv.array<4xf32>>) -> () {
  // expected-error @+1 {{expected at least one index for spv.CompositeExtract}}
  %0 = spv.CompositeExtract %arg0[] : !spv.array<4x!spv.array<4xf32>>
  return
}

// -----

func @composite_extract_result_type_mismatch(%arg0: !spv.array<4xf32>) -> i32 {
  // expected-error @+1 {{invalid result type: expected 'f32' but provided 'i32'}}
  %0 = "spv.CompositeExtract"(%arg0) {indices = [2: i32]} : (!spv.array<4xf32>) -> (i32)
  return %0: i32
}

// -----

//===----------------------------------------------------------------------===//
// spv.CompositeInsert
//===----------------------------------------------------------------------===//

func @composite_insert_array(%arg0: !spv.array<4xf32>, %arg1: f32) -> !spv.array<4xf32> {
  // CHECK: {{%.*}} = spv.CompositeInsert {{%.*}}, {{%.*}}[1 : i32] : f32 into !spv.array<4 x f32>
  %0 = spv.CompositeInsert %arg1, %arg0[1 : i32] : f32 into !spv.array<4xf32>
  return %0: !spv.array<4xf32>
}

// -----

func @composite_insert_struct(%arg0: !spv.struct<!spv.array<4xf32>, f32>, %arg1: !spv.array<4xf32>) -> !spv.struct<!spv.array<4xf32>, f32> {
  // CHECK: {{%.*}} = spv.CompositeInsert {{%.*}}, {{%.*}}[0 : i32] : !spv.array<4 x f32> into !spv.struct<!spv.array<4 x f32>, f32>
  %0 = spv.CompositeInsert %arg1, %arg0[0 : i32] : !spv.array<4xf32> into !spv.struct<!spv.array<4xf32>, f32>
  return %0: !spv.struct<!spv.array<4xf32>, f32>
}

// -----

func @composite_insert_no_indices(%arg0: !spv.array<4xf32>, %arg1: f32) -> !spv.array<4xf32> {
  // expected-error @+1 {{expected at least one index}}
  %0 = spv.CompositeInsert %arg1, %arg0[] : f32 into !spv.array<4xf32>
  return %0: !spv.array<4xf32>
}

// -----

func @composite_insert_out_of_bounds(%arg0: !spv.array<4xf32>, %arg1: f32) -> !spv.array<4xf32> {
  // expected-error @+1 {{index 4 out of bounds}}
  %0 = spv.CompositeInsert %arg1, %arg0[4 : i32] : f32 into !spv.array<4xf32>
  return %0: !spv.array<4xf32>
}

// -----

func @composite_insert_invalid_object_type(%arg0: !spv.array<4xf32>, %arg1: f64) -> !spv.array<4xf32> {
  // expected-error @+1 {{object operand type should be 'f32', but found 'f64'}}
  %0 = spv.CompositeInsert %arg1, %arg0[3 : i32] : f64 into !spv.array<4xf32>
  return %0: !spv.array<4xf32>
}

// -----

func @composite_insert_invalid_result_type(%arg0: !spv.array<4xf32>, %arg1 : f32) -> !spv.array<4xf64> {
  // expected-error @+1 {{result type should be the same as the composite type, but found '!spv.array<4 x f32>' vs '!spv.array<4 x f64>'}}
  %0 = "spv.CompositeInsert"(%arg1, %arg0) {indices = [0: i32]} : (f32, !spv.array<4xf32>) -> !spv.array<4xf64>
  return %0: !spv.array<4xf64>
}
