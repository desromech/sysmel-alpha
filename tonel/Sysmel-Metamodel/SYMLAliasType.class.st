Class {
	#name : #SYMLAliasType,
	#superclass : #SYMLObject,
	#instVars : [
		'target',
		'name',
		'aliased'
	],
	#category : #Sysmel-Metamodel-Types
}

{ #category : #'as yet unclassified' }
SYMLAliasType class >> for: aliasedType name: aName [
	^ self new target: aliasedType target; name: aName; aliased: aliasedType; yourself
]

{ #category : #accessing }
SYMLAliasType >> aliased [
	^ aliased
]

{ #category : #accessing }
SYMLAliasType >> aliased: anObject [
	aliased := anObject
]

{ #category : #'meta evaluation' }
SYMLAliasType >> cleanType [
	^ aliased cleanType
]

{ #category : #'meta evaluation' }
SYMLAliasType >> concreteTypeForNode: aNode [
	^ aliased concreteTypeForNode: aNode
]

{ #category : #'reflective operations' }
SYMLAliasType >> doesNotUnderstand: aMessage [
	^ aMessage sendTo: aliased 
]

{ #category : #'meta methods' }
SYMLAliasType >> metaMethodForMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition [
	^ aliased metaMethodForMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition
]

{ #category : #accessing }
SYMLAliasType >> name [
	^ name
]

{ #category : #accessing }
SYMLAliasType >> name: anObject [
	name := anObject
]

{ #category : #printing }
SYMLAliasType >> printOn: aStream [
	aStream nextPutAll: name
]

{ #category : #'as yet unclassified' }
SYMLAliasType >> ssaType [
	^ aliased ssaType
]

{ #category : #accessing }
SYMLAliasType >> target [
	^ target
]

{ #category : #accessing }
SYMLAliasType >> target: anObject [
	target := anObject
]
