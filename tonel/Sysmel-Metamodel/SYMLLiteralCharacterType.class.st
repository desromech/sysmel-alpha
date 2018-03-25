Class {
	#name : #SYMLLiteralCharacterType,
	#superclass : #SYMLLiteralType,
	#category : #Sysmel-Metamodel-Types
}

{ #category : #testing }
SYMLLiteralCharacterType >> canBeNode: node coercedImplicitlyIntoCVariadicAt: aSourcePosition [
	^ true
]

{ #category : #accessing }
SYMLLiteralCharacterType >> name [
	^ #_LiteralCharacter
]
