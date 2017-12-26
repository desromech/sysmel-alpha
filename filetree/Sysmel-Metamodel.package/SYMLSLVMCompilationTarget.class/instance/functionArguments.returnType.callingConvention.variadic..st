accessing
functionArguments: argumentTypes returnType: returnType callingConvention: callingConvention variadic: variadic
	| functionType |
	functionType := SYMLFunctionType new
		target: self;
		arguments: argumentTypes;
		returnType: returnType;
		callingConvention: callingConvention;
		variadic: variadic;
		yourself.
	^ functionTypes at: functionType ifAbsentPut: [ functionType ]