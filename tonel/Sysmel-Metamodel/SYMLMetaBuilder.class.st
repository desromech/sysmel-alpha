Class {
	#name : #SYMLMetaBuilder,
	#superclass : #SYMLProgramEntity,
	#traits : 'TSYMLType',
	#classTraits : 'TSYMLType classTrait',
	#instVars : [
		'compilationTarget'
	],
	#category : #Sysmel-Metamodel-MetaBuilders
}

{ #category : #'meta methods' }
SYMLMetaBuilder >> analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition [
	self subclassResponsibility
]

{ #category : #accessing }
SYMLMetaBuilder >> compilationTarget [
	^ compilationTarget
]

{ #category : #accessing }
SYMLMetaBuilder >> compilationTarget: anObject [
	compilationTarget := anObject
]

{ #category : #'meta methods' }
SYMLMetaBuilder >> metaMethodForMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition [
	| metaMethod |
	(messageNode receiver evaluateTypeInEnvironment: anEnvironment) ~~ self ifTrue: [ ^ nil ].
	
	metaMethod := self findMetaMethodForSelector: messageNode selector inImageReceiver: self at: aSourcePosition.
	metaMethod ifNotNil: [ ^ metaMethod ].
	
	messageNode arguments ifNotEmpty: [ ^ nil ].
	
	^ self
]

{ #category : #accessing }
SYMLMetaBuilder >> metaType [
	^ self
]
