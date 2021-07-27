//===-- SPIRVOpenCLBuiltins.td - Mapping between OpenCL Builtins and the equivelant SPIRV instructions ----------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

class Type<string _Name> {
  string Name = _Name;
}

class BoolType: Type<"bool">;

class IntType<int _bitwidth> : Type<"int">{
  int bitwidth = _bitwidth;
}
class FloatType<int _bitwidth> : Type<"float"> {
  int bitwidth = _bitwidth;
}
class VectorType<Type _Ty, int _VecWidth> : Type<_Ty.Name> {
  int VecWidth = _VecWidth;
  Type baseTy = _Ty;
}

class ReturnType<Type _Ty=Type<"">, bit _isDefault=0> : Type<"returnType">{
  Type Ty = _Ty;
  bit isDefault = _isDefault;
}

def defaultReturnType: ReturnType<Type<"">, 1>;

class ImmType<int _val> : Type<"">{
 int val = _val;
}


class OCLOperand<int _ArgIdx>: Type<""> {
  int Index = _ArgIdx;
}
class OCLDest<bit _generic=0> : Type<"Destination">{
  bit generic = _generic;
}

def return: OCLDest<0>;

class ImmReg<int _ArgIdx>: Type<"IntermediateValue">{
  int Index = _ArgIdx;
}
class OCLPair<Op _instr, list<Type> _Args>{
  int Opcode = _instr.Inst;
  list<Type> Args = _Args;
}
class OCLBuiltinMapping<string _opencl_name, list<OCLPair> _InstrList> {
	string opencl_name = _opencl_name;
	list<OCLPair> InstrList = _InstrList;
}

def Arg0 : OCLOperand<0>;
def Arg1 : OCLOperand<1>;
def acos : ImmType<17>;
def bool: BoolType;
def boolRet : ReturnType<bool>;
def p1 : OCLPair<OpExtInst, [return, defaultReturnType, acos, Arg0]>;
def p2 : OCLPair<OpFOrdGreaterThanEqual, [return, boolRet, Arg0, Arg1]>;

def : OCLBuiltinMapping<"acos", [p1]>;
def: OCLBuiltinMapping<"fordgreaterthan", [p2]>;

// ---------
def im1 : OCLDest<1>;
def pfor1 : OCLPair<OpFOrdGreaterThanEqual, [im1, boolRet, Arg0, Arg1]>;
def inter1: ImmReg<0>;
def pfor2 : OCLPair<OpUndef, [return, defaultReturnType, inter1, ImmType<1>, ImmType<0>]>;
def: OCLBuiltinMapping<"fordgreaterthanint", [pfor1, pfor2]>;






