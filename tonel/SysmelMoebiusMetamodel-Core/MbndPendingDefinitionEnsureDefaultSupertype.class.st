Class {
	#name : #MbndPendingDefinitionEnsureDefaultSupertype,
	#superclass : #MbndPendingDefinitionFragment,
	#instVars : [
		'type'
	],
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #'public access' }
MbndPendingDefinitionEnsureDefaultSupertype >> evaluate [
	(type supertype isTrait or: [type supertype isNil]) ifTrue: [
		module compilationTarget defaultGCClassSuperClass ifNotNil: [ :defaultSuperType |
			type setSupertypeFromDefinition: defaultSuperType
		].
	].
]

{ #category : #testing }
MbndPendingDefinitionEnsureDefaultSupertype >> isSupertypeDefinition [
	^ true
]

{ #category : #accessing }
MbndPendingDefinitionEnsureDefaultSupertype >> priority [
	^ 1
]

{ #category : #accessing }
MbndPendingDefinitionEnsureDefaultSupertype >> type [
	^ type
]

{ #category : #accessing }
MbndPendingDefinitionEnsureDefaultSupertype >> type: anObject [
	type := anObject
]
