object building
createLocalVariableBinding: localVariableBuilder
	^self addLocal: (SYMLFunctionLocalVariable new
		name: name;
		valueType: localVariableBuilder type;
		function: self;
		yourself)