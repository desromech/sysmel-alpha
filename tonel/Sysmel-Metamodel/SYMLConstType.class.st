Class {
	#name : #SYMLConstType,
	#superclass : #SYMLDecoratorType,
	#category : #Sysmel-Metamodel-Types
}

{ #category : #testing }
SYMLConstType >> isConstantType [
	^ true
]

{ #category : #printing }
SYMLConstType >> printOn: aStream [
	aStream print: decorated; nextPutAll: ' const'
]
