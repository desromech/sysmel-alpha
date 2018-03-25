Class {
	#name : #SYMLMetaMethod,
	#superclass : #SYMLProgramEntity,
	#instVars : [
		'compilationTarget'
	],
	#category : #Sysmel-Metamodel-MetaMethods
}

{ #category : #'meta methods' }
SYMLMetaMethod >> analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition [
	^ messageNode copy
		metaMethod: self;
		valueType: anEnvironment compilationTarget voidType;
		yourself
]

{ #category : #testing }
SYMLMetaMethod >> canAnalyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition [
	^ true

]

{ #category : #accessing }
SYMLMetaMethod >> compilationTarget [
	^ compilationTarget
]

{ #category : #accessing }
SYMLMetaMethod >> compilationTarget: anObject [
	compilationTarget := anObject
]

{ #category : #'meta methods' }
SYMLMetaMethod >> evaluateMessage: messageNode inEnvironment: anEnvironment [
	self subclassResponsibility
]

{ #category : #'meta evaluation' }
SYMLMetaMethod >> generateMessage: message ssaCodeWith: builder [
	self subclassResponsibility
]

{ #category : #testing }
SYMLMetaMethod >> isRuleBasedMetaMethod [
	^ false
]
