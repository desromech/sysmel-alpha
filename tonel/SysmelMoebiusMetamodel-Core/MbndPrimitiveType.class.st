"
I represent a primitive type. My instances are usually able to fit in single CPU registers, or they have dedicated CPU instructions for operating with them. They correspond to primitive C types.
"
Class {
	#name : #MbndPrimitiveType,
	#superclass : #MbndNativeType,
	#instVars : [
		'instanceSize',
		'instanceAlignment'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndPrimitiveType class >> typeName [
	^ #_PrimitiveType
]

{ #category : #initialization }
MbndPrimitiveType >> addArithmetic: selector binaryIntrinsic: intrinsicName [
	self
		addArithmeticOperationCoercionMacro: selector;
		addOverloadedMethod: (MbndIntrinsicArithmeticBinaryOperationMethod new
				name: selector;
				intrinsicName: intrinsicName;
				yourself)
			receiverType: self argumentTypes: { self } returnType: self
]

{ #category : #initialization }
MbndPrimitiveType >> addArithmetic: selector unaryIntrinsic: intrinsicName [
	self
		addOverloadedMethod: (MbndIntrinsicArithmeticUnaryOperationMethod new
				name: selector;
				intrinsicName: intrinsicName;
				yourself)
			receiverType: self argumentTypes: #() returnType: self
]

{ #category : #initialization }
MbndPrimitiveType >> addArithmeticIntrinsics [
]

{ #category : #initialization }
MbndPrimitiveType >> addArithmeticOperationCoercionMacro: selector [
	self macroMethodDict at: selector
		ifPresent: [ self error: 'Duplicated macro selector.' ]
		ifAbsentPut: (MbndArithmeticOperationCoercionMacro new)
]

{ #category : #initialization }
MbndPrimitiveType >> addComparison: selector intrinsic: intrinsicName [
	self
		addArithmeticOperationCoercionMacro: selector;
		addOverloadedMethod: (MbndIntrinsicArithmeticComparisonMethod new
				name: selector;
				intrinsicName: intrinsicName;
				yourself)
			receiverType: self argumentTypes: { self } returnType: self compilationTarget booleanType
]

{ #category : #initialization }
MbndPrimitiveType >> addComparisonIntrinsics [
	self
		addComparison: #= intrinsic: #eq;
		addComparison: #== intrinsic: #eq;
		addComparison: #~= intrinsic: #ne;
		addComparison: #~~ intrinsic: #ne
]

{ #category : #'semantic analysis' }
MbndPrimitiveType >> bestConcreteTypeForLiteralValueNode: literalValueNode inScope: scope [
	| literalType |
	literalValueNode isLiteralValueNode ifTrue: [ 
		literalType := self literalTypeForValue: literalValueNode value.
		literalType ifNotNil: [ 
			(literalType bestConcreteTypeForLiteralValueNode: literalValueNode inScope: scope) ifNotNil: [ :concreteType | ^ concreteType ].
		].
	].
	
	^ super bestConcreteTypeForLiteralValueNode: literalValueNode inScope: scope
]

{ #category : #initialization }
MbndPrimitiveType >> initialize [
	super initialize.
	self
		addArithmeticIntrinsics;
		addComparisonIntrinsics.
]

{ #category : #accessing }
MbndPrimitiveType >> instanceAlignment [
	<compileTime>
	^ instanceAlignment
]

{ #category : #accessing }
MbndPrimitiveType >> instanceAlignment: anObject [
	instanceAlignment := anObject
]

{ #category : #accessing }
MbndPrimitiveType >> instanceSize [
	<compileTime>
	^ instanceSize
]

{ #category : #accessing }
MbndPrimitiveType >> instanceSize: anObject [
	instanceSize := anObject
]

{ #category : #'testing methods' }
MbndPrimitiveType >> isPrimitiveType [
	^ true
]

{ #category : #'semantic analysis' }
MbndPrimitiveType >> literalTypeForValue: value [
	^ nil
]
