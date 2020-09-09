Class {
	#name : #MbndPendingDefinitionUsedTraits,
	#superclass : #MbndPendingDefinitionFragment,
	#instVars : [
		'type'
	],
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #'public access' }
MbndPendingDefinitionUsedTraits >> evaluate [
	self halt
]

{ #category : #testing }
MbndPendingDefinitionUsedTraits >> isUsedTraits [
	^ false
]

{ #category : #accessing }
MbndPendingDefinitionUsedTraits >> priority [
	^ 2
]

{ #category : #accessing }
MbndPendingDefinitionUsedTraits >> type [
	^ type
]

{ #category : #accessing }
MbndPendingDefinitionUsedTraits >> type: anObject [
	type := anObject
]
