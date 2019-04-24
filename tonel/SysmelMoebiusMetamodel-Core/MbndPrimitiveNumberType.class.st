Class {
	#name : #MbndPrimitiveNumberType,
	#superclass : #MbndPrimitiveType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndPrimitiveNumberType class >> typeName [
	^ #_PrimitiveNumberType
]

{ #category : #initialization }
MbndPrimitiveNumberType >> addArithmetic: selector binaryIntrinsic: intrinsicName [
	self
		addArithmeticOperationCoercionMacro: selector;
		addOverloadedMethod: (MbndIntrinsicArithmeticBinaryOperationMethod new
				name: selector;
				intrinsicName: intrinsicName;
				yourself)
			receiverType: self argumentTypes: { self } returnType: self
]

{ #category : #initialization }
MbndPrimitiveNumberType >> addArithmetic: selector unaryIntrinsic: intrinsicName [
	self
		addOverloadedMethod: (MbndIntrinsicArithmeticUnaryOperationMethod new
				name: selector;
				intrinsicName: intrinsicName;
				yourself)
			receiverType: self argumentTypes: #() returnType: self
]

{ #category : #initialization }
MbndPrimitiveNumberType >> addArithmeticIntrinsics [
	self
		addArithmetic: #negated unaryIntrinsic: #neg;
		addArithmetic: #+ binaryIntrinsic: #add;
		addArithmetic: #- binaryIntrinsic: #sub;
		addArithmetic: #* binaryIntrinsic: #mult;
		addArithmetic: #/ binaryIntrinsic: #div;
		addArithmetic: #// binaryIntrinsic: #idiv;
		addArithmetic: #\\ binaryIntrinsic: #irem;
		addArithmetic: #% binaryIntrinsic: #rem.
]

{ #category : #initialization }
MbndPrimitiveNumberType >> addArithmeticOperationCoercionMacro: selector [
	self macroMethodDict at: selector
		ifPresent: [ self error: 'Duplicated macro selector.' ]
		ifAbsentPut: (MbndArithmeticOperationCoercionMacro new)
]

{ #category : #initialization }
MbndPrimitiveNumberType >> addComparisonIntrinsics [
]

{ #category : #initialization }
MbndPrimitiveNumberType >> initialize [
	super initialize.
	self
		addArithmeticIntrinsics;
		addComparisonIntrinsics.
]

{ #category : #'testing methods' }
MbndPrimitiveNumberType >> isPrimitiveNumberType [
	^ true
]
