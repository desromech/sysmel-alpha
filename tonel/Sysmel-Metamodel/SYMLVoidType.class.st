Class {
	#name : #SYMLVoidType,
	#superclass : #SYMLOpaqueType,
	#category : #Sysmel-Metamodel-Types
}

{ #category : #'as yet unclassified' }
SYMLVoidType >> buildSSAType [
	^ target lowLevelTarget voidType
]

{ #category : #accessing }
SYMLVoidType >> name [
	^ #Void
]
