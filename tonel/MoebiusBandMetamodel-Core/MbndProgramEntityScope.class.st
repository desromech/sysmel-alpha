Class {
	#name : #MbndProgramEntityScope,
	#superclass : #MbndAbstractScope,
	#instVars : [
		'programEntity'
	],
	#category : #'MoebiusBandMetamodel-Core-Scope'
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

{ #category : #accessing }
MbndProgramEntityScope >> programEntity [
	^ programEntity
]

{ #category : #accessing }
MbndProgramEntityScope >> programEntity: anObject [
	programEntity := anObject
]
