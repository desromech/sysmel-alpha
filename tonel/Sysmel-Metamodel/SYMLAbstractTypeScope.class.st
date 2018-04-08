Class {
	#name : #SYMLAbstractTypeScope,
	#superclass : #SYMLProgramEntityScope,
	#instVars : [
		'symbols'
	],
	#category : #'Sysmel-Metamodel-Scope'
}

{ #category : #'as yet unclassified' }
SYMLAbstractTypeScope >> definitionProgramEntity [
	^ programEntity
]

{ #category : #accessing }
SYMLAbstractTypeScope >> fillSymbols [
	| module |
	module := programEntity module.
	programEntity class specialMetaSymbols associationsDo: [ :assoc |
		symbols at: assoc key put: (assoc value value: programEntity value: module)
	].

	
]

{ #category : #initialization }
SYMLAbstractTypeScope >> initialize [
	super initialize.
	symbols := Dictionary new.
]

{ #category : #'as yet unclassified' }
SYMLAbstractTypeScope >> lookSymbol: symbol ifPresent: ifPresentBlock [
	symbol == #SelfType ifTrue: [ ^ ifPresentBlock value: programEntity ].
	symbols at: symbol ifPresent: [ :existent | ^ ifPresentBlock value: existent ].
	programEntity lookSymbol: symbol ifPresent: ifPresentBlock
]

{ #category : #accessing }
SYMLAbstractTypeScope >> programEntity: anObject [
	programEntity := anObject.
	self fillSymbols
]
