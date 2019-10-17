Class {
	#name : #MbndPublicProgramEntityAccessor,
	#superclass : #MbndAbstractMacro,
	#instVars : [
		'programEntity'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Macro'
}

{ #category : #'as yet unclassified' }
MbndPublicProgramEntityAccessor >> expandMessageNode: node with: analyzer [
	^ programEntity analyzeReferenceNode: node with: analyzer
]

{ #category : #accessing }
MbndPublicProgramEntityAccessor >> programEntity [
	^ programEntity
]

{ #category : #accessing }
MbndPublicProgramEntityAccessor >> programEntity: anObject [
	programEntity := anObject
]
