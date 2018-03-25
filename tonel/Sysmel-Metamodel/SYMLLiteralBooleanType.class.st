Class {
	#name : #SYMLLiteralBooleanType,
	#superclass : #SYMLLiteralType,
	#category : #Sysmel-Metamodel-Types
}

{ #category : #testing }
SYMLLiteralBooleanType >> canBeNode: node coercedImplicitlyIntoCVariadicAt: aSourcePosition [
	^ true
]

{ #category : #testing }
SYMLLiteralBooleanType >> isBooleanType [
	^ true
]

{ #category : #accessing }
SYMLLiteralBooleanType >> name [
	^ #_LiteralBoolean
]
