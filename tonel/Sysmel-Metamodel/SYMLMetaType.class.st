Class {
	#name : #SYMLMetaType,
	#superclass : #SYMLCompilationTimeType,
	#instVars : [
		'instanceType'
	],
	#category : #Sysmel-Metamodel-Types
}

{ #category : #accessing }
SYMLMetaType >> instanceType [
	^ instanceType
]

{ #category : #accessing }
SYMLMetaType >> instanceType: anObject [
	instanceType := anObject
]

{ #category : #testing }
SYMLMetaType >> isMetaType [
	^ true
]

{ #category : #'meta methods' }
SYMLMetaType >> metaMethodForMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition [
	^ self findMetaMethodForSelector: messageNode selector inImageReceiver: instanceType value at: aSourcePosition
]

{ #category : #printing }
SYMLMetaType >> printOn: aStream [
	aStream print: instanceType; nextPutAll: ' metaType'
]
