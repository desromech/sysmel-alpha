Class {
	#name : #SYMLProxy,
	#superclass : #Object,
	#instVars : [
		'__interpreterObject'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #accessing }
SYMLProxy >> __interpreterObject [
	^ __interpreterObject
]

{ #category : #accessing }
SYMLProxy >> __interpreterObject: anObject [
	__interpreterObject := anObject
]

{ #category : #'reflective operations' }
SYMLProxy >> doesNotUnderstand: aMessage [
	^ __interpreterObject sysmelPerform: aMessage selector withArguments: aMessage arguments
]
