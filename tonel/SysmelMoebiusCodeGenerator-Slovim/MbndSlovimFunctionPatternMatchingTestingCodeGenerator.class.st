Class {
	#name : #MbndSlovimFunctionPatternMatchingTestingCodeGenerator,
	#superclass : #MbndAstVisitor,
	#traits : 'TMbndSlovimModulePartTranslator',
	#classTraits : 'TMbndSlovimModulePartTranslator classTrait',
	#instVars : [
		'functionCodeGenerator',
		'matchedValue',
		'nextPatternBlock',
		'lastResult'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #visiting }
MbndSlovimFunctionPatternMatchingTestingCodeGenerator >> andNextPatternResult: nextBlock [
	| builder nextCheckBlock mergeBlock previousBlock nextResult nextResultBlock newResult |
	lastResult isConstantValue ifTrue: [
		lastResult value ifTrue: [
			lastResult := nextBlock value.
		].
		^ self
	].

	builder := functionCodeGenerator slvmBuilder.
	
	nextCheckBlock := builder newBasicBlock: #patternNextCheck.
	mergeBlock := builder newBasicBlock: #patternFailure.
	previousBlock := builder currentBlock.
	builder currentBlock mergeBlock: mergeBlock.
	builder branch: lastResult ifTrue: nextCheckBlock ifFalse: mergeBlock.
	
	builder currentBlock: nextCheckBlock.
	 
	nextResult := nextBlock value.
	builder jump: mergeBlock.

	nextResultBlock := builder currentBlock.
	builder currentBlock: mergeBlock.
	
	newResult := builder phi: SLVMType boolType.
	newResult
		addValue: lastResult from: previousBlock;
		addValue: nextResult from: nextResultBlock.
	lastResult := newResult
]

{ #category : #visiting }
MbndSlovimFunctionPatternMatchingTestingCodeGenerator >> applyNextPattern: nextPattern to: nextMatchedValueBlock [
	self andNextPatternResult: [
		functionCodeGenerator generatePattern: nextPattern matchingWithValue: nextMatchedValueBlock value
	]
]

{ #category : #accessing }
MbndSlovimFunctionPatternMatchingTestingCodeGenerator >> functionCodeGenerator [
	^ functionCodeGenerator
]

{ #category : #accessing }
MbndSlovimFunctionPatternMatchingTestingCodeGenerator >> functionCodeGenerator: anObject [
	functionCodeGenerator := anObject
]

{ #category : #visiting }
MbndSlovimFunctionPatternMatchingTestingCodeGenerator >> generateTestingExpressionOf: node [
	functionCodeGenerator functionVariables at: node matchedValue put: matchedValue.
	^ functionCodeGenerator visitNode: node testingExpression
]

{ #category : #accessing }
MbndSlovimFunctionPatternMatchingTestingCodeGenerator >> matchedValue [
	^ matchedValue
]

{ #category : #accessing }
MbndSlovimFunctionPatternMatchingTestingCodeGenerator >> matchedValue: anObject [
	matchedValue := anObject
]

{ #category : #accessing }
MbndSlovimFunctionPatternMatchingTestingCodeGenerator >> nextPatternBlock [
	^ nextPatternBlock
]

{ #category : #accessing }
MbndSlovimFunctionPatternMatchingTestingCodeGenerator >> nextPatternBlock: anObject [
	nextPatternBlock := anObject
]

{ #category : #visiting }
MbndSlovimFunctionPatternMatchingTestingCodeGenerator >> visitPatternMatchingAnyPatternNode: node [
	^ functionCodeGenerator slvmBuilder constBool: true
]

{ #category : #visiting }
MbndSlovimFunctionPatternMatchingTestingCodeGenerator >> visitPatternMatchingBindingPatternNode: node [
	| result |
	(node valuePattern isNil or: [node valuePattern isDefaultPattern]) ifTrue: [ 
		node valuePattern ifNotNil: [ 
			functionCodeGenerator generatePattern: node valuePattern matchingWithValue: matchedValue.
		].
		
		node binding ifNotNil: [:binding |
			| bindingInitialValue |
			bindingInitialValue := matchedValue.
			(binding valueType isReferenceType or: [ binding valueType isTemporaryReferenceType ]) ifFalse: [ 
				(node requiredType isMemoryReturnedType not and: [ bindingInitialValue type isPointerType ]) ifTrue: [
					bindingInitialValue := functionCodeGenerator slvmBuilder load: bindingInitialValue
				].
			].
			functionCodeGenerator generateLocalVariable: node binding storageCreationNode: nil definitionAt: node withInitialValue: [bindingInitialValue] initialValueKind: node initialValueKind
		].
	
		^ functionCodeGenerator slvmBuilder constBool: true
	].

	result := functionCodeGenerator generatePattern: node valuePattern matchingWithValue: matchedValue.
	self halt.
	
	^ result	
]

{ #category : #visiting }
MbndSlovimFunctionPatternMatchingTestingCodeGenerator >> visitPatternMatchingLiteralValuePatternNode: node [
	^ self generateTestingExpressionOf: node
]

{ #category : #visiting }
MbndSlovimFunctionPatternMatchingTestingCodeGenerator >> visitPatternMatchingNeverPatternNode: node [
	^ functionCodeGenerator slvmBuilder constBool: false
]

{ #category : #visiting }
MbndSlovimFunctionPatternMatchingTestingCodeGenerator >> visitPatternMatchingSameValuePatternNode: node [
	^ self generateTestingExpressionOf: node
]

{ #category : #visiting }
MbndSlovimFunctionPatternMatchingTestingCodeGenerator >> visitPatternMatchingTuplePatternNode: node [
	| matchedTupleType builder |
	matchedTupleType := node matchedType withoutReferences withoutTopDecorations.
	self assert: matchedTupleType isTupleType.

	builder := functionCodeGenerator slvmBuilder.	
	lastResult := builder constBool: true.
	(1 to: matchedTupleType elements size) do: [ :index |
		self applyNextPattern: (node expectedElements at: index)
			to: [matchedValue type isPointerType
				ifTrue: [builder getReference: matchedValue element: (builder constInt: index - 1)]
				ifFalse: [builder extractValue: matchedValue indices: {index - 1}]
			]
	].
	^ lastResult
]

{ #category : #visiting }
MbndSlovimFunctionPatternMatchingTestingCodeGenerator >> visitPatternMatchingVariantTypeSelectionPatternNode: node [
	| builder typeSelectorValue expectedTypeSelector hasExpectedTypeSelector matchedTypeBlock variantPointer matchedTypePointer matchedTypeValuePatternResult  |
	builder := functionCodeGenerator slvmBuilder.	
	typeSelectorValue := matchedValue type isPointerType ifTrue: [
		builder load: (builder getReference: matchedValue element: (builder constInt: 0) )
	] ifFalse: [
		self assert:  matchedValue type isStructureType.
		builder extractValue: matchedValue indices: #(0)
	].
	expectedTypeSelector := SLVMConstant type: typeSelectorValue type value: node variantTypeSelector.
	hasExpectedTypeSelector := builder ieq: typeSelectorValue with: expectedTypeSelector.
	node valuePattern ifNil: [ ^ hasExpectedTypeSelector ].
	
	"Enter the if block."
	matchedTypeBlock := builder newBasicBlock: #matchedVariantType.
	self assert: nextPatternBlock isNotNil.

	builder branch: hasExpectedTypeSelector ifTrue: matchedTypeBlock ifFalse: nextPatternBlock.
	
	builder currentBlock: matchedTypeBlock.
	
	"Extract the matched value."
	variantPointer := matchedValue.
	matchedValue type isPointerType ifFalse: [ 
		variantPointer := builder allocaBuilder alloca: matchedValue type.
		builder store: matchedValue in: variantPointer
	].

	matchedTypePointer := builder getPointer: variantPointer element: { builder constInt: 0 . builder constInt: 1. builder constInt: node variantTypeSelector }.
	matchedTypeValuePatternResult := functionCodeGenerator generatePattern: node valuePattern matchingWithValue: matchedTypePointer.

	self assert: builder isLastTerminator not.

	^ matchedTypeValuePatternResult
]
