Class {
	#name : #SYMLValue,
	#superclass : #Object,
	#instVars : [
		'value',
		'type',
		'environment'
	],
	#category : #Sysmel-Metamodel-Types
}

{ #category : #converting }
SYMLValue >> asSysmelValueInEnvironment: anEnvironment [
	^ self
]

{ #category : #accessing }
SYMLValue >> environment [
	^ environment
]

{ #category : #accessing }
SYMLValue >> environment: anObject [
	environment := anObject
]

{ #category : #'public access' }
SYMLValue >> evaluate [
	^ environment ifNotNil: [ self evaluateInEnvironment: environment ] ifNil: [ self ]
]

{ #category : #'meta evaluation' }
SYMLValue >> evaluateInEnvironment: anEnvironment [
	^ type evaluateValue: self inEnvironment: anEnvironment
]

{ #category : #'meta evaluation' }
SYMLValue >> evaluateValueWithoutReferencesIn: anEnvironment [
	^ type evaluateValueWithoutReferences: self inEnvironment: anEnvironment
]

{ #category : #'meta evaluation' }
SYMLValue >> generateSSACodeWith: aBuilder [
	^ type generateSSAValue: value withBuilder: aBuilder
]

{ #category : #printing }
SYMLValue >> printOn: aStream [
	aStream print: value; nextPutAll: ' sysmelValueWithType: '; print: type
]

{ #category : #accessing }
SYMLValue >> type [
	^ type
]

{ #category : #accessing }
SYMLValue >> type: anObject [
	type := anObject
]

{ #category : #accessing }
SYMLValue >> value [
	^ value
]

{ #category : #accessing }
SYMLValue >> value: anObject [
	value := anObject
]

{ #category : #'meta evaluation' }
SYMLValue >> valueTypeIn: evaluationEnvironment [
	^ type evaluateType: self inEnvironment: evaluationEnvironment
]
