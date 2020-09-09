Class {
	#name : #MbndAstThisContextReferenceNode,
	#superclass : #MbndAstNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstThisContextReferenceNode >> accept: visitor [
	^ visitor visitThisContextReferenceNode: self
]

{ #category : #testing }
MbndAstThisContextReferenceNode >> isThisContextReferenceNode [
	^ true
]
