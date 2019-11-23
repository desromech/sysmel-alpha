Class {
	#name : #MbndPrimitiveVectorType,
	#superclass : #MbndPrimitiveType,
	#instVars : [
		'elementType',
		'elements'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndPrimitiveVectorType class >> typeName [
	^ #_PrimitiveVectorType
]

{ #category : #visiting }
MbndPrimitiveVectorType >> accept: visitor [
	^ visitor visitPrimitiveVectorType: self
]

{ #category : #initialization }
MbndPrimitiveVectorType >> addArithmeticIntrinsics [
	elementType isPrimitiveNumberType ifTrue: [ 
		self
			addBuiltIn: #length intrinsicNamed: #'vector.length' argumentTypes: #() returnType: elementType evaluatedWith: [:receiver :arguments :evaluator :node |
				self halt.
			];
			addBuiltIn: #length2 intrinsicNamed: #'vector.length2' argumentTypes: #() returnType: elementType evaluatedWith: [:receiver :arguments :evaluator :node |
				self halt.
			];
			addBuiltIn: #normalized: intrinsicNamed: #'vector.normalize' argumentTypes: #() returnType: self evaluatedWith: [:receiver :arguments :evaluator :node |
				self halt.
			];
			addBuiltIn: #dot: intrinsicNamed: #'vector.dot' argumentTypes: {self} returnType: elementType evaluatedWith: [:receiver :arguments :evaluator :node |
				self halt.
		].
	
		elements = 2 ifTrue: [ 
			self
				addBuiltIn: #cross: intrinsicNamed: #'vector.cross.2d' argumentTypes: {self} returnType: elementType evaluatedWith: [:receiver :arguments :evaluator :node |
					self halt.
				].
		].
		elements = 3 ifTrue: [ 
			self
				addBuiltIn: #cross: intrinsicNamed: #'vector.cross' argumentTypes: {self} returnType: self evaluatedWith: [:receiver :arguments :evaluator :node |
				self halt.
				].
			
			elementType isPrimitiveFloatType ifTrue: [
				self
					addBuiltIn: #reflectOn: intrinsicNamed: #'vector.reflect' argumentTypes: {self} returnType: self evaluatedWith: [:receiver :arguments :evaluator :node |
					self halt.
					];
					addBuiltIn: #refractOn:with: intrinsicNamed: #'vector.refract' argumentTypes: {self . elementType} returnType: self evaluatedWith: [:receiver :arguments :evaluator :node |
					self halt.
				].
			].
		].

	].
	elementType addArithmeticIntrinsicsToVectorOrScalarType: self
	
]

{ #category : #adding }
MbndPrimitiveVectorType >> addDefaultConversionRules [
	super addDefaultConversionRules.
	elementType ifNotNil: [ 
		elementType
			addConversionTo: self rule: MbndExpandScalarToVectorConversionRule.
	]
]

{ #category : #initialization }
MbndPrimitiveVectorType >> addInstanceMacros [
	self class == MbndPrimitiveVectorType ifFalse: [ ^ self ].
	self isTrait ifFalse: [ ^ self ].
	#(
	x y z w
	r g b a
	) doWithIndex: [ :fieldName :fieldIndex |
		self addVectorElementField: (fieldIndex - 1) % 4 withName: fieldName
	].

	self type
		onMacroSelector: #applyWithArguments: do: [ :node :builder :analyzer |
			self assert: node receiver value isPrimitiveVectorType.
			analyzer visitNode: (builder constructVector: node receiver value withElements: node arguments first)
		];
		onMacroSelectors: #(
			x: x:y: x:y:z: x:y:z:w:
			r: r:g: r:g:b: r:g:b:a:
		) do: [ :node :builder :analyzer |
			analyzer visitNode: (
				(builder unexpandedSend: (builder literalSymbol: #applyWithArguments:) to: node receiver withArguments: { 
					(builder tuple: node arguments) position: node
				})
					position: node
			)
		].
]

{ #category : #initialization }
MbndPrimitiveVectorType >> addVectorElementField: vectorElement withName: fieldName [
	| getterName setterName |
	getterName := fieldName.
	setterName := (fieldName , ':') asSymbol.
	
	self onMacroSelector: getterName do: [ :node :builder |
		(builder vector: node receiver getElement: vectorElement)
			position: node
	].
	self onMacroSelector: setterName do: [ :node :builder |
		(builder vector: node receiver setElement: vectorElement value: node arguments first)
			position: node
	]
]

{ #category : #'as yet unclassified' }
MbndPrimitiveVectorType >> alignmentMultiplier [
	^ elements asLargerPowerOfTwo
]

{ #category : #'semantic analysis' }
MbndPrimitiveVectorType >> analyzeSwizzleMessageSendNode: node with: analyzer [
	| selector fieldPortion elementIndices |
	selector := node selector value.
	self assert: selector isByteString.
	fieldPortion := selector last = $: ifTrue: [selector allButLast] ifFalse: [selector].
	elementIndices := fieldPortion collect: [ :char |
		(('xyzwrgba' indexOf: char) - 1) % 4
	] as: Array.

	^ analyzer visitNode: ((analyzer astBuilder vector: node receiver getElements: elementIndices)
		position: node)
]

{ #category : #'semantic analysis' }
MbndPrimitiveVectorType >> analyzeUnboundUnexpandedMessageSendNode: node with: analyzer [
	| selector |
	node selector isLiteralSymbolValueNode ifTrue: [
		selector := node selector value.
		(self isSwizzleSelector: selector) ifTrue: [
			^ self analyzeSwizzleMessageSendNode: node with: analyzer
		].
	].

	^ super analyzeUnboundUnexpandedMessageSendNode: node with: analyzer
]

{ #category : #'default values' }
MbndPrimitiveVectorType >> defaultValueAt: aPosition [
	| defaultElementValue |
	defaultElementValue := elementType defaultValueAt: aPosition.
	^ MbndAggregateTypeInstanceValue new
		type: self;
		slots: ((1 to: elements) collect: [:i | defaultElementValue]);
		yourself
]

{ #category : #accessing }
MbndPrimitiveVectorType >> elementType [
	^ elementType
]

{ #category : #accessing }
MbndPrimitiveVectorType >> elementType: anObject [
	elementType := anObject
]

{ #category : #accessing }
MbndPrimitiveVectorType >> elements [
	^ elements
]

{ #category : #accessing }
MbndPrimitiveVectorType >> elements: anObject [
	elements := anObject
]

{ #category : #sizes }
MbndPrimitiveVectorType >> instanceAlignment [
	^ instanceAlignment ifNil: [ instanceAlignment := elementType instanceAlignment * self alignmentMultiplier ]
]

{ #category : #sizes }
MbndPrimitiveVectorType >> instanceSize [
	^ instanceSize ifNil: [ instanceSize := elementType instanceSize * elements ]
]

{ #category : #'testing methods' }
MbndPrimitiveVectorType >> isPrimitiveVectorType [
	^ true
]

{ #category : #'semantic analysis' }
MbndPrimitiveVectorType >> isSwizzleSelector: selector [
	| fieldPortion |
	selector isByteString ifFalse: [ ^ false ].
	fieldPortion := selector last = $: ifTrue: [selector allButLast] ifFalse: [selector].
	fieldPortion do: [ :char |
		('xyzwrgba' includes: char) ifFalse: [ ^ false ]
	].
	^ true
]
