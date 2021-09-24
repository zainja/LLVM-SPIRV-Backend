#Import modules
import json 
from collections import OrderedDict

#Load json file and create .td file
#Change file path if needed
f = open("spirv.core.grammar.json")
input = json.load(f)
output = open('SPIRVInstrInfo.td', 'w')

#Write necessary headers, classes and multiclasses
output.writelines('''//===-- SPIRVInstrInfo.td - Target Description for SPIR-V Target ----------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file describes the SPIR-V instructions in TableGen format.
//
// TODO Auto-generate this from the SPIR-V Machine-readable Grammar:
//  - https://www.khronos.org/registry/spir-v/specs/unified1/MachineReadableGrammar.html
//  - https://github.com/KhronosGroup/SPIRV-Headers/blob/master/include/spirv/unified1/spirv.core.grammar.json
//
//===----------------------------------------------------------------------===//

include "SPIRVInstrFormats.td"
include "SPIRVEnums.td"

class SimpleOp<string name, bits<16> opCode>: Op<opCode, (outs), (ins), name>; \n''') 

#list of dictionaries instruction classes and instructions
instruction_classes = input.get("instruction_printing_class")
instructions = input.get("instructions")
operand_kinds = input.get("operand_kinds")

#initialize in and out DagArgs dictionaries
inDagArgs=OrderedDict()
outDagArgs=OrderedDict()

#put key into dictionary or update existing key
def set_key(dictionary, key, value):
    if key not in dictionary:
        dictionary[key] = value
    elif type(dictionary[key]) == list and value not in dictionary[key]:
        dictionary[key].append(value)
    else:
        dictionary[key] = [dictionary[key], value]

#Dictionary of operand names to TokVarNames 
TokVarNames = {}
for instruction in instructions:
    if "operands" in instruction:
        for operand in instruction.get("operands"):
            if "name" in operand and ("quantifier" in operand) == False:
                TokVarNames[operand.get("name")] = "$" + operand.get("name").replace("'", "").replace(" ", "").replace("~", "").replace(".", "")  
            else: pass
    else: pass

#Get values for operand kind from operand_kinds
enum_values = {}
values = {}
remainder = []
for item in operand_kinds:
    if "kind" in item:
        if "enumerants" in item:
            enum_values[item.get("kind")] = [item.get("kind")+":", "$"+item.get("kind")]
        elif item.get("category") == "Composite":
            pass
        elif item.get("kind") == "IdResultType":
            values["IdResultType"] = ["TYPE:", "$type"]
        elif "Id" in item.get("kind") and item.get("kind") != "IdResult":
            values[item.get("kind")] = "ID:"
        elif item.get("kind") == "IdResult":
            values["IdResult"] = ["ID:", "$res"]
        elif item.get("kind") == "LiteralInteger" or item.get("kind") == "LiteralSpecConstantOpInteger" or item.get("kind") == "LiteralContextDependentNumber":
            values[item.get("kind")] = "i32imm:"
        elif item.get("kind") == "LiteralExtInstInteger":
            values[item.get("kind")] = "ExtInst:"
        elif item.get("kind") == "LiteralString":
            values[item.get("kind")] = "StringImm:"

def remove_placeholder(value):
    for i in value:
        if i.isdigit():
            value = value[1:]
        else:
            break
    
    return value

def what_type(value):
    for i in value:
        if i.isdigit():
            value = value[1:]
        else:
            break
    
    return value

####################### EDIT THIS PART ###############################

#add variable_ops for these values:
variablevalues = ["Decoration:", "StringImm:", "ExecutionMode:", "LoopControl:"]

ID_to_TYPE= ["$FloatValue", "$DecorationGroup", "$SignedValue", "$UnsignedValue"]

#special function for certain combinations of kind and names for DagArg
def special_operand_combinations(instruction, n):
    n = str(n)
    #ANY target
    for value in inDagArgs:
        if what_type(value) == "ID:":
            if type(inDagArgs.get(value)) == list:
                for i in inDagArgs.get(value):
                    if "Type" in i or i in ID_to_TYPE:
                        set_key(inDagArgs, n+"TYPE:", i)
                        inDagArgs.get(value).remove(i)

                    if i == "$Target":
                        inDagArgs.get(value).remove("$Target")
                        set_key(inDagArgs, n+"ANY:", "$Target")

            elif inDagArgs[value] == "$Target":
                inDagArgs.pop(value)
                set_key(inDagArgs, n+"ANY:", "$Target")

            elif "Type" in inDagArgs.get(value) or inDagArgs.get(value)in ID_to_TYPE:
                set_key(inDagArgs, n+"TYPE:", inDagArgs.get(value))
                inDagArgs.pop(value)
        
        if what_type(value) == "i32imm:" and instruction.get("class") == "Constant-Creation":
            inDagArgs["variable_ops"] = "" 
            
    
    #Handle Type declaration instructions
    if "Type" in instruction.get("opname"):
        if "ID:" in outDagArgs:
            outDagArgs.pop('ID:')
            outDagArgs["TYPE:"] = "$type"

    #Add variable_ops to coordinate operands in Image class
    if instruction.get("class") == "Image":
        for value in inDagArgs:
            if what_type(value) == "ID:":
                if type(inDagArgs.get(value)) == list:
                    for i in inDagArgs.get(value):
                        if "$Coordinate" in i:
                            inDagArgs["variable_ops"] = ""
                        else: pass
                else:
                    if "$Coordinate" in inDagArgs.get(value):
                        inDagArgs["variable_ops"] = ""    

