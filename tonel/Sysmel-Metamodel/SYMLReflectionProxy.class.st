Class {
	#name : #SYMLReflectionProxy,
	#superclass : #SYMLObjectWithType,
	#instVars : [
		'proxiedObject',
		'ssaInstanceValue',
		'objectInstance'
	],
	#category : #'Sysmel-Metamodel-Reflection'
}

{ #category : #'instance creation' }
SYMLReflectionProxy class >> for: anObject [
	^ self new proxiedObject: anObject
]

{ #category : #converting }
SYMLReflectionProxy >> asSysmelValueInEnvironment: anEnvironment [
	^ self sysmelValueWithType: self type inEnvironment: anEnvironment
]

{ #category : #accessing }
SYMLReflectionProxy >> definitionEnvironment [
	^ self type definitionEnvironment
]

{ #category : #'semantic analysis' }
SYMLReflectionProxy >> evaluateMetaObjectTypeInEnvironment: anEnvironment [
	^ self objectInstance evaluateMetaObjectTypeInEnvironment: anEnvironment
]

{ #category : #'as yet unclassified' }
SYMLReflectionProxy >> generateObjectInstance [
	self subclassResponsibility
]

{ #category : #'code generation' }
SYMLReflectionProxy >> generateSSAReferenceWith: builder [
	^ self objectInstance generateSSAReferenceWith: builder
]

{ #category : #'as yet unclassified' }
SYMLReflectionProxy >> generateSSAValueForModule: aModule [
	^ self objectInstance generateSSAValueForModule: aModule
]

{ #category : #accessing }
SYMLReflectionProxy >> objectInstance [
	^ objectInstance ifNil: [ objectInstance := self generateObjectInstance ]
]

{ #category : #accessing }
SYMLReflectionProxy >> proxiedObject [
	^ proxiedObject
]

{ #category : #accessing }
SYMLReflectionProxy >> proxiedObject: anObject [
	proxiedObject := anObject
]

{ #category : #accessing }
SYMLReflectionProxy >> slots [
	^ self objectInstance slots
]
