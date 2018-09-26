Class {
	#name : #SYMLObjectInstance,
	#superclass : #SYMLObjectWithType,
	#instVars : [
		'type'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #converting }
SYMLObjectInstance >> asSysmelValueInEnvironment: anEnvironment [
	^ self sysmelValueWithType: type inEnvironment: anEnvironment
]

{ #category : #'as yet unclassified' }
SYMLObjectInstance >> createNonInlineLiteralObjectForSysmelObjectModel: objectModel [
	^ self
]

{ #category : #accessing }
SYMLObjectInstance >> definitionEnvironment [
	^ type definitionEnvironment
]

{ #category : #'semantic analysis' }
SYMLObjectInstance >> evaluateMetaObjectTypeInEnvironment: anEnvironment [
	^ type
]

{ #category : #converting }
SYMLObjectInstance >> generateSSAReferenceWith: builder [
	self subclassResponsibility
]

{ #category : #slots }
SYMLObjectInstance >> slotNamed: slotName [
	^ self slots at: (type lookSymbol: slotName) slotIndex + 1
]

{ #category : #slots }
SYMLObjectInstance >> slotNamed: slotName put: aValue [
	^ self slots at: (type lookSymbol: slotName) slotIndex + 1 put: aValue
]

{ #category : #accessing }
SYMLObjectInstance >> ssaGlobalVariable [
	^ nil
]

{ #category : #accessing }
SYMLObjectInstance >> type [
	^ type
]

{ #category : #accessing }
SYMLObjectInstance >> type: anObject [
	type := anObject
]
