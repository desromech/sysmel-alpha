Class {
	#name : #MbndSlovimFunctionPatternMatchingTestingCodeGenerator,
	#superclass : #MbndAstVisitor,
	#traits : 'TMbndSlovimModulePartTranslator',
	#classTraits : 'TMbndSlovimModulePartTranslator classTrait',
	#instVars : [
		'functionCodeGenerator',
		'matchedValue'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #visiting }
MbndSlovimFunctionPatternMatchingTestingCodeGenerator >> applyNextPattern: nextPattern to: nextMatchedValue [
	| nextPatternResult |
	nextPatternResult := functionCodeGenerator generatePattern: nextPattern matchingWithValue: nextMatchedValue.
	nextPattern isDefaultPattern ifTrue: [ ^ self ].
	self halt
]

{ #category : #'as yet unclassified' }
MbndSlovimFunctionPatternMatchingTestingCodeGenerator >> buildAndingTowerWith: aBlock [
	aBlock value.
	
	^ functionCodeGenerator slvmBuilder constBool: true
]

{ #category : #visiting }
MbndSlovimFunctionPatternMatchingTestingCodeGenerator >> finishPatternAndingTower [
]

{ #category : #accessing }
MbndSlovimFunctionPatternMatchingTestingCodeGenerator >> functionCodeGenerator [
	^ functionCodeGenerator
]

{ #category : #accessing }
MbndSlovimFunctionPatternMatchingTestingCodeGenerator >> functionCodeGenerator: anObject [
	functionCodeGenerator := anObject
]

{ #category : #accessing }
MbndSlovimFunctionPatternMatchingTestingCodeGenerator >> matchedValue [
	^ matchedValue
]

{ #category : #accessing }
MbndSlovimFunctionPatternMatchingTestingCodeGenerator >> matchedValue: anObject [
	matchedValue := anObject
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
			functionCodeGenerator generateLocalVariable: node binding storageCreationNode: nil definitionAt: node withInitialValue: [matchedValue] initialValueKind: #copy
		].
	
		^ functionCodeGenerator slvmBuilder constBool: true
	].

	result := functionCodeGenerator generatePattern: node valuePattern matchingWithValue: matchedValue.
	self halt.
	
	^ result	
]

{ #category : #visiting }
MbndSlovimFunctionPatternMatchingTestingCodeGenerator >> visitPatternMatchingLiteralValuePatternNode: node [
	self flag: 'TODO: Generate this method properly'.
	^ functionCodeGenerator slvmBuilder constBool: true 
]

{ #category : #visiting }
MbndSlovimFunctionPatternMatchingTestingCodeGenerator >> visitPatternMatchingNeverPatternNode: node [
	^ functionCodeGenerator slvmBuilder constBool: false
]

{ #category : #visiting }
MbndSlovimFunctionPatternMatchingTestingCodeGenerator >> visitPatternMatchingSameValuePatternNode: node [
	self flag: 'TODO: Generate this method properly'.
	^ functionCodeGenerator slvmBuilder constBool: true 
]

{ #category : #visiting }
MbndSlovimFunctionPatternMatchingTestingCodeGenerator >> visitPatternMatchingTuplePatternNode: node [
	| matchedTupleType builder |
	matchedTupleType := node matchedType withoutReferences withoutTopDecorations.
	self assert: matchedTupleType isTupleType.

	builder := functionCodeGenerator slvmBuilder.	
	^ self buildAndingTowerWith: [(1 to: matchedTupleType elements size) do: [ :index |
		self applyNextPattern: (node expectedElements at: index)
			to: (matchedValue type isPointerType
				ifTrue: [builder getReference: matchedValue element: (builder constInt: index - 1)]
				ifFalse: [builder extractValue: matchedValue indices: {index - 1}]
			)
	] ].

]
