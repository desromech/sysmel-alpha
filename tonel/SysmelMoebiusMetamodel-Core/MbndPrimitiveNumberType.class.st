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
MbndPrimitiveNumberType >> addArithmeticIntrinsics [
	self
		addArithmetic: #'prefix--' unaryIntrinsic: #neg;
		addArithmetic: #negated unaryIntrinsic: #neg;
		addArithmetic: #+ binaryIntrinsic: #add;
		addArithmetic: #- binaryIntrinsic: #sub;
		addArithmetic: #* binaryIntrinsic: #mul;
		addArithmetic: #/ binaryIntrinsic: #div;
		addArithmetic: #// binaryIntrinsic: #idiv;
		addArithmetic: #\\ binaryIntrinsic: #irem;
		addArithmetic: #% binaryIntrinsic: #rem.
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
