Class {
	#name : #SYMLIntegerType,
	#superclass : #SYMLPrimitiveNumberType,
	#instVars : [
		'signed'
	],
	#classVars : [
		'SignedIntegerOperationMap',
		'UnsignedIntegerOperationMap'
	],
	#category : #Sysmel-Metamodel-Types
}

{ #category : #initialization }
SYMLIntegerType class >> initialize [
	super initialize.

	SignedIntegerOperationMap := Dictionary newFromPairs: #(
		+ add
		- sub
		* mul
		/ div
		% rem
		
		& bitand
		bitAnd: bitand
		| bitor
		bitOr: bitor
		^ bitxor
		bitXor: bitxor
		
		<< shiftleft
		>> shiftrightarithmetic
		
		== ieq
		= ieq
		~= ine
		~~ ine

		< ilt
		<= ile
		> igt
		>= ige
	).
	
	UnsignedIntegerOperationMap := Dictionary newFromPairs: #(
		+ add
		- sub
		* mul
		/ udiv
		% urem
		
		& bitand
		bitAnd: bitand
		| bitor
		bitOr: bitor
		^ bitxor
		bitXor: bitxor
		
		<< shiftleft
		>> shiftrightarithmetic
		
		== ieq
		= ieq
		~= ine
		~~ ine

		< ult
		<= ule
		> ugt
		>= uge
	).
]

{ #category : #arithmetic }
SYMLIntegerType >> generateArithmeticMessage: selector withBuilder: builder left: left right: right at: messageNode [
	signed ifTrue: [
		SignedIntegerOperationMap at: selector ifPresent: [ :binop |
			^ builder addOperation: binop left: left right: right
		]
	] ifFalse: [ 
		UnsignedIntegerOperationMap at: selector ifPresent: [ :binop |
			^ builder addOperation: binop left: left right: right
		]
	].
	^ super generateArithmeticMessage: selector withBuilder: builder left: left right: right at: messageNode
]

{ #category : #arithmetic }
SYMLIntegerType >> generateArithmeticMessage: selector withBuilder: builder operand: operand at: messageNode [
	signed ifTrue: [
		SignedIntegerOperationMap at: selector ifPresent: [ :binop |
			^ builder addOperation: binop operand: operand
		]
	] ifFalse: [ 
		UnsignedIntegerOperationMap at: selector ifPresent: [ :binop |
			^ builder addOperation: binop operand: operand
		]
	].
	^ super generateArithmeticMessage: selector withBuilder: builder operand: operand at: messageNode
]

{ #category : #testing }
SYMLIntegerType >> isIntegerType [
	^ true
]

{ #category : #accessing }
SYMLIntegerType >> isSigned [
	^ signed
]

{ #category : #accessing }
SYMLIntegerType >> isUnsigned [
	^ signed not
]

{ #category : #arithmetic }
SYMLIntegerType >> resultTypeForArithmeticMessage: selector at: node [
	(ArithmeticSelectors includes: selector) ifTrue: [ ^ self ].
	(BitwiseSelectors includes: selector) ifTrue: [ ^ self ].
	(ComparisonSelectors includes: selector) ifTrue: [ ^ target booleanType ].
	^ super resultTypeForArithmeticMessage: selector at: node
]

{ #category : #accessing }
SYMLIntegerType >> signed [
	^ signed
]

{ #category : #accessing }
SYMLIntegerType >> signed: anObject [
	signed := anObject
]

{ #category : #coercion }
SYMLIntegerType >> ssaCoerceImplicitly: value toCVariadicWith: builder at: aSourcePosition [
	self size >= 4 ifTrue: [ ^ value ].
	signed ifTrue: [
		^ builder signExtend: value target: builder compilationTarget
	] ifFalse: [ 
		^ builder zeroExtend: value target: builder compilationTarget
	]
]
