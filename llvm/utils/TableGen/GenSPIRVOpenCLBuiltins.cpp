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

#include "llvm/ADT/MapVector.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/Support/Format.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/TableGen/Error.h"
#include "llvm/TableGen/StringMatcher.h"
#include "llvm/ADT/StringRef.h"
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

typedef struct {
  StringRef functionName;
  MapVector<unsigned, vector<Record *>> instrList;
} OCLFunction;

class SPIRVOpenCLBuiltinsEmitter {
private:
  RecordKeeper &Records;
  vector<OCLFunction> mappingsList;
  void getOCLFunctions();
  void emitStringMatcher(raw_ostream &OS);
  string emitSelectRecord(OCLFunction function);
  void emitImports(raw_ostream &OS);
public:
  SPIRVOpenCLBuiltinsEmitter(RecordKeeper &RK) :
      Records(RK) {
  }
  void run(raw_ostream &OS);
};
// emitter class

}// anonymous namespace

void SPIRVOpenCLBuiltinsEmitter::getOCLFunctions() {
  auto OCLRecords = Records.getAllDerivedDefinitions("OCLBuiltinMapping");
  for (auto const &record : OCLRecords) {
    StringRef oclFunctionName = record->getValueAsString("opencl_name");
    auto instrList = record->getValueAsListOfDefs("InstrList");
    auto operandsMap = MapVector<unsigned, vector<Record *>>();
    for(auto const  &rec: instrList){
      auto SPIRVOpcode = rec->getValueAsInt("Opcode");
      vector<Record *> operands = rec->getValueAsListOfDefs("Args");
      operandsMap.insert({SPIRVOpcode, operands});

    }
    mappingsList.push_back({oclFunctionName, operandsMap});
  }

}

void SPIRVOpenCLBuiltinsEmitter::emitStringMatcher(raw_ostream &OS) {
  vector<StringMatcher::StringPair> validOCLFunctions;
  for (auto &func : mappingsList) {
    validOCLFunctions.push_back(StringMatcher::StringPair(func.functionName, emitSelectRecord(func)));

  }

  OS << "bool generateOpenCLBuiltinMappings(StringRef name, ";
  OS << " MachineIRBuilder &MIRBuilder, Register OrigRet, const SPIRVType *retTy, const SmallVectorImpl<Register> &args," <<
      "SPIRVTypeRegistry *TR) {\n";

  StringMatcher("name", validOCLFunctions, OS).Emit(0, true);

  OS << "  return false;\n";
  OS << "}\n";

}

string createInstrReturnType(Record* returnTypeOperand, unsigned count){

  string returnTypeStr;
  raw_string_ostream SS(returnTypeStr);
  if(returnTypeOperand->getValueAsBit("isDefault"))
    SS << "  M" << count << ".addUse(TR->getSPIRVTypeID(retTy));\n";
  else {
    auto retTy = returnTypeOperand->getValueAsDef("Ty");
    StringRef retTyClass = retTy->getType()->getAsString();
    if(retTyClass == "IntType"){
      auto bitWidth = retTy->getValueAsInt("bitwidth");
      SS << "  auto type = TR->getOrCreateSPIRVIntegerType(" << bitWidth << ", MIRBuilder);\n";
    }else if(retTyClass == "BoolType"){
      SS << "  auto type = TR->getOrCreateSPIRVBoolType(MIRBuilder);\n";
    }else if(retTyClass == "VectorType"){
      auto NumElements = retTy->getValueAsInt("VecWidth");
      auto baseTy = returnTypeOperand->getValueAsDef("baseTy");
      StringRef baseTyClass = baseTy->getType()->getAsString();
      if(baseTyClass == "IntType"){
        auto bitWidth = retTy->getValueAsInt("bitwidth");
        SS << "  auto BaseType = TR->getOrCreateSPIRVIntegerType(" << bitWidth << ", MIRBuilder);\n";
      }else if(baseTyClass == "BoolType"){
        SS << "  auto BaseType = TR->getOrCreateSPIRVBoolType(MIRBuilder);\n";
      }
      SS << "  auto type = TR->getOrCreateSPIRVVectorType(BaseType, " << NumElements <<
          ", MIRBuilder)";
    }
    SS << "  M" << count << ".addUse(TR->getSPIRVTypeID(type));\n";
  }
  return returnTypeStr;

}
string SPIRVOpenCLBuiltinsEmitter::emitSelectRecord(OCLFunction function){
  string caseBody;
  raw_string_ostream SS(caseBody);
  SS << "{\n";
  SS << "  Register* operands ["<< function.instrList.size() <<"];\n";
  int count = 0;
  for(auto instrs: function.instrList){

    SS << "  auto M" << count << " = MIRBuilder.buildInstr(" << instrs.first << ");\n";
//    SS << "M"<< count << ".addUse(TR->getSPIRVTypeID(retTy));\n  ";
    bool isVoid = true;
    for(auto operand : instrs.second){
      StringRef operandType = operand->getType()->getAsString();
      SS << "// Operand "<< operandType <<"\n";

      if (operandType == "OCLDest"){
        isVoid = false;
        if(operand->getValueAsBit("generic")){
          SS << "  const auto MRI = MIRBuilder.getMRI();\n";
          SS << "  auto dest = MRI->createVirtualRegister(&SPIRV::IDRegClass);\n";
          SS << "  TR->assignSPIRVTypeToVReg(TR->getOrCreateSPIRVIntegerType(32, MIRBuilder), dest, MIRBuilder);\n";
          SS << "  MRI->setType(dest, LLT::scalar(32));\n";
          SS << "  M" << count << ".addDef(dest);\n";
        }else
          SS << "  M" << count << ".addDef(OrigRet);\n";
      }
      else if (operandType == "ReturnType"){
        SS << createInstrReturnType(operand, count);
      }
      else if (operandType == "OCLOperand")
        SS << "  M" << count<<".addUse(args[" << operand->getValueAsInt("Index") << "]);\n";
      else if (operandType == "ImmType")
        SS << "  M" << count << ".addImm( " << operand->getValueAsInt("val") << ");\n";
      else if (operandType == "ImmReg"){
        SS << "  M" << count << ".addUse(*operands[" << operand->getValueAsInt("Index") << "]);\n";
      }
    }
    if(!isVoid) SS << "  operands["<< count <<"] = M" << count << ".getInstr()->getOperand(0);\n";
    count ++;
  }
  SS << "  return TR->constrainRegOperands(M" << count - 1 << ");\n";
  SS << "}";

  return caseBody;

}
void SPIRVOpenCLBuiltinsEmitter::emitImports(raw_ostream &OS) {
  OS << "#include \"llvm/ADT/StringRef.h\"" << "\n";
  OS << "#include \"SPIRVTypeRegistry.h\"" << "\n";
  OS << "#include \"llvm/ADT/SmallVector.h\"" << "\n";
  OS << "#include \"SPIRV.h\"" << "\n";
  OS << "#include \"SPIRVEnums.h\"" << "\n";
  OS << "#include \"SPIRVRegisterInfo.h\"" << "\n";
  OS << "#include \"llvm/CodeGen/GlobalISel/MachineIRBuilder.h\"" << "\n";
  OS << "using namespace llvm;\n\n";

}


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
