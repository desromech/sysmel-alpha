Class {
	#name : #MbndVariantUnionType,
	#superclass : #MbndAggregateType,
	#instVars : [
		'components',
		'instanceSize',
		'instanceAlignment'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndVariantUnionType class >> typeName [
	^ #_VariantUnion
]

{ #category : #visiting }
MbndVariantUnionType >> accept: visitor [
	^ visitor visitVariantUnionType: self
]

{ #category : #initialization }
MbndVariantUnionType >> addInstanceMacros [
	self class == MbndVariantUnionType ifFalse: [ ^ self ].
	self isTrait ifFalse: [ ^ self ].
	self
		onMacroSelector: #typeSelector do: [ :node :builder |
			(builder extractVariantTypeSelector: node receiver)
				position: node ];
		onMacroSelector: #get: do: [ :node :builder |
			(builder variant: node receiver getFieldOfType: node arguments first)
				position: node
		]; 
		yourself
]

{ #category : #'as yet unclassified' }
MbndVariantUnionType >> analyzeReferenceAssignmentNode: node with: analyzer [
	| cleanValueType bestSuitableValueTypes targetType typeSelector newReference newAssignment |
	cleanValueType := node value type withoutReferences withoutTopDecorations.
	cleanValueType isVariantUnionType ifTrue: [ ^ super analyzeReferenceAssignmentNode: node with: analyzer ].
	
	bestSuitableValueTypes := self findBestSuitableValueTypesFor: node value with: analyzer.
	bestSuitableValueTypes size ~= 1 ifTrue: [
		bestSuitableValueTypes ifEmpty: [ 
			^ self error: 'Cannot assign a value of type {1} into a variant of type {2}.' format: { cleanValueType asString . self asString } at: node
		] ifNotEmpty: [
			^ self error: 'Cannot assign a value of type {1} into a variant of type {2}. The best matching types are {3}' format: { cleanValueType asString . self asString . bestSuitableValueTypes asArray asString } at: node
		].
	].

	targetType := bestSuitableValueTypes first.
	typeSelector := self getTypeSelectorFor: targetType.
	self assert: typeSelector isNotNil.
	
	newReference := MbndAstVariantUnboxingAssignmentReferenceNode new
		position: node;
		variant: node reference;
		typeSelector: typeSelector;
		yourself.
		
	newAssignment := MbndAstAssignmentNode new
		position: node;
		reference: newReference;
		value: node value;
		yourself.
		
	^ analyzer visitNode: newAssignment
]

{ #category : #accessing }
MbndVariantUnionType >> components [
	^ components
]

{ #category : #accessing }
MbndVariantUnionType >> components: anObject [
	components := anObject
]

{ #category : #'default values' }
MbndVariantUnionType >> defaultValueAt: aPosition [
	| content |
	
	content := (components first defaultValueAt: aPosition) unwrapMbndValue.

	^ MbndVariantTypeInstance new
		type: self;
		typeSelector: 0;
		content: content;
		yourself
]

{ #category : #'as yet unclassified' }
MbndVariantUnionType >> findBestSuitableValueTypeFor: sourceType node: node [
	| bestTypes bestCost cost |
	bestTypes := OrderedCollection new.
	bestCost := Float infinity.
	
	components do: [ :each |
		each = sourceType ifTrue: [ ^ {each} ].
		
		cost := (sourceType node: node convertedImplicitlyInto: each) ifNotNil: [:rule | rule conversionCost ].
		
		cost ifNotNil: [ 
			cost < bestCost ifTrue: [ 
				bestTypes removeAll; add: each.
				bestCost := cost
			] ifFalse: [
				cost = bestCost ifTrue: [ 
					bestTypes add: each
				]
			]
		].
	].

	^ bestTypes
]

{ #category : #'as yet unclassified' }
MbndVariantUnionType >> findBestSuitableValueTypesFor: node with: analyzer [
	| bestTypes bestCost cost |
	bestTypes := OrderedCollection new.
	bestCost := Float infinity.
	
	components do: [ :each |
		cost := analyzer computeImplicitCoercionCostFor: node to: each at: node.
		cost ifNotNil: [ 
			cost < bestCost ifTrue: [ 
				bestTypes removeAll; add: each.
				bestCost := cost
			] ifFalse: [
				cost = bestCost ifTrue: [ 
					bestTypes add: each
				]
			]
		].
	].

	^ bestTypes
]

{ #category : #'as yet unclassified' }
MbndVariantUnionType >> getTypeSelectorFor: aType [
	^ (components indexOf: aType ifAbsent: [ ^ nil ]) - 1
]

{ #category : #testing }
MbndVariantUnionType >> hasTrivialInstanceBasicInitialization [
	components ifNil: [ ^ super hasTrivialInstanceBasicInitialization ].
	^ components allSatisfy: [:each | each hasTrivialInstanceBasicInitialization ]
]

{ #category : #testing }
MbndVariantUnionType >> hasTrivialInstanceFinalization [
	components ifNil: [ ^ super hasTrivialInstanceFinalization ].
	^ components allSatisfy: [:each | each hasTrivialInstanceFinalization ]
]

{ #category : #testing }
MbndVariantUnionType >> hasTrivialInstanceInitialization [
	components ifNil: [ ^ super hasTrivialInstanceInitialization ].
	^ components allSatisfy: [:each | each hasTrivialInitialization ]
]

{ #category : #testing }
MbndVariantUnionType >> hasTrivialInstanceInitializationCopyingFrom [
	components ifNil: [ ^ super hasTrivialInstanceInitializationCopyingFrom ].
	^ components allSatisfy: [:each | each hasTrivialInstanceInitializationCopyingFrom ]
]

{ #category : #testing }
MbndVariantUnionType >> hasTrivialInstanceInitializationMovingFrom [
	components ifNil: [ ^ super hasTrivialInstanceInitializationMovingFrom ].
	^ components allSatisfy: [:each | each hasTrivialInstanceInitializationMovingFrom ]
]

{ #category : #accessing }
MbndVariantUnionType >> instanceAlignment [
	<compileTime>
	components ifNil: [ ^ super instanceAlignment ].
	^ instanceAlignment ifNil: [
		instanceAlignment := 1.
		components do: [ :each | instanceAlignment := instanceAlignment max: each instanceAlignment ].
		instanceAlignment
	]
]

{ #category : #accessing }
MbndVariantUnionType >> instanceSize [
	<compileTime>
	components ifNil: [ ^ super instanceSize ].
	^ instanceSize ifNil: [
		instanceSize := (1 alignedTo: self instanceAlignment) + (self maxComponentSize alignedTo: self instanceAlignment).
	]
]

{ #category : #testing }
MbndVariantUnionType >> isCopyable [
	components ifNil: [ ^ super isCopyable ].
	^ components allSatisfy: [:each | each isCopyable ]
]

{ #category : #testing }
MbndVariantUnionType >> isMoveable [
	components ifNil: [ ^ super isMoveable ].
	^ components allSatisfy: [:each | each isMoveable ]
]

{ #category : #'testing methods' }
MbndVariantUnionType >> isTypePassedByReference [
	^ true
]

{ #category : #'testing methods' }
MbndVariantUnionType >> isVariantUnionType [
	^ true
]

{ #category : #accessing }
MbndVariantUnionType >> maxComponentSize [
	| result |
	result := 0.
	components do: [ :each | result := result max: each instanceSize ].
	^ result
]

{ #category : #printing }
MbndVariantUnionType >> printOn: aStream [
	name ifNotNil: [ ^ super printOn: aStream ].
	aStream nextPut: $(.
	components doWithIndex: [ :each :index|
		index > 1 ifTrue: [ aStream nextPutAll: ' | ' ].
		aStream print: each.
	].
	aStream nextPut: $).

]

{ #category : #'as yet unclassified' }
MbndVariantUnionType >> typeWithSelector: typeSelector [
	typeSelector < 0 ifTrue: [ ^ nil ].
	typeSelector >= components size ifTrue: [ ^ nil ].
	^ components at: typeSelector + 1
]

{ #category : #'type composition' }
MbndVariantUnionType >> | otherType [
	<compileTime>
	otherType isVariantUnionType ifTrue: [ 
		^ self compilationTarget variantUnionTypeWithComponents: components , otherType components
	].

	^ self compilationTarget variantUnionTypeWithComponents: components , { otherType }
]
