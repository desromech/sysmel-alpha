Class {
	#name : #MbndSlovimFunctionGCSysmelPluginLoweringPass,
	#superclass : #MbndSlovimFunctionGCSysmelLoweringPass,
	#category : #'SysmelMoebiusCodeGenerator-Slovim-CompilationTarget'
}

{ #category : #'as yet unclassified' }
MbndSlovimFunctionGCSysmelPluginLoweringPass class >> gcName [
	^ #sysmelStackMap
]

{ #category : #applying }
MbndSlovimFunctionGCSysmelPluginLoweringPass >> markAllocaAsRootsIn: aFunction [
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
MbndSlovimFunctionGCSysmelPluginLoweringPass >> passOnFunction: aFunction [
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
