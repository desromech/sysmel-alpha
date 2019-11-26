Class {
	#name : #MbndSlovimFunctionGCSysmelLoweringPass,
	#superclass : #SLVMFunctionGCLoweringPass,
	#category : #'SysmelMoebiusCodeGenerator-Slovim-CompilationTarget'
}

{ #category : #'as yet unclassified' }
MbndSlovimFunctionGCSysmelLoweringPass class >> gcName [
	^ #sysmel
]

{ #category : #applying }
MbndSlovimFunctionGCSysmelLoweringPass >> createIntermediateLocals: aFunction [
	| allocaInsertionPoint entryBlock pointerSize alloca store load |
	entryBlock := aFunction basicBlocks first.
	allocaInsertionPoint := entryBlock instructionAfterAllocas.
	pointerSize := aFunction compilationTarget pointerSize. 
	
	aFunction allInstructionsDo: [ :ins |
		(self isGCPointerValue: ins) ifTrue: [
			(self isImplicitRootInstruction: ins) ifTrue: [
				alloca := SLVMAlloca pointerSize: pointerSize valueType: ins type.
				entryBlock add: alloca before: allocaInsertionPoint.
				
				"Load the intermediate result."
				load := SLVMLoadInstruction variable: alloca.
				ins block add: load after: ins.

				"Replace the instruction references with the load"
				ins replaceReferencesWith: load.

				"Store the intermediate result."
				store := SLVMStoreInstruction value: ins variable: alloca.
				ins block add: store after: ins.
			].
		].
	]
]

{ #category : #applying }
MbndSlovimFunctionGCSysmelLoweringPass >> isGCPointerType: valueType [
	^ valueType isDynamicObjectPointerType
]

{ #category : #applying }
MbndSlovimFunctionGCSysmelLoweringPass >> isGCPointerValue: value [
	^ self isGCPointerType: value type
]

{ #category : #applying }
MbndSlovimFunctionGCSysmelLoweringPass >> isImplicitRootInstruction: instruction [
	| usageSite |
	instruction isGetElementPointer ifTrue: [ ^ false ].
	"Some immediate usage make unnecesary to add an intermediate root variable."
	instruction instructionReferences size = 1 ifTrue: [ 
		usageSite := instruction instructionReferences first.
		instruction nextNonDebugInstruction == usageSite ifTrue: [
			usageSite isStore ifTrue: [ ^ false ]
		] 
	].

	instruction isLoad ifTrue: [
		(instruction variable isInstruction and: [ instruction variable isAlloca ]) ifTrue: [ ^ false ].
		self flag: 'FIXME: Maybe this is overkill?'.
		^ true
	].

	^ true
]

{ #category : #applying }
MbndSlovimFunctionGCSysmelLoweringPass >> markAllocaAsRootsIn: aFunction [
	| entryBlock gcRootInsertionPoint valueType gcRootIntrinsic requiredType rootValue nullMetadata gcrootVariables |
	entryBlock := aFunction basicBlocks first.
	gcRootInsertionPoint := entryBlock instructionAfterAllocas.
	gcRootIntrinsic := aFunction compilationTarget objectModel gcrootIntrinsic.
	requiredType := gcRootIntrinsic functionType arguments first.
	nullMetadata := SLVMConstant type: gcRootIntrinsic functionType arguments second value: 0.
	gcrootVariables := OrderedCollection new.

	"Mark the GC root variables."	
	entryBlock allocaInstructionsDo: [ :allocaInstruction |
		valueType := allocaInstruction valueType.
		(self isGCPointerType: valueType) ifTrue: [
			rootValue := valueType ~~ requiredType ifTrue: [
				entryBlock add: (SLVMBitCast source: allocaInstruction targetType: requiredType) before: gcRootInsertionPoint
			] ifFalse: [
				allocaInstruction
			].
		
			entryBlock add: (SLVMCall function: gcRootIntrinsic arguments: {rootValue . nullMetadata}) before: gcRootInsertionPoint.
			
			gcrootVariables add: allocaInstruction.
		]
	].

	"Initialize the GC roots to null."
	gcrootVariables do: [ :gcroot |
		entryBlock add: (SLVMStoreInstruction value: (SLVMConstant type: gcroot valueType value: 0) variable: gcroot) before: gcRootInsertionPoint
	].
	
]

{ #category : #applying }
MbndSlovimFunctionGCSysmelLoweringPass >> passOnFunction: aFunction [
	aFunction isEmpty ifTrue: [ ^ self ].
	
	"Abort if the plugin is not present."
	aFunction compilationTarget compilationPlugins ifEmpty: [ ^ self ].
	
	"Tell llvm to use this gc stragegy"
	aFunction propertyAt: #llvmGCStrategy put: #sysmel.
	
	self
		createIntermediateLocals: aFunction;
		markAllocaAsRootsIn: aFunction;
		yourself
		
	
]
