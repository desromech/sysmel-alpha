Class {
	#name : #SYMLMessageSendMetaMethod,
	#superclass : #SYMLMetaMethod,
	#instVars : [
		'receiverAccessor',
		'rewrite'
	],
	#category : #Sysmel-Metamodel-MetaMethods
}

{ #category : #'meta methods' }
SYMLMessageSendMetaMethod >> analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition [
	| receiver receiverType |
	receiver := messageNode receiver.
	receiverType := receiver evaluateTypeInEnvironment: anEnvironment.
	
	(receiverType isCompilerObjectType or: [receiverType isMetaType]) ifTrue: [
		^ self evaluateCompileTimeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition	
	].

	^ messageNode copy
		metaMethod: self;
		valueType: anEnvironment compilationTarget voidType;
		yourself
]

{ #category : #'meta methods' }
SYMLMessageSendMetaMethod >> evaluateCompileTimeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition [	
	| evaluatedValue |
	evaluatedValue := self evaluateMessage: messageNode inEnvironment: anEnvironment.
	rewrite ifTrue: [
		self assert: evaluatedValue type isAPSGNode.
		^ evaluatedValue value
	].
	^ messageNode buildLiteralWithValue: evaluatedValue

]

{ #category : #accessing }
SYMLMessageSendMetaMethod >> receiverAccessor [
	^ receiverAccessor
]

{ #category : #accessing }
SYMLMessageSendMetaMethod >> receiverAccessor: anObject [
	receiverAccessor := anObject
]

{ #category : #accessing }
SYMLMessageSendMetaMethod >> rewrite [
	^ rewrite
]

{ #category : #accessing }
SYMLMessageSendMetaMethod >> rewrite: anObject [
	rewrite := anObject
]
