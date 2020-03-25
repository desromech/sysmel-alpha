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

{ #category : #initialization }
MbndEnumType >> addArithmeticOperationCoercionMacro: selector [
	self macroMethodDict at: selector
		ifPresent: [ self error: 'Duplicated macro selector.' ]
		ifAbsentPut: (MbndArithmeticOperationCoercionMacro new)
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
		onMacroSelector: #value do: [ :node :builder |
			builder unwrapEnumValue: node receiver.
		]

]

{ #category : #accessing }
MbndEnumType >> baseType: aBaseType [
	super baseType: aBaseType.
	self addConversionsBetweenBaseType.
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

{ #category : #'testing methods' }
MbndEnumType >> isEnumType [
	^ true
]

{ #category : #testing }
MbndEnumType >> isNonCopyable [
	^ baseType isNonCopyable
]

{ #category : #testing }
MbndEnumType >> isNonMoveable [
	^ baseType isNonMoveable
]

{ #category : #'as yet unclassified' }
MbndEnumType >> lookupStaticMacroSelector: selector [
	values at: selector ifPresent: [ :enumValue |
		^ enumValue asMacroExpandedToConstant
	].
	^ super lookupStaticMacroSelector: selector
]

{ #category : #serialization }
MbndEnumType >> materializeWithGraphDecoder: graphDecoder withLazyFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withLazyFields: encodedFields.
	values := encodedFields at: #values.
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
