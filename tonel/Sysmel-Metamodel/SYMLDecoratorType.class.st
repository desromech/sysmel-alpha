Class {
	#name : #SYMLDecoratorType,
	#superclass : #SYMLType,
	#instVars : [
		'decorated'
	],
	#category : #Sysmel-Metamodel-Types
}

{ #category : #'as yet unclassified' }
SYMLDecoratorType >> buildSSAType [
	^ decorated ssaType
]

{ #category : #'meta evaluation' }
SYMLDecoratorType >> cleanType [
	^ decorated cleanType
]

{ #category : #'meta evaluation' }
SYMLDecoratorType >> concreteTypeForNode: aNode [
	^ decorated concreteTypeForNode: aNode
]

{ #category : #accessing }
SYMLDecoratorType >> decorated [
	^ decorated
]

{ #category : #accessing }
SYMLDecoratorType >> decorated: anObject [
	decorated := anObject
]

{ #category : #testing }
SYMLDecoratorType >> isDecoratorType [
	^ true
]
