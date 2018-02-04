object building
createLocalVariableBinding: localVariableBuilder
	^self addLocal: (SYMLFunctionLocalVariable new
		name: localVariableBuilder name;
		valueType: localVariableBuilder type;
		function: self;
		yourself)