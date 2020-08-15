Class {
	#name : #MbndSlovimFunctionGCSysmelLoweringPass,
	#superclass : #SLVMFunctionGCLoweringPass,
	#category : #'SysmelMoebiusCodeGenerator-Slovim-CompilationTarget'
}

{ #category : #applying }
MbndSlovimFunctionGCSysmelLoweringPass >> addCall: call debugInformationFor: aFunction [
	aFunction debugSourceLocation ifNotNil: [ :sourceLocation | call debugSourceLocation: sourceLocation ].
	^ call
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
MbndSlovimFunctionGCSysmelLoweringPass >> insertSafepointsAtBackwardBranchesIn: aFunction [
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
