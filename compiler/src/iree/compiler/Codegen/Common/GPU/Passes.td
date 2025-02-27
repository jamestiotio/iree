// Copyright 2023 The IREE Authors
//
// Licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#ifndef IREE_CODEGEN_COMMON_GPU_PASSES
#define IREE_CODEGEN_COMMON_GPU_PASSES

include "mlir/Pass/PassBase.td"

//===---------------------------------------------------------------------===//
// Common Passes used for GPU-like backends (keep alphabetical)
//===---------------------------------------------------------------------===//

def GPUCheckResourceUsage :
    Pass<"iree-codegen-gpu-check-resource-usage", "ModuleOp"> {
  let summary = "Checks GPU specific resource usage constraints like shared memory limits";
  let constructor = "mlir::iree_compiler::createGPUCheckResourceUsagePass()";
}

def GPUDistribute :
    Pass<"iree-codegen-gpu-distribute", "func::FuncOp"> {
  let summary = "Pass to distribute scf.forall ops.";
  let constructor = "mlir::iree_compiler::createGPUDistribute()";
}

def GPUDistributeSharedMemoryCopy :
    Pass<"iree-codegen-gpu-distribute-shared-memory-copy", "func::FuncOp"> {
  let summary = "Pass to distribute shared memory copies to threads.";
  let constructor = "mlir::iree_compiler::createGPUDistributeSharedMemoryCopy()";
}

def GPUMultiBuffering :
    Pass<"iree-codegen-gpu-multi-buffering", "func::FuncOp"> {
  let summary = "Pass to do multi buffering.";
  let constructor = "mlir::iree_compiler::createGPUMultiBuffering()";
}

def GPUPipelining : Pass<"iree-codegen-gpu-pipelining", "func::FuncOp"> {
  let summary = "Pass to do software pipelining.";
  let constructor = "mlir::iree_compiler::createGPUPipeliningPass()";
  let options = [
    Option<"epiloguePeeling", "epilogue-peeling", "bool",
            /*default=*/"true",
           "Try to use un-peeling epilogue when false, peeled epilouge o.w.">,
    Option<"depth", "pipeline-depth", "int64_t",
            /*default=*/"2",
           "Number of stages ">,
    Option<"scheduleIndex", "schedule-index", "int64_t",
            /*default=*/"0",
           "Allows picking different schedule for the pipelining transformation.">,
    Option<"transformFileName", "transform-file-name", "std::string",
            /*default=*/"\"\"",
            "Optional filename containing a transform dialect specification to "
            "apply. If left empty, the IR is assumed to contain one top-level "
            "transform dialect operation somewhere in the module.">,
  ];
}

def GPUReduceBankConflicts :
    Pass<"iree-codegen-gpu-reduce-bank-conflicts", "func::FuncOp"> {
  let summary = "Pass to try to reduce the number of bank conflicts.";
  let constructor = "mlir::iree_compiler::createGPUReduceSharedMemoryBankConflicts()";
}

def GPUTensorAlloc :
    Pass<"iree-codegen-gpu-tensor-alloc", "func::FuncOp"> {
  let summary = "Pass to tile reduction dimensions and create allocations for "
                "some tensor values to use GPU shared memory";
  let constructor = "mlir::iree_compiler::createGPUTensorAlloc()";
}

def GPUTensorTile :
    Pass<"iree-codegen-gpu-tensor-tile", "func::FuncOp"> {
  let summary = "Pass to tile tensor (linalg) ops within a GPU workgroup";
  let constructor = "mlir::iree_compiler::createGPUTensorTile()";
}

def GPUTileReduction :
    Pass<"iree-codegen-gpu-tile-reduction", "func::FuncOp"> {
  let summary = "Pass to tile linalg reduction dimensions.";
  let constructor = "mlir::iree_compiler::createGPUTileReductionPass()";
}

def GPUVectorization :
    Pass<"iree-codegen-gpu-vectorization", "func::FuncOp"> {
  let summary = "Pass to convert linalg into Vector.";
  let constructor = "mlir::iree_compiler::createGPUVectorizationPass()";
  let options = [
    Option<"generateContract", "generate-contract", "bool",
            /*default=*/"true",
           "Try to convert reduction to vector.contract.">,
    Option<"maxVectorSize", "max-vector-size", "int64_t",
            /*default=*/"4096",
           "Max vector size allowed to avoid creating large vectors.">
  ];
}

def VectorReduceToGPU :
    Pass<"iree-codegen-reduction-to-gpu", "func::FuncOp"> {
  let summary = "Convert vector reduction to gpu ops.";
  let constructor = "mlir::iree_compiler::createConvertVectorReductionToGPUPass()";
}

def WorkgroupSpecialization :
    Pass<"iree-codegen-workgroup-specialization", "func::FuncOp"> {
  let summary = "Specialize workgroup distribution loops";
  let constructor = "mlir::iree_compiler::createWorkgroupSpecializationPass()";
}

def WorkGroupSwizzle :
    Pass<"iree-workgroup-swizzle", "func::FuncOp"> {
  let summary = "swizzle the workgroup ids for better cache reuse";
  let constructor = "mlir::iree_compiler::createWorkGroupSwizzle()";
  let options = [
    Option<"logTile", "logTile", "unsigned",
            /*default=*/"0",
           "pass the tile value for unit testing">,
  ];
}

#endif // IREE_CODEGEN_COMMON_GPU_PASSES
