semantic analysis
createSSAValue
	ssaValue := SLVMFunction module: self module ssaModule name: self mangledName functionType: functionType ssaType.
	ssaValue unmangledName: name.
	
	ssaValue arguments doWithIndex: [ :arg :index |
		arg name: (argumentNames at: index)
	].
