Class {
	#name : #SYMLProgramEntityScope,
	#superclass : #SYMLAbstractScope,
	#instVars : [
		'programEntity'
	],
	#category : #'Sysmel-Metamodel-Scope'
}

{ #category : #testing }
SYMLProgramEntityScope >> isImmediateEnvironment [
	^ true
]

{ #category : #'as yet unclassified' }
SYMLProgramEntityScope >> lookSymbol: symbol ifPresent: ifPresentBlock [
	programEntity lookSymbol: symbol ifPresent: ifPresentBlock
]

{ #category : #accessing }
SYMLProgramEntityScope >> programEntity [
	^ programEntity
]

{ #category : #accessing }
SYMLProgramEntityScope >> programEntity: anObject [
	programEntity := anObject
]
