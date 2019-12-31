Class {
	#name : #MbndPrimitiveNumberType,
	#superclass : #MbndPrimitiveScalarType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndPrimitiveNumberType class >> typeName [
	^ #_PrimitiveNumberType
]

{ #category : #initialization }
MbndPrimitiveNumberType >> addArithmeticIntrinsicsToMatrixType: matrixType [
	super addArithmeticIntrinsicsToMatrixType: matrixType.
	
	matrixType onMacroSelector: #* do: [ :node :builder |
		(builder matrix: node receiver multiplicationWith: node arguments first)
			position: node
	].
]

{ #category : #initialization }
MbndPrimitiveNumberType >> addArithmeticIntrinsicsToVectorOrScalarType: vectorOrScalarType [
	vectorOrScalarType
		addArithmetic: #'prefix--' unaryIntrinsic: #neg;
		addArithmetic: #negated unaryIntrinsic: #neg;
		addArithmetic: #+ binaryIntrinsic: #add;
		addArithmetic: #- binaryIntrinsic: #sub.
		
	vectorOrScalarType isPrimitiveMatrixType ifTrue: [ 
		vectorOrScalarType
			addArithmetic: #%* binaryIntrinsic: #mul;
			addArithmetic: #%/ binaryIntrinsic: #div;
			addArithmetic: #%// binaryIntrinsic: #idiv;
			addArithmetic: #%\\ binaryIntrinsic: #irem;
			addArithmetic: #%% binaryIntrinsic: #rem.
	] ifFalse: [ 
		vectorOrScalarType
			addArithmetic: #* binaryIntrinsic: #mul;
			addArithmetic: #/ binaryIntrinsic: #div;
			addArithmetic: #// binaryIntrinsic: #idiv;
			addArithmetic: #\\ binaryIntrinsic: #irem;
			addArithmetic: #% binaryIntrinsic: #rem.
	].

	vectorOrScalarType onMacroSelector: #clampMin:max: do: [ :node :builder |
		(builder unexpandedSend: (builder literalSymbol: #min:)
			to: ((builder unexpandedSend: (builder literalSymbol: #max:) to: node receiver
				withArguments: { node arguments first})
				position: node)
			withArguments: { node arguments second })
				position: node
		
	].

]

{ #category : #initialization }
MbndPrimitiveNumberType >> addComparisonIntrinsics [
	super addComparisonIntrinsics.
	self
		addComparison: #< intrinsic: #lt;
		addComparison: #<= intrinsic: #le;
		addComparison: #>= intrinsic: #ge;
		addComparison: #> intrinsic: #gt
]

{ #category : #'testing methods' }
MbndPrimitiveNumberType >> isPrimitiveNumberType [
	^ true
]
