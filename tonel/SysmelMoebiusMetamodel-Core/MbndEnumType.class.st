Class {
	#name : #MbndEnumType,
	#superclass : #MbndDerivedType,
	#instVars : [
		'values'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndEnumType class >> typeName [
	^ #_EnumType
]

{ #category : #visiting }
MbndEnumType >> accept: visitor [
	^ visitor visitEnumType: self
]

{ #category : #accessing }
MbndEnumType >> addArithmetic: selector binaryIntrinsic: intrinsicName [
	self
		addArithmeticOperationCoercionMacro: selector;
		addOverloadedMethod: (MbndIntrinsicArithmeticBinaryOperationMethod new
				name: selector;
				intrinsicName: intrinsicName;
				yourself)
			receiverType: self argumentTypes: { self } returnType: self
]

{ #category : #adding }
MbndEnumType >> addArithmetic: selector unaryIntrinsic: intrinsicName [
	self
		addOverloadedMethod: (MbndIntrinsicArithmeticUnaryOperationMethod new
				name: selector;
				intrinsicName: intrinsicName;
				yourself)
			receiverType: self argumentTypes: #() returnType: self
]

{ #category : #initialization }
MbndEnumType >> addArithmeticOperationCoercionMacro: selector [
	self macroMethodDict at: selector
		ifPresent: [ self error: 'Duplicated macro selector.' ]
		ifAbsentPut: (MbndArithmeticOperationCoercionMacro new parent: self; yourself)
]

{ #category : #accessing }
MbndEnumType >> addBitMaskArithmetic [
	(self lookupOverloadedSelector: #bitAnd:) ifNotNil: [ ^ self ].
	self
		addArithmetic: #bitAnd: binaryIntrinsic: #bitand;
		addArithmetic: #& binaryIntrinsic: #bitand;
		addArithmetic: #bitOr: binaryIntrinsic: #bitor;
		addArithmetic: #| binaryIntrinsic: #bitor;
		addArithmetic: #bitXor: binaryIntrinsic: #bitxor;
		addArithmetic: #'^' binaryIntrinsic: #bitxor;

		addArithmetic: #<< binaryIntrinsic: #shiftleft;
		addArithmetic: #>> binaryIntrinsic: #shiftright;
		
		addArithmetic: #bitInvert unaryIntrinsic: #not;
		addArithmetic: #'prefix-~' unaryIntrinsic: #not
]

{ #category : #initialization }
MbndEnumType >> addComparison: selector intrinsic: intrinsicName [
	self
		addArithmeticOperationCoercionMacro: selector;
		addOverloadedMethod: (MbndIntrinsicArithmeticComparisonMethod new
				name: selector;
				intrinsicName: intrinsicName;
				yourself)
			receiverType: self argumentTypes: { self } returnType: self compilationTarget booleanType
]

{ #category : #initialization }
MbndEnumType >> addComparisonIntrinsics [
	baseType ifNotNil: [ self halt ].
	self
		addComparison: #= intrinsic: #eq;
		addComparison: #== intrinsic: #eq;
		addComparison: #~= intrinsic: #ne;
		addComparison: #~~ intrinsic: #ne;
		addComparison: #< intrinsic: #lt;
		addComparison: #<= intrinsic: #le;
		addComparison: #>= intrinsic: #ge;
		addComparison: #> intrinsic: #gt
]

{ #category : #initialization }
MbndEnumType >> addConversionsBetweenBaseType [
	self addConversionTo: baseType rule: MbndUnwrapEnumValueTypeConversionRule.
	baseType addExplicitConversionTo: self rule: MbndWrapEnumValueTypeConversionRule.
]

{ #category : #initialization }
MbndEnumType >> addDefaultConversionRules [
	super addDefaultConversionRules.
	baseType ifNotNil: [
		self addConversionsBetweenBaseType
	].

]

{ #category : #initialization }
MbndEnumType >> addInstanceMacros [
	self class == MbndEnumType ifFalse: [ ^ self ].
	self isTrait ifFalse: [ ^ self ].
	self
		onMacroSelector: #to: do: [ :node :builder :analyzer |
			| result |
			result := node asExpandedMessageSend.
			node receiver type baseType isPrimitiveNumberType ifTrue: [ 
				node receiver isLiteralValueNode ifTrue: [ 
					| argument |
					argument := analyzer visitNode: node arguments first.
					(argument type = node receiver type and: [argument isLiteralValueNode]) ifTrue: [
						result := builder literal: { node receiver . argument } type: builder compilationTarget literalIntervalType 
					] ifFalse: [
						"Do not analyze more than onces the argument."
						result arguments: {argument}
					]
				]. 
			].
		
			analyzer visitNode: result
		];
		onMacroSelector: #value do: [ :node :builder |
			builder unwrapEnumValue: node receiver.
		]

]

{ #category : #accessing }
MbndEnumType >> baseType: aBaseType [
	super baseType: aBaseType.
	self addConversionsBetweenBaseType.
	
	(self hasFlag: #bitMask) ifTrue: [
		self addBitMaskArithmetic
	]
]

{ #category : #'default values' }
MbndEnumType >> defaultValueAt: aPosition [
	^ (baseType defaultValueAt: aPosition) copy type: self
]

{ #category : #serialization }
MbndEnumType >> encodeLazyFieldsForMessagePackWith: graphEncoder [
	^ (super encodeLazyFieldsForMessagePackWith: graphEncoder) , {
		#values . values encodeGraphForMessagePackWith: graphEncoder.
	}
]

{ #category : #initialization }
MbndEnumType >> initialize [
	super initialize.
	self addComparisonIntrinsics
]

{ #category : #sizes }
MbndEnumType >> instanceAlignment [
	<compileTime>
	^ baseType instanceAlignment
]

{ #category : #sizes }
MbndEnumType >> instanceSize [
	<compileTime>
	^ baseType instanceSize
]

{ #category : #testing }
MbndEnumType >> isCopyable [
	^ baseType isCopyable
]

{ #category : #'testing methods' }
MbndEnumType >> isEnumType [
	^ true
]

{ #category : #testing }
MbndEnumType >> isMoveable [
	^ baseType isMoveable
]

{ #category : #'as yet unclassified' }
MbndEnumType >> lookupStaticMacroSelector: selector [
	values at: selector ifPresent: [ :enumValue |
		^ enumValue asMacroExpandedToConstant
	].
	^ super lookupStaticMacroSelector: selector
]

{ #category : #'member symbols' }
MbndEnumType >> lookupSymbol: aSymbol [
	values ifNotNil: [ 
		values at: aSymbol ifPresent: [ :found |
			^ found
		]
	].
	^ super lookupSymbol: aSymbol
]

{ #category : #serialization }
MbndEnumType >> materializeWithGraphDecoder: graphDecoder withLazyFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withLazyFields: encodedFields.
	values := encodedFields at: #values.
]

{ #category : #'as yet unclassified' }
MbndEnumType >> stringToValuesCases [
	<compileTime>
	^ (values associations asArray sorted: [ :a :b | a key < b key ])
		collect: [ :assoc |
			| key value |
			key := (assoc key asString
					asMoebiusLiteralValueNodeWithTarget: self compilationTarget)
					position: self definitionPosition;
					yourself.
			value := (assoc value
					asMoebiusLiteralValueNodeWithTarget: self compilationTarget)
					position: self definitionPosition;
					yourself.
			MbndAstAssociationNode new
				position: self definitionPosition;
				key: key;
				value: value;
				yourself
		]
]

{ #category : #accessing }
MbndEnumType >> valueType [
	<compileTime>
	^ baseType
]

{ #category : #accessing }
MbndEnumType >> valueType: aType [
	<compileTime>
	self assert: baseType isNil.
	^ self baseType: aType
]

{ #category : #accessing }
MbndEnumType >> values [
	^ values
]

{ #category : #accessing }
MbndEnumType >> values: anObject [
	values := anObject
]

{ #category : #'as yet unclassified' }
MbndEnumType >> valuesToStringCases [
	<compileTime>
	^ (values associations asArray sorted: [ :a :b | a key < b key ])
		collect: [ :assoc |
			| key value |
			value := (assoc key asString
					asMoebiusLiteralValueNodeWithTarget: self compilationTarget)
					position: self definitionPosition;
					yourself.
			key := (assoc value
					asMoebiusLiteralValueNodeWithTarget: self compilationTarget)
					position: self definitionPosition;
					yourself.
			MbndAstAssociationNode new
				position: self definitionPosition;
				key: key;
				value: value;
				yourself
		]
]
