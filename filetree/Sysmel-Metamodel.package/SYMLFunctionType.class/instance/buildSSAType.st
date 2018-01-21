as yet unclassified
buildSSAType
	| argumentTypes returnSSAType |
	argumentTypes := arguments collect: #ssaType.
	returnSSAType := returnType ssaType.
	^ (SLVMFunctionType callingConvention: callingConvention arguments: argumentTypes returnType: returnSSAType)
		variadic: variadic;
		yourself