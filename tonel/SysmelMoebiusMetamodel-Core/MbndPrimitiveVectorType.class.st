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
			addBuiltIn: #normalized intrinsicNamed: #'vector.normalize' argumentTypes: #() returnType: self evaluatedWith: [:receiver :arguments :evaluator :node |
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
	elementType addArithmeticIntrinsicsToVectorOrScalarType: self.
	self addPackingIntrinsics
	
]

{ #category : #adding }
MbndPrimitiveVectorType >> addDefaultConversionRules [
	super addDefaultConversionRules.
	elementType ifNotNil: [ 
		elementType
			addConversionTo: self rule: MbndExpandScalarToVectorConversionRule.
		self addExplicitConversionRule: MbndPrimitiveVectorTypeElementConversionRule new.
	].
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
		onMacroSelector: #zeros do: [ :node :builder |
			self assert: node receiver value isPrimitiveVectorType.
			node receiver value expandZerosVectorConstruction: node with: builder.
		];
		onMacroSelector: #ones do: [ :node :builder |
			self assert: node receiver value isPrimitiveVectorType.
			node receiver value expandOnesVectorConstruction: node with: builder.
		];
		onMacroSelector: #infinity do: [ :node :builder |
			self assert: node receiver value isPrimitiveVectorType.
			node receiver value expandInfinityVectorConstruction: node with: builder.
		];
		onMacroSelector: #negativeInfinity do: [ :node :builder |
			self assert: node receiver value isPrimitiveVectorType.
			node receiver value expandNegativeInfinityVectorConstruction: node with: builder.
		];
		onMacroSelector: #infinityOrMaxValue do: [ :node :builder |
			self assert: node receiver value isPrimitiveVectorType.
			node receiver value expandInfinityOrMaxValueVectorConstruction: node with: builder.
		];
		onMacroSelector: #negativeInfinityOrMinValue do: [ :node :builder |
			self assert: node receiver value isPrimitiveVectorType.
			node receiver value expandNegativeInfinityOrMinValueVectorConstruction: node with: builder.
		];
		onMacroSelector: #applyWithArguments: do: [ :node :builder :analyzer |
			self assert: node receiver value isPrimitiveVectorType.
			analyzer visitNode: ((builder constructVector: node receiver value withElements: node arguments first)
				position: node)
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
MbndPrimitiveVectorType >> addPackingIntrinsics [
	| uint32Type |
	elementType isPrimitiveFloatType ifFalse: [ ^ self ].
	uint32Type := self compilationTarget uint32Type.
	
	(elements = 4) ifTrue: [ 
		self
			addBuiltIn: #packUnorm8x4 intrinsicNamed: #'pack.unorm4x8' argumentTypes: #() returnType: uint32Type evaluatedWith: [:receiver :arguments :evaluator :node |
				self halt.
			];
			addBuiltIn: #packSnorm8x4 intrinsicNamed: #'pack.snorm4x8' argumentTypes: #() returnType: uint32Type evaluatedWith: [:receiver :arguments :evaluator :node |
				self halt.
			].
		elementType instanceSize = 4 ifTrue: [ 
			uint32Type
				addBuiltIn: #unpackUnorm8x4 intrinsicNamed: #'unpack.unorm4x8' argumentTypes: #() returnType: self evaluatedWith: [:receiver :arguments :evaluator :node |
					self halt.
				];
				addBuiltIn: #unpackSnorm8x4 intrinsicNamed: #'unpack.snorm4x8' argumentTypes: #() returnType: self evaluatedWith: [:receiver :arguments :evaluator :node |
					self halt.
				].
		].
	].

	(elements = 2) ifTrue: [ 
		self
			addBuiltIn: #packUnorm16x2 intrinsicNamed: #'pack.unorm2x16' argumentTypes: #() returnType: uint32Type evaluatedWith: [:receiver :arguments :evaluator :node |
				self halt.
			];
			addBuiltIn: #packSnorm16x2 intrinsicNamed: #'pack.snorm2x16' argumentTypes: #() returnType: uint32Type evaluatedWith: [:receiver :arguments :evaluator :node |
				self halt.
			].

		elementType instanceSize = 4 ifTrue: [ 
			uint32Type
				addBuiltIn: #unpackUnorm16x2 intrinsicNamed: #'unpack.unorm2x16' argumentTypes: #() returnType: self evaluatedWith: [:receiver :arguments :evaluator :node |
					self halt.
				];
				addBuiltIn: #unpackSnorm16x2 intrinsicNamed: #'unpack.snorm2x16' argumentTypes: #() returnType: self evaluatedWith: [:receiver :arguments :evaluator :node |
					self halt.
				].
		].
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
	defaultElementValue := (elementType defaultValueAt: aPosition) unwrapMbndValue.
	^ MbndVectorTypeInstanceValue new
		type: self;
		slots: ((1 to: elements) collect: [:i | defaultElementValue]);
		yourself
]

{ #category : #accessing }
MbndPrimitiveVectorType >> elementType [
	<compileTime>
	^ elementType
]

{ #category : #accessing }
MbndPrimitiveVectorType >> elementType: anObject [
	elementType := anObject
]

{ #category : #accessing }
MbndPrimitiveVectorType >> elements [
	<compileTime>
	^ elements
]

{ #category : #accessing }
MbndPrimitiveVectorType >> elements: anObject [
	elements := anObject
]

{ #category : #initialization }
MbndPrimitiveVectorType >> expandAllConstant: constantValue vectorConstruction: node with: builder [
	| constantValueNode |
	constantValueNode := constantValue asLiteralValueNode position: node.
	^ builder constructVector: self withElements: ((1 to: elements) collect: [ :i | constantValueNode ])
]

{ #category : #initialization }
MbndPrimitiveVectorType >> expandInfinityOrMaxValueVectorConstruction: node with: builder [
	^ self expandAllConstant: elementType infinityOrMaxValueConstantValue vectorConstruction: node with: builder
]

{ #category : #initialization }
MbndPrimitiveVectorType >> expandInfinityVectorConstruction: node with: builder [
	^ self expandAllConstant: elementType infinityConstantValue vectorConstruction: node with: builder
]

{ #category : #initialization }
MbndPrimitiveVectorType >> expandNegativeInfinityOrMinValueVectorConstruction: node with: builder [
	^ self expandAllConstant: elementType negativeInfinityOrMinValueConstantValue vectorConstruction: node with: builder
]

{ #category : #initialization }
MbndPrimitiveVectorType >> expandNegativeInfinityVectorConstruction: node with: builder [
	^ self expandAllConstant: elementType negativeInfinityConstantValue vectorConstruction: node with: builder
]

{ #category : #initialization }
MbndPrimitiveVectorType >> expandOnesVectorConstruction: node with: builder [
	^ self expandAllConstant: elementType oneConstantValue vectorConstruction: node with: builder
]

{ #category : #initialization }
MbndPrimitiveVectorType >> expandZerosVectorConstruction: node with: builder [
	^ self expandAllConstant: elementType zeroConstantValue vectorConstruction: node with: builder
]

{ #category : #sizes }
MbndPrimitiveVectorType >> instanceAlignment [
	<compileTime>
	^ instanceAlignment ifNil: [ instanceAlignment := elementType instanceAlignment * self alignmentMultiplier ]
]

{ #category : #sizes }
MbndPrimitiveVectorType >> instanceSize [
	<compileTime>
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
