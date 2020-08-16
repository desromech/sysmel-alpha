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
MbndPrimitiveFloatType >> addArithmeticIntrinsicsToMatrixType: matrixType [
	super addArithmeticIntrinsicsToMatrixType: matrixType.
	matrixType isSquare ifTrue: [
		matrixType
			addBuiltIn: #determinant intrinsicNamed: 'matrix.determinant' argumentTypes: #() returnType: self evaluatedWith: [:receiver :arguments :evaluator :node |
				self halt.
			];
			addBuiltIn: #inverse intrinsicNamed: 'matrix.inverse' argumentTypes: #() returnType: matrixType evaluatedWith: [:receiver :arguments :evaluator :node |
				self halt.
			]
	].
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
		];
		addBuiltIn: #floorMod: intrinsicNamed: 'math.fmod' argumentTypes: {vectorOrScalarType} returnType: vectorOrScalarType evaluatedWith: [:receiver :arguments :evaluator :node |
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
		(ceiling 'math.ceil')
		(truncated 'math.trunc')
		(rounded 'math.round')
		(roundedEven 'math.roundEven')
		(fract 'math.fract')

		(degreesToRadians 'math.radians')
		(radiansToDegrees 'math.degrees')

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

{ #category : #initialization }
MbndPrimitiveFloatType >> addInstanceMacros [
	self class == MbndPrimitiveFloatType ifFalse: [ ^ self ].
	self isTrait ifFalse: [ ^ self ].
	
	self type
		onMacroSelectors: #(negativeInfinity negativeInfinityOrMinValue) do: [ :node :builder |
			(builder explicitCast: ((builder literalFloat: Float negativeInfinity)
				position: node) to: node receiver)
				position: node
		];
	
		onMacroSelectors: #(infinity infinityOrMaxValue) do: [ :node :builder |
			(builder explicitCast: ((builder literalFloat: Float infinity)
				position: node) to: node receiver)
				position: node
		];
		onMacroSelector: #nan do: [ :node :builder |
			(builder explicitCast: ((builder literalFloat: Float qNaN)
				position: node) to: node receiver)
				position: node
		];
		onMacroSelector: #qNaN do: [ :node :builder |
			(builder explicitCast: ((builder literalFloat: Float qNaN)
				position: node) to: node receiver)
				position: node
		];
		onMacroSelector: #sNaN do: [ :node :builder |
			(builder explicitCast: ((builder literalFloat: Float sNaN)
				position: node) to: node receiver)
				position: node
		];
		onMacroSelector: #e do: [ :node :builder |
			(builder explicitCast: ((builder literalFloat: 2.718281828459045)
				position: node) to: node receiver)
				position: node
		];
		onMacroSelector: #piReciprocal do: [ :node :builder |
			(builder explicitCast: ((builder literalFloat: 0.3183098861837907)
				position: node) to: node receiver)
				position: node
		];
		onMacroSelector: #pi do: [ :node :builder |
			(builder explicitCast: ((builder literalFloat: 3.141592653589793)
				position: node) to: node receiver)
				position: node
		];
		onMacroSelector: #twoPi do: [ :node :builder |
			(builder explicitCast: ((builder literalFloat: 6.283185307179586 )
				position: node) to: node receiver)
				position: node
		];
		onMacroSelector: #twoPiReciprocal do: [ :node :builder |
			(builder explicitCast: ((builder literalFloat: 0.15915494309189535 )
				position: node) to: node receiver)
				position: node
		];
		onMacroSelector: #threePi do: [ :node :builder |
			(builder explicitCast: ((builder literalFloat: 9.42477796076938 )
				position: node) to: node receiver)
				position: node
		];
		onMacroSelector: #threePiReciprocal do: [ :node :builder |
			(builder explicitCast: ((builder literalFloat: 0.1061032953945969 )
				position: node) to: node receiver)
				position: node
		];
		onMacroSelector: #halfPi do: [ :node :builder |
			(builder explicitCast: ((builder literalFloat: 1.5707963267948966 )
				position: node) to: node receiver)
				position: node
		];
		onMacroSelector: #halfPiReciprocal do: [ :node :builder |
			(builder explicitCast: ((builder literalFloat: 0.6366197723675814 )
				position: node) to: node receiver)
				position: node
		]
]

{ #category : #converting }
MbndPrimitiveFloatType >> analyzeReinterpretCastNode: node to: targetType with: analyzer [
	| undecoratedTargetType |
	undecoratedTargetType := targetType withoutTopDecorations.

	(undecoratedTargetType isPrimitiveIntegerType and: [ undecoratedTargetType instanceSize = self instanceSize ]) ifTrue: [
		^ analyzer visitNode: (MbndAstBitCastNode new
			position: node;
			expression: node expression;
			targetType: targetType;
			yourself)
	].

	^ super analyzeReinterpretCastNode: node to: targetType with: analyzer
]

{ #category : #converting }
MbndPrimitiveFloatType >> asCVariadicTypeRequiredAt: position [
	^ self compilationTarget float64Type
]

{ #category : #'default values' }
MbndPrimitiveFloatType >> defaultValueAt: aPosition [
	^ MbndValue value: 0.0 type: self
]

{ #category : #'as yet unclassified' }
MbndPrimitiveFloatType >> infinityConstantValue [
	^ MbndValue value: Float infinity type: self
]

{ #category : #'as yet unclassified' }
MbndPrimitiveFloatType >> infinityOrMaxValueConstantValue [
	^ self infinityConstantValue
]

{ #category : #testing }
MbndPrimitiveFloatType >> isAcceptableLiteralValue: literalValue [
	^ literalValue isNumber
]

{ #category : #'testing methods' }
MbndPrimitiveFloatType >> isPrimitiveFloatType [
	<compileTime>
	^ true
]

{ #category : #testing }
MbndPrimitiveFloatType >> legalizeLiteralValue: literalValue [
	literalValue isFloat ifFalse: [ ^ self legalizeLiteralValue: literalValue asFloat ].
	literalValue isInfinite ifTrue: [ ^ literalValue ].
	literalValue isNaN ifTrue: [ ^ literalValue ].
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
MbndPrimitiveFloatType >> negativeInfinityConstantValue [
	^ MbndValue value: Float negativeInfinity type: self
]

{ #category : #'as yet unclassified' }
MbndPrimitiveFloatType >> negativeInfinityOrMinValueConstantValue [
	^ self negativeInfinityConstantValue
]

{ #category : #'as yet unclassified' }
MbndPrimitiveFloatType >> oneConstantValue [
	^ MbndValue value: 1.0 type: self
]

{ #category : #'as yet unclassified' }
MbndPrimitiveFloatType >> zeroConstantValue [
	^ MbndValue value: 0.0 type: self
]
