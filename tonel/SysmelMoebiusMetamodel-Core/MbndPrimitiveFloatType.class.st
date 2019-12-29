Class {
	#name : #MbndPrimitiveFloatType,
	#superclass : #MbndPrimitiveNumberType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndPrimitiveFloatType class >> typeName [
	^ #_PrimitiveFloatType
]

{ #category : #visiting }
MbndPrimitiveFloatType >> accept: aVisitor [
	^ aVisitor visitPrimitiveFloatType: self
]

{ #category : #initialization }
MbndPrimitiveFloatType >> addArithmeticIntrinsicsToVectorOrScalarType: vectorOrScalarType [
	super addArithmeticIntrinsicsToVectorOrScalarType: vectorOrScalarType.

	vectorOrScalarType
		addArithmetic: #sqrt unaryIntrinsic: #sqrt.

	vectorOrScalarType isPrimitiveVectorType ifTrue: [ 
		self
			addBuiltIn: #stepValue: intrinsicNamed: 'math.step' argumentTypes: {vectorOrScalarType} returnType: vectorOrScalarType evaluatedWith: [:receiver :arguments :evaluator :node |
				self halt.
			];
			addBuiltIn: #smoothStepTo:value: intrinsicNamed: 'math.smoothstep' argumentTypes: {self . vectorOrScalarType} returnType: vectorOrScalarType evaluatedWith: [:receiver :arguments :evaluator :node |
				self halt.
			].
	].

	vectorOrScalarType
		addBuiltIn: #stepValue: intrinsicNamed: 'math.step' argumentTypes: {vectorOrScalarType} returnType: vectorOrScalarType evaluatedWith: [:receiver :arguments :evaluator :node |
			self halt.
		];
		addBuiltIn: #smoothStepTo:value: intrinsicNamed: 'math.smoothstep' argumentTypes: {vectorOrScalarType. vectorOrScalarType} returnType: vectorOrScalarType evaluatedWith: [:receiver :arguments :evaluator :node |
			self halt.
		];
		addBuiltIn: #interpolateTo:at: intrinsicNamed: 'math.fmix' argumentTypes: {vectorOrScalarType. vectorOrScalarType} returnType: vectorOrScalarType evaluatedWith: [:receiver :arguments :evaluator :node |
			self halt.
		];
		addBuiltIn: #min: intrinsicNamed: 'math.fmin' argumentTypes: {vectorOrScalarType} returnType: vectorOrScalarType evaluatedWith: [:receiver :arguments :evaluator :node |
			self halt.
		];
		addBuiltIn: #max: intrinsicNamed: 'math.fmax' argumentTypes: {vectorOrScalarType} returnType: vectorOrScalarType evaluatedWith: [:receiver :arguments :evaluator :node |
			self halt.
		];

		addBuiltIn: #raisedTo: intrinsicNamed: 'math.pow' argumentTypes: {vectorOrScalarType} returnType: vectorOrScalarType evaluatedWith: [:receiver :arguments :evaluator :node |
			self halt.
		];
		addBuiltIn: #arcTan: intrinsicNamed: 'math.atan2' argumentTypes: {vectorOrScalarType} returnType: vectorOrScalarType evaluatedWith: [:receiver :arguments :evaluator :node |
			self halt.
		].
	
	#(
		(arcSin 'math.asin')
		(sin 'math.sin')
		(arcSinh 'math.asinh')
		(sinh 'math.sinh')

		(arcCos 'math.acos')
		(cos 'math.cos')
		(arcCosh 'math.acosh')
		(cosh 'math.cosh')

		(arcTan 'math.tan')
		(tan 'math.tan')
		(arcTanh 'math.atanh')
		(tanh 'math.tanh')

		(exp 'math.exp')
		(exp2 'math.exp')
		(ln 'math.log')
		(log2 'math.log2')

		(floor 'math.floor')
		(ceil 'math.ceil')
		(truncated 'math.trunc')
		(rounded 'math.round')
		(roundedEven 'math.roundEven')
		(fract 'math.fract')

		(degreesToRadians 'math.degrees')
		(radiansToDegrees 'math.radians')

		(sign 'math.fsign')
		(abs 'math.fabs')
		
	) do: [ :unaryIntrinsic |
		| selector builtIn |
		selector := unaryIntrinsic first.
		builtIn  := unaryIntrinsic second.
		
		vectorOrScalarType addBuiltIn: selector intrinsicNamed: builtIn argumentTypes: #() returnType: vectorOrScalarType evaluatedWith: [:receiver :arguments :evaluator :node |
			self halt.
		]
	].
	

]

{ #category : #converting }
MbndPrimitiveFloatType >> asCVariadicTypeRequiredAt: position [
	^ self compilationTarget float64Type
]

{ #category : #'default values' }
MbndPrimitiveFloatType >> defaultValueAt: aPosition [
	^ MbndValue value: 0.0 type: self
]

{ #category : #testing }
MbndPrimitiveFloatType >> isAcceptableLiteralValue: literalValue [
	^ literalValue isNumber
]

{ #category : #'testing methods' }
MbndPrimitiveFloatType >> isPrimitiveFloatType [
	^ true
]

{ #category : #testing }
MbndPrimitiveFloatType >> legalizeLiteralValue: literalValue [
	literalValue isFloat ifFalse: [ ^ self legalizeLiteralValue: literalValue asFloat ].
	self instanceSize = 4 ifTrue: [ ^ (Float fromIEEE32Bit: literalValue asIEEE32BitWord) ].
	^ literalValue
]

{ #category : #'semantic analysis' }
MbndPrimitiveFloatType >> literalTypeForValue: value [
	value isFloat ifTrue: [ ^ self compilationTarget literalFloatType ].
	^ super literalTypeForValue: value
]

{ #category : #adding }
MbndPrimitiveFloatType >> literalTypesThatCanBeConvertedToMe [
	^ {self compilationTarget literalCharacterType . self compilationTarget literalIntegerType . self compilationTarget literalFloatType }
]

{ #category : #'as yet unclassified' }
MbndPrimitiveFloatType >> oneConstantValue [
	^ MbndValue value: 1.0 type: self
]

{ #category : #'as yet unclassified' }
MbndPrimitiveFloatType >> zeroConstantValue [
	^ MbndValue value: 0.0 type: self
]
