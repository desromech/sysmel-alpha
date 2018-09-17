Class {
	#name : #SYMLActivationVariableStore,
	#superclass : #SYMLAbstractValue,
	#instVars : [
		'variable',
		'type',
		'value'
	],
	#category : #'Sysmel-Metamodel-Values'
}

{ #category : #converting }
SYMLActivationVariableStore >> asIncompleteValue [
	^ self
]

{ #category : #converting }
SYMLActivationVariableStore >> asSysmelValueInEnvironment: anEnvironment [
	^ self sysmelValueWithType: type ref inEnvironment: anEnvironment
]

{ #category : #'as yet unclassified' }
SYMLActivationVariableStore >> sysmelPerform: selector withArguments: arguments [
	^ self value sysmelPerform: selector withArguments: arguments
]

{ #category : #initialization }
SYMLActivationVariableStore >> sysmelSetReferencedValue: coercedValue [
	value := coercedValue
]

{ #category : #accessing }
SYMLActivationVariableStore >> type [
	^ type
]

{ #category : #accessing }
SYMLActivationVariableStore >> type: anObject [
	type := anObject
]

{ #category : #accessing }
SYMLActivationVariableStore >> value [
	^ value
]

{ #category : #accessing }
SYMLActivationVariableStore >> value: anObject [
	value := anObject
]

{ #category : #accessing }
SYMLActivationVariableStore >> variable [
	^ variable
]

{ #category : #accessing }
SYMLActivationVariableStore >> variable: anObject [
	variable := anObject
]
