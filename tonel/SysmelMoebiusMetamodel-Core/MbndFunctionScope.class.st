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
MbndFunctionScope >> returnType [
	^ programEntity returnType
]

{ #category : #accessing }
MbndFunctionScope >> returnTypeProgramEntity [
	^ programEntity
]
