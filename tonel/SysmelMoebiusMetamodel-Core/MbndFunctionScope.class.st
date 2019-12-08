Class {
	#name : #MbndFunctionScope,
	#superclass : #MbndAbstractClosureScope,
	#category : #'SysmelMoebiusMetamodel-Core-Scope'
}

{ #category : #testing }
MbndFunctionScope >> isInFunctionScope [
	^ true
]

{ #category : #accessing }
MbndFunctionScope >> returnType [
	^ programEntity returnType
]

{ #category : #accessing }
MbndFunctionScope >> returnTypeProgramEntity [
	^ programEntity
]
