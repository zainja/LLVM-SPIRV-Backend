 //===- SkeletonEmitter.cpp - Skeleton TableGen backend          -*- C++ -*-===//
 //
 // Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 // See https://llvm.org/LICENSE.txt for license information.
 // SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 //
 //===----------------------------------------------------------------------===//
 //
 // This Tablegen backend emits ...
 //
 //===----------------------------------------------------------------------===//

#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/Support/Format.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/TableGen/Error.h"
#include "llvm/TableGen/StringMatcher.h"
#include "llvm/TableGen/Record.h"
#include "llvm/TableGen/TableGenBackend.h"
#include <algorithm>
#include <set>
#include <string>
#include <vector>

#define DEBUG_TYPE "openclbuiltins-emitter"
using namespace llvm;
using namespace std;

namespace {

 // Any helper data structures can be defined here. Some backends use
 // structs to collect information from the records.

  class SPIRVOpenCLBuiltinsEmitter {
  private:
    RecordKeeper &Records;
    vector<StringRef> functionList;
    void getOCLFunctions();
    void emitStringMatcher(raw_ostream &OS);
//    void emitSelectRecords(raw_ostream &OS);
    void emitImports(raw_ostream &OS);

  public:
    SPIRVOpenCLBuiltinsEmitter(RecordKeeper &RK) : Records(RK) {}
    void run(raw_ostream &OS);
  }; // emitter class

} // anonymous namespace


void SPIRVOpenCLBuiltinsEmitter::getOCLFunctions(){
  auto OCLRecords = Records.getAllDerivedDefinitions("OpenCLBuiltinsMap");
  for (auto const &record: OCLRecords){
    StringRef oclFunctionName = record->getValueAsString("opencl_mangled");
    functionList.push_back(oclFunctionName);
  }

}

void SPIRVOpenCLBuiltinsEmitter::emitStringMatcher(raw_ostream &OS){
  vector<StringMatcher::StringPair> validOCLFunctions;
  for(auto &func: functionList){
    validOCLFunctions.push_back(StringMatcher::StringPair(func, "return true;"));

  }

  OS << "bool isOpenCLBuiltin(StringRef name) {\n";

  StringMatcher("name", validOCLFunctions, OS).Emit(0, true);

  OS << "  return false;\n";
  OS << "}\n";



}
void SPIRVOpenCLBuiltinsEmitter::emitImports(raw_ostream &OS){
  OS << "#include \"llvm/ADT/StringRef.h\"\n";
  OS << "using namespace llvm;\n\n";
}

//void SPIRVOpenCLBuiltinsEmitter::emitSelectRecords(raw_ostream &OS){
//
//
//}

void SPIRVOpenCLBuiltinsEmitter::run(raw_ostream &OS) {
  emitSourceFileHeader("OpenCLBuiltins data structures", OS);
  emitImports(OS);
  getOCLFunctions();
  emitStringMatcher(OS);
//  emitSelectRecords(OS);
}

namespace llvm {

// The only thing that should be in the llvm namespace is the
// emitter entry point function.

  void EmitSPIRVOpenCLBuiltins(RecordKeeper &RK, raw_ostream &OS) {
    // Instantiate the emitter class and invoke run().
    SPIRVOpenCLBuiltinsEmitter(RK).run(OS);
  }

} // namespace llvm
