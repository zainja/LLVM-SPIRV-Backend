class OpenCLBuiltinsMap <string _opencl_mangled, int  _opcode_target> {
	string opencl_mangled = _opencl_mangled;
	int opcode_target = _opcode_target;
}

def : OpenCLBuiltinsMap<"_Z28__spirv_FOrdGreaterThanEqualff", 190>;