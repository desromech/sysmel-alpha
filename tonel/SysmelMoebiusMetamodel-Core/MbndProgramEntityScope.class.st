Class {
	#name : #MbndProgramEntityScope,
	#superclass : #MbndAbstractScope,
	#instVars : [
		'programEntity'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Scope'
}

{ #category : #accessing }
MbndProgramEntityScope >> compilationTarget [
	^ programEntity compilationTarget
]

{ #category : #'macro expansion' }
MbndProgramEntityScope >> lookupMacroSelector: selector [
	(programEntity lookupMacroSelector: selector) ifNotNil: [ :macroMethod |
		^ macroMethod
	].

	^ super lookupMacroSelector: selector
]

{ #category : #'macro expansion' }
MbndProgramEntityScope >> lookupOverloadedSelector: selector [
	(programEntity lookupOverloadedSelector: selector) ifNotNil: [ :method |
		^ method
	].

	^ super lookupOverloadedSelector: selector
]

{ #category : #'as yet unclassified' }
MbndProgramEntityScope >> lookupProgramEntityForNewDefinitions [
	^ programEntity
]

{ #category : #'macro expansion' }
MbndProgramEntityScope >> lookupSymbol: aSymbol [
	^ programEntity lookupSymbol: aSymbol
]

{ #category : #accessing }
MbndProgramEntityScope >> programEntity [
	^ programEntity
]

{ #category : #accessing }
MbndProgramEntityScope >> programEntity: anObject [
	programEntity := anObject
]
