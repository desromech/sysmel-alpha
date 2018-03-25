Class {
	#name : #SYMLBooleanType,
	#superclass : #SYMLPrimitiveType,
	#category : #Sysmel-Metamodel-Types
}

{ #category : #testing }
SYMLBooleanType >> canBeNode: node coercedImplicitlyIntoCVariadicAt: aSourcePosition [
	^ true
]

{ #category : #arithmetic }
SYMLBooleanType >> generateArithmeticMessage: selector withBuilder: builder operand: operand at: messageNode [
	self assert: selector == #not.
	^ builder lnot: operand
]

{ #category : #testing }
SYMLBooleanType >> isBooleanType [
	^ true
]
