Class {
	#name : #SYMLSimpleType,
	#superclass : #SYMLAbstractType,
	#classVars : [
		'FloatingPointOperationMap',
		'SignedIntegerOperationMap',
		'UnsignedIntegerOperationMap'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #initialization }
SYMLSimpleType class >> initialize [
	
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
	
	FloatingPointOperationMap := Dictionary newFromPairs: #(
		+ fadd
		- fsub
		* fmul
		/ fdiv
		% frem

		< uflt
		<= ufle
		= ufeq
		~= ufne
		> ufgt
		>= ufge

		== ufeq
		~~ ufne
	)
]

{ #category : #definition }
SYMLSimpleType >> definitionScopeClass [
	^ SYMLTypeScope
]

{ #category : #'primitive types' }
SYMLSimpleType >> generatePrimitiveFloatingPointArithmeticMessage: messageNode withBuilder: builder left: left right: right at: aPosition [
	FloatingPointOperationMap at: messageNode ifPresent: [ :binop |
		^ builder addOperation: binop left: left right: right
	].

	self error: 'Unsupported arithmetic operation {1} with coerced values of type {2}.' format: { messageNode selector . self name } at: aPosition
]

{ #category : #'primitive types' }
SYMLSimpleType >> generatePrimitiveSignedIntegerArithmeticMessage: messageNode withBuilder: builder left: left right: right at: aPosition [
	SignedIntegerOperationMap at: messageNode ifPresent: [ :binop |
		^ builder addOperation: binop left: left right: right
	].

	self error: 'Unsupported arithmetic operation {1} with coerced values of type {2}.' format: { messageNode selector . self name } at: aPosition
]

{ #category : #'primitive types' }
SYMLSimpleType >> generatePrimitiveUnsignedIntegerArithmeticMessage: messageNode withBuilder: builder left: left right: right at: aPosition [
	UnsignedIntegerOperationMap at: messageNode ifPresent: [ :binop |
		^ builder addOperation: binop left: left right: right
	].

	self error: 'Unsupported arithmetic operation {1} with coerced values of type {2}.' format: { messageNode selector . self name } at: aPosition
]

{ #category : #printing }
SYMLSimpleType >> printOn: aStream [
	aStream nextPutAll: 'type '; nextPutAll: self printingName
]
