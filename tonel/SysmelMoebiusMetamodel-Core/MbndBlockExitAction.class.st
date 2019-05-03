Class {
	#name : #MbndBlockExitAction,
	#superclass : #Exception,
	#instVars : [
		'blockContext'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Exceptions'
}

{ #category : #accessing }
MbndBlockExitAction >> blockContext [
	^ blockContext
]

{ #category : #accessing }
MbndBlockExitAction >> blockContext: anObject [
	blockContext := anObject
]

{ #category : #testing }
MbndBlockExitAction >> isBreakAction [
	^ false
]

{ #category : #testing }
MbndBlockExitAction >> isContinueAction [
	^ false
]
