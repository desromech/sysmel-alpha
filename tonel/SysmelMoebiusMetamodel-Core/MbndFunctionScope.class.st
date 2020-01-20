Class {
	#name : #MbndFunctionScope,
	#superclass : #MbndAbstractClosureScope,
	#category : #'SysmelMoebiusMetamodel-Core-Scope'
}

{ #category : #testing }
MbndFunctionScope >> isInFunctionScope [
	^ true
]

{ #category : #'as yet unclassified' }
MbndFunctionScope >> lookupFunctionProgramEntity [
	^ programEntity
]

{ #category : #accessing }
MbndFunctionScope >> nonLocalReturnType [
	(parent isNil or: [programEntity isNonLocalReturnTargetEntity]) ifTrue: [ ^ self returnType ].
	^ parent nonLocalReturnType
]

{ #category : #accessing }
MbndFunctionScope >> nonLocalReturnTypeProgramEntity [
	(parent isNil or: [programEntity isNonLocalReturnTargetEntity]) ifTrue: [ ^ self returnTypeProgramEntity ].
	^ parent nonLocalReturnTypeProgramEntity 
]

{ #category : #accessing }
MbndFunctionScope >> returnType [
	^ programEntity returnType
]

{ #category : #accessing }
MbndFunctionScope >> returnTypeProgramEntity [
	^ programEntity
]
