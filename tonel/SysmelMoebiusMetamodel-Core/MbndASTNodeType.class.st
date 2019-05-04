Class {
	#name : #MbndASTNodeType,
	#superclass : #MbndOpaqueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndASTNodeType class >> typeName [
	^ #_ASTNodeType
]

{ #category : #'testing methods' }
MbndASTNodeType >> isASTNodeType [
	^ true
]
