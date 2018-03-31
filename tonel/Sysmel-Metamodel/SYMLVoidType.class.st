Class {
	#name : #SYMLVoidType,
	#superclass : #SYMLOpaqueType,
	#category : #Sysmel-Metamodel-Types
}

{ #category : #'as yet unclassified' }
SYMLVoidType >> buildSSAType [
	^ target lowLevelTarget void
]

{ #category : #testing }
SYMLVoidType >> isVoidType [
	^ true
]

{ #category : #accessing }
SYMLVoidType >> name [
	^ #Void
]