#Similar function to special_operand_combination, but ensures additional things are added to back instead
#of messing up the order or operands
def final_DagArg_sort(instruction, n):
    if "String" in instruction.get("opname"):
        if "StringImm:" not in inDagArgs:
            inDagArgs["StringImm:"] = "str"

    #Add $i as Image Operands encodes what operands follow, as per Image Operands.
    if "ImageOperand:" in inDagArgs.keys():
        #Included placeholder 1 to ensure correct operand order (dictionary key ID: value is a list)
        set_key(inDagArgs, str(n)+"ID:", "$i")

    if "variable_ops" in inDagArgs.keys():
        inDagArgs.move_to_end("variable_ops")

######################### END OF EDIT ################################

#Function to create in and out DagArg
#Note name will output None if TokVarNames not updated
def create_DagArgs(instruction):
    operands = instruction.get("operands")
    previous_operant_type = None
    placeholder = 1
    if operands == None:
        pass
    
    else:
        for operand in operands:
            kind = operand.get("kind")
            name = operand.get("name")
            
            if ("quantifier" in operand):
                inDagArgs["variable_ops"] = ""
            
            elif kind in values:
                if kind == "IdResult":
                    outDagArgs[values.get(kind)[0]] = values.get(kind)[1]
                    
                elif kind == "IdResultType":
                    inDagArgs[values.get(kind)[0]] = values.get(kind)[1]
                    previous_operant_type = values.get(kind)[0]

                else:
                    if values.get(kind) != previous_operant_type and values.get(kind) in inDagArgs:
                        set_key(inDagArgs,str(placeholder) + values.get(kind), TokVarNames.get(name))
                        placeholder += 1
                    else: set_key(inDagArgs, values.get(kind), TokVarNames.get(name))
                    previous_operant_type = values.get(kind)
                
                if values.get(kind) in variablevalues:
                    inDagArgs["variable_ops"] = ""

                special_operand_combinations(instruction, placeholder)
                
            elif kind in enum_values:    
                set_key(inDagArgs, enum_values.get(kind)[0], enum_values.get(kind)[1])
                previous_operant_type = enum_values.get(kind)[0]
                if enum_values.get(kind)[0] in variablevalues:
                    inDagArgs["variable_ops"] = ""
            
    final_DagArg_sort(instruction, placeholder)


#Function to create asmstr
def create_asmstr(instruction):
    opname = instruction.get("opname")
    asmstr = '"'
    if len(outDagArgs) == 0:
        asmstr = asmstr+opname
    else:
        asmstr = asmstr + list(outDagArgs.values())[0] + " = " + opname

    for name in inDagArgs.values():
        if type(name) == list:
            for i in name:    
                if i != "":
                    asmstr = asmstr + " " + str(i)
                else: pass
        elif name != "":
            asmstr =  asmstr + " " + str(name)
        else: pass 

    asmstr = asmstr + '"'

    return asmstr



def create_in_out():
    if len(outDagArgs) == 0:
        result = "(outs), (ins"
        
    else:
        result = "(outs " + list(outDagArgs.keys())[0] + list(outDagArgs.values())[0] + "), (ins"

    for value, name in inDagArgs.items():
        
        value = remove_placeholder(value)

        if name == None:
            result = result + " " + str(value) + str(name) +","
        elif type(name) == list:
            for i in list(name):
                result = result + " " + str(value) + str(i) +","
        else:
            result = result + " " + str(value) + str(name) +","

    if result[-1] == ",":
        result = result[:-1] + ")" #remove last comma if present
    else:
        result = result + ")"

    return result

#Basic structure: def <name>: Op<bits<16> Opcode, dag outs, dag ins, string asmstr, list<dag> pattern = []>
#asmstr= "<outs TokVarNames>=<name> <ins TokVarNames>(all)"
#List<dag> pattern = ?????? use classes provided

#Function to write records
def write_tablegen(current_instruction_class, instructions, f):
    for instruction in instructions:
        if instruction.get('class') == current_instruction_class:
            if (("operands" in instruction) == False) and (("capabilities" in instruction)==False):
                f.write("def {}: SimpleOp<\"{}\", {}>;\n".format(instruction.get("opname"), instruction.get("opname"), instruction.get("opcode")))

            else:
                create_DagArgs(instruction)
                record = "def {}: Op<{}, {}, {}>\n".format(instruction.get("opname"), instruction.get("opcode"), create_in_out(), create_asmstr(instruction))
                
                f.write(record)
                #Clear in and out DagArgs dictionary
                inDagArgs.clear()
                outDagArgs.clear()


    f.write("\n") #newline

#Main loop
for instruction_class in instruction_classes:
    #Write headings as comments
    if instruction_class.get('heading') != None:
        output.write('//{} \n'.format(instruction_class.get('heading')))
        write_tablegen(instruction_class.get('tag'), instructions, output)


f.close()
