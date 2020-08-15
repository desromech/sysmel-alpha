Class {
	#name : #MbndSlovimFunctionGCSysmelShadowStackLoweringPass,
	#superclass : #MbndSlovimFunctionGCSysmelLoweringPass,
	#category : #'SysmelMoebiusCodeGenerator-Slovim-CompilationTarget'
}

{ #category : #'as yet unclassified' }
MbndSlovimFunctionGCSysmelShadowStackLoweringPass class >> gcName [
	^ #sysmelShadowStack
]

{ #category : #applying }
MbndSlovimFunctionGCSysmelShadowStackLoweringPass >> convertAllocasInGCRootList: aFunction [
	| entryBlock gcRootVariables valueType shadowStackRecordStructure shadowStackEnterFunction shadowStackLeaveFunction shadowStackLandingPadFunction rootCountFieldIndex rootsFieldIndex rootValueType rootArrayType rootsStorage shadowStackRecordStorage shadowStackRecordStorageInitialValue initialBlockInstructions rootsStoragePointer |
	entryBlock := aFunction basicBlocks first.
	gcRootVariables := OrderedCollection new.

	shadowStackRecordStructure := aFunction compilationTarget objectModel gcShadowStackRecordStructure.
	rootCountFieldIndex := aFunction compilationTarget objectModel gcShadowStackRootCountField.
	rootsFieldIndex := aFunction compilationTarget objectModel gcShadowStackRootsField.

	shadowStackEnterFunction := aFunction compilationTarget objectModel gcShadowStackEnterFunction.
	shadowStackLeaveFunction := aFunction compilationTarget objectModel gcShadowStackLeaveFunction.
	shadowStackLandingPadFunction := aFunction compilationTarget objectModel gcShadowStackLandingPadFunction.

	entryBlock allocaInstructionsDo: [ :allocaInstruction |
		valueType := allocaInstruction valueType.
		(self isGCPointerType: valueType) ifTrue: [
			gcRootVariables add: allocaInstruction
		]
	].

	gcRootVariables ifEmpty: [ ^ self ].
	
	rootValueType := (shadowStackRecordStructure types at: rootsFieldIndex + 1) baseType.
	rootArrayType := SLVMArrayType baseType: rootValueType elements: gcRootVariables size.
	rootsStorage := SLVMAlloca pointerSize: rootValueType size valueType: rootArrayType.
	shadowStackRecordStorage := SLVMAlloca pointerSize: rootValueType size valueType: shadowStackRecordStructure.
	entryBlock
		addFirst: shadowStackRecordStorage;
		addFirst: rootsStorage.

	shadowStackRecordStorageInitialValue := shadowStackRecordStructure defaultFullConstant.
	shadowStackRecordStorageInitialValue slots at: rootCountFieldIndex + 1 put: (SLVMConstant type: (shadowStackRecordStructure types at: rootCountFieldIndex + 1) value: gcRootVariables size).
	
	initialBlockInstructions := OrderedCollection new.
	initialBlockInstructions addAll: {
		SLVMStoreInstruction value: rootArrayType defaultConstant variable: rootsStorage.
		rootsStoragePointer := SLVMBitCast source: rootsStorage targetType: (shadowStackRecordStructure types at: rootsFieldIndex + 1).
		shadowStackRecordStorageInitialValue := SLVMInsertValue aggregate: shadowStackRecordStorageInitialValue value: rootsStoragePointer indices: {rootsFieldIndex}.
		SLVMStoreInstruction value: shadowStackRecordStorageInitialValue variable: shadowStackRecordStorage.
		self addCall: (SLVMCall function: shadowStackEnterFunction arguments: { shadowStackRecordStorage }) debugInformationFor: aFunction
	}.
	
	
	gcRootVariables doWithIndex: [ :gcRoot :index |
		| gep replacement |
		gep := SLVMGetElementPointer pointer: rootsStorage indices: {SLVMConstant int: 0 . SLVMConstant int: index - 1}.
		initialBlockInstructions add: gep.
		replacement := (gep type = gcRoot type)
			ifTrue: [ gep]
			ifFalse: [
			| bitcast |
			bitcast := SLVMBitCast source: gep targetType: gcRoot type.
			initialBlockInstructions add: bitcast.
			bitcast
		].
		gcRoot replaceWith: replacement.
	].
	
	entryBlock addInstructionsAfterAllocas: initialBlockInstructions.
	aFunction allInstructionsDo: [ :each |
		(each isReturn or: [ each isReturnVoid ]) ifTrue: [
			each block add: (self addCall: (SLVMCall function: shadowStackLeaveFunction arguments: { shadowStackRecordStorage }) debugInformationFor: aFunction)
			before: each
		].
	
		each isLandingPath ifTrue: [
			each block add: (self addCall: (SLVMCall function: shadowStackLandingPadFunction arguments: { shadowStackRecordStorage }) debugInformationFor: aFunction)
				after: each
		].
	].

]

{ #category : #applying }
MbndSlovimFunctionGCSysmelShadowStackLoweringPass >> passOnFunction: aFunction [
	aFunction isEmpty ifTrue: [ ^ self ].
	
	aFunction compilationTarget objectModel gcShadowStackEnterFunction ifNil: [^ nil].

	self
		createIntermediateLocals: aFunction;
		convertAllocasInGCRootList: aFunction;
		insertSafepointsAtBackwardBranchesIn: aFunction;
		yourself
]
