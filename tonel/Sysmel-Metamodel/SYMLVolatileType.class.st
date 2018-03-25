Class {
	#name : #SYMLVolatileType,
	#superclass : #SYMLDecoratorType,
	#category : #Sysmel-Metamodel-Types
}

{ #category : #testing }
SYMLVolatileType >> isVolatileType [
	^ true
]

{ #category : #printing }
SYMLVolatileType >> printOn: aStream [
	aStream print: decorated; nextPutAll: ' volatile'
]
