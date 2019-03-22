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

{ #category : #accessing }
MbndProgramEntityScope >> programEntity [
	^ programEntity
]

{ #category : #accessing }
MbndProgramEntityScope >> programEntity: anObject [
	programEntity := anObject
]
