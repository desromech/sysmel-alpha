Class {
	#name : #MbndFunctionScope,
	#superclass : #MbndAbstractClosureScope,
	#category : #'SysmelMoebiusMetamodel-Core-Scope'
}

{ #category : #accessing }
MbndFunctionScope >> returnType [
	^ programEntity returnType
]

{ #category : #accessing }
MbndFunctionScope >> returnTypeProgramEntity [
	^ programEntity
]
