Class {
	#name : #SYMLMetaMethodPredicatedRule,
	#superclass : #SYMLMetaMethodRule,
	#instVars : [
		'condition',
		'delegatedMetaMethod'
	],
	#category : #Sysmel-Metamodel-MetaMethods
}

{ #category : #'meta methods' }
SYMLMetaMethodPredicatedRule >> analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition [
	^ delegatedMetaMethod analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition
]

{ #category : #accessing }
SYMLMetaMethodPredicatedRule >> condition [
	^ condition
]

{ #category : #accessing }
SYMLMetaMethodPredicatedRule >> condition: anObject [
	condition := anObject
]

{ #category : #accessing }
SYMLMetaMethodPredicatedRule >> delegatedMetaMethod [
	^ delegatedMetaMethod
]

{ #category : #accessing }
SYMLMetaMethodPredicatedRule >> delegatedMetaMethod: anObject [
	delegatedMetaMethod := anObject
]

{ #category : #testing }
SYMLMetaMethodPredicatedRule >> matchesMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition [
	^ condition cull: messageNode cull: anEnvironment cull: aSourcePosition
]
