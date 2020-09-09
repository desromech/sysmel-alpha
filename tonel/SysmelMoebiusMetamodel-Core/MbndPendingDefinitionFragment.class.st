Class {
	#name : #MbndPendingDefinitionFragment,
	#superclass : #Object,
	#traits : 'TMbndObject',
	#classTraits : 'TMbndObject classTrait',
	#instVars : [
		'module',
		'node',
		'scope'
	],
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #'public access' }
MbndPendingDefinitionFragment >> evaluate [
	self subclassResponsibility
]

{ #category : #testing }
MbndPendingDefinitionFragment >> isPoolDictionaries [
	^ false
]

{ #category : #testing }
MbndPendingDefinitionFragment >> isSupertypeDefinition [
	^ false
]

{ #category : #testing }
MbndPendingDefinitionFragment >> isUsedTraits [
	^ false
]

{ #category : #accessing }
MbndPendingDefinitionFragment >> module [
	^ module
]

{ #category : #accessing }
MbndPendingDefinitionFragment >> module: anObject [
	module := anObject
]

{ #category : #accessing }
MbndPendingDefinitionFragment >> node [
	^ node
]

{ #category : #accessing }
MbndPendingDefinitionFragment >> node: anObject [
	node := anObject
]

{ #category : #accessing }
MbndPendingDefinitionFragment >> priority [
	^ self subclassResponsibility
]

{ #category : #accessing }
MbndPendingDefinitionFragment >> scope [
	^ scope
]

{ #category : #accessing }
MbndPendingDefinitionFragment >> scope: anObject [
	scope := anObject
]
