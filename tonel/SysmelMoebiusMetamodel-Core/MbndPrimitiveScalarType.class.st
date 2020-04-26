Class {
	#name : #MbndPrimitiveScalarType,
	#superclass : #MbndPrimitiveType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndPrimitiveScalarType class >> typeName [
	^ #_PrimitiveScalarType
]

{ #category : #adding }
MbndPrimitiveScalarType >> addArithmeticIntrinsics [
	self addArithmeticIntrinsicsToVectorOrScalarType: self
	
]

{ #category : #adding }
MbndPrimitiveScalarType >> addArithmeticIntrinsicsToMatrixType: matrixType [
	self addArithmeticIntrinsicsToVectorOrScalarType: matrixType
	
]

{ #category : #adding }
MbndPrimitiveScalarType >> addArithmeticIntrinsicsToVectorOrScalarType: vectorOrScalarType [
	
]

{ #category : #initialization }
MbndPrimitiveScalarType >> addComparisonIntrinsics [
	super addComparisonIntrinsics.
	self
		addComparison: #= intrinsic: #eq;
		addComparison: #== intrinsic: #eq;
		addComparison: #~= intrinsic: #ne;
		addComparison: #~~ intrinsic: #ne;
		
		addThreeWayComparisonIntrinsic: #<=>;
		addComparison: #< intrinsic: #lt;
		addComparison: #<= intrinsic: #le;
		addComparison: #>= intrinsic: #ge;
		addComparison: #> intrinsic: #gt
]

{ #category : #adding }
MbndPrimitiveScalarType >> addConversionsFromLiteralTypes [
	self literalTypesThatCanBeConvertedToMe do: [ :literalType |
		literalType addConversionRulesToTargetType: self
	]
]

{ #category : #adding }
MbndPrimitiveScalarType >> addDefaultConversionRules [
	super addDefaultConversionRules.
	self isTrait ifFalse: [
		self addConversionsFromLiteralTypes
	].
]

{ #category : #initialization }
MbndPrimitiveScalarType >> elementWiseComparisonResult [
	^ self compilationTarget booleanType
]

{ #category : #initialization }
MbndPrimitiveScalarType >> elementWiseThreeWayComparisonResult [
	^ self compilationTarget int32Type
]

{ #category : #accessing }
MbndPrimitiveScalarType >> instanceAlignment [
	<compileTime>
	^ instanceAlignment
]

{ #category : #accessing }
MbndPrimitiveScalarType >> instanceAlignment: anObject [
	instanceAlignment := anObject
]

{ #category : #accessing }
MbndPrimitiveScalarType >> instanceSize [
	<compileTime>
	^ instanceSize
]

{ #category : #accessing }
MbndPrimitiveScalarType >> instanceSize: anObject [
	instanceSize := anObject
]

{ #category : #testing }
MbndPrimitiveScalarType >> isAcceptableLiteralValueInRange: value [
	^ (self isAcceptableLiteralValue: value) and: [ self isValueInRange: value ]
]

{ #category : #'testing methods' }
MbndPrimitiveScalarType >> isPrimitiveScalarType [
	^ true
]

{ #category : #adding }
MbndPrimitiveScalarType >> literalTypesThatCanBeConvertedToMe [
	^ #()
]

{ #category : #'as yet unclassified' }
MbndPrimitiveScalarType >> oneConstantValue [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
MbndPrimitiveScalarType >> primitiveMatrixWithRows: rows columns: columns [
	<compileTime>
	^ self compilationTarget primitiveMatrixTypeFor: self rows: rows columns: columns
	
]

{ #category : #'as yet unclassified' }
MbndPrimitiveScalarType >> primitiveVectorWithElements: vectorSize [
	<compileTime>
	vectorSize <= 1 ifTrue: [ ^ self ].
	^ self compilationTarget primitiveVectorTypeFor: self elements: vectorSize
	
]

{ #category : #'as yet unclassified' }
MbndPrimitiveScalarType >> zeroConstantValue [
	^ self subclassResponsibility
]
