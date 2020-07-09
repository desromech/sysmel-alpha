Class {
	#name : #MbndTypeConcept,
	#superclass : #MbndBasicType,
	#traits : 'TMbndMetaType',
	#classTraits : 'TMbndMetaType classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndTypeConcept class >> typeName [
	^ #_TypeConcept
]

{ #category : #'logical operations' }
MbndTypeConcept >> & otherType [
	<compileTime>
	^ self compilationTarget simultanousTypeConcepts: { self . otherType }
]

{ #category : #initialization }
MbndTypeConcept >> addInstanceMacros [
	self class == MbndTypeConcept ifFalse: [ ^ self ].
	self isTrait ifFalse: [ ^ self ].
	
	self
		onMacroSelector: #asLiteralValueNode do: [ :node :builder |
			builder explicitCast: node receiver to: builder compilationTarget astNodeType
		]. 
	self type
		onMacroSelector: #ifType:complies:else: do: [ :node :builder :analyzer |
			| concept testedType |
			concept := analyzer evaluateTypeExpression: node receiver.
			testedType := analyzer evaluateTypeExpression: node arguments first.
			(concept doesTypeComplyWithConcept: testedType) ifTrue: [
				analyzer analyzeNodeIfNeeded: node arguments second
			] ifFalse: [ 
				analyzer analyzeNodeIfNeeded: node arguments third
			]
		];
		onMacroSelector: #ifType:complies: do: [ :node :builder |
			builder unexpandedSend: ((builder literalSymbol: #ifType:complies:else:) position: node) to: node receiver withArguments: { node arguments first . node arguments second. builder literalVoid }
		]
	
]

{ #category : #'as yet unclassified' }
MbndTypeConcept >> doesCoercionTypeComplyWithConcept: aCoercionType [
	aCoercionType isStrictMetaType ifFalse: [ ^ false ].
	^ self doesTypeComplyWithConcept: aCoercionType instanceType
]

{ #category : #'as yet unclassified' }
MbndTypeConcept >> doesTypeComplyWithConcept: aType [
	self subclassResponsibility
]

{ #category : #accessing }
MbndTypeConcept >> instanceType [
	self error: 'Cannot obtain an instance type from a concept.'
]

{ #category : #testing }
MbndTypeConcept >> isTypeConcept [
	^ true
]
