Class {
	#name : #SYMLConstant,
	#superclass : #SYMLObject,
	#instVars : [
		'value'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #'as yet unclassified' }
SYMLConstant >> analyzeAPSGIdentifierToMe: identifier inEnvironment: anEnvironment [
	^ SYMLAPSGLiteral new
		position: identifier;
		value: (value sysmelValueWithType: anEnvironment compilationTarget booleanType inEnvironment: anEnvironment);
		yourself
]

{ #category : #accessing }
SYMLConstant >> value [
	^ value
]

{ #category : #accessing }
SYMLConstant >> value: anObject [
	value := anObject
]
