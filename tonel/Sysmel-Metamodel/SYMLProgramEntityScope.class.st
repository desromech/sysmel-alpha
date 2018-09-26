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
	symbol == #__thisProgramEntityScope ifTrue: [ ^ ifPresentBlock value: self ].
	symbol == #__thisProgramEntity ifTrue: [ ^ ifPresentBlock value: programEntity ].

	^ programEntity lookSymbol: symbol ifPresent: ifPresentBlock
]

{ #category : #accessing }
SYMLProgramEntityScope >> programEntity [
	^ programEntity
]

{ #category : #accessing }
SYMLProgramEntityScope >> programEntity: anObject [
	programEntity := anObject
]

{ #category : #enumerating }
SYMLProgramEntityScope >> usedNamespacesDo: aBlock [
	programEntity usedAndExportedNamespacesDo: aBlock
]
