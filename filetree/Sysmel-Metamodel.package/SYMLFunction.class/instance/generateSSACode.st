semantic analysis
generateSSACode
	| allocaBuilder builder returnType bodyBlock |
	definition ifNil: [
		name ifNotNil: [
			self ssaValue makeExternal
		].
		^ self
	].
	
	"Set the arguments"
	arguments doWithIndex: [ :arg :index |
		arg ssaValue: (self ssaValue arguments at: index)
	].

	"Create a builder for the allocas and another for the function body."
	allocaBuilder := SLVMBuilder on: self ssaValue.
	allocaBuilder newBasicBlockHere: #entry.
	
	builder := SLVMBuilder on: self ssaValue.
	builder allocaBuilder: allocaBuilder.
	bodyBlock := builder newBasicBlockHere: #body.
	
	"Generate the function body"
	definition generateSSACodeWith: builder.
	
	"Make sure we are returning something at the end."
	builder isLastTerminator ifFalse: [ 
		returnType := functionType returnType.
		returnType isVoidType ifFalse: [ 
			self error: 'Not all of the execution paths are returning something.' at: definition
		].
		builder returnVoid
	].
	
	allocaBuilder jump: bodyBlock.
