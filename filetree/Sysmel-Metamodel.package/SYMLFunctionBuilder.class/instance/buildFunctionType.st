private
buildFunctionType
	| argumentTypes |
	returnType ifNil: [
		self error: 'Cannot build a function without a return type. You can use Void.'
	].
	argumentTypes := arguments collect: #second.
	
	functionType := self compilationTarget functionArguments: argumentTypes returnType: returnType callingConvention: callingConvention variadic: self isCVariadic.
