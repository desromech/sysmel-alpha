Class {
	#name : #MbndASTNodeType,
	#superclass : #MbndAbstractSpecificCompilerObjectType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndASTNodeType class >> typeName [
	^ #_ASTNodeType
]

{ #category : #accessing }
MbndASTNodeType >> behavior [
	^ MbndAstNode
]

{ #category : #'testing methods' }
MbndASTNodeType >> isASTNodeType [
	^ true
]
