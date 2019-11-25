Class {
	#name : #MbndAstGCVariableDataArrayElementReferenceNode,
	#superclass : #MbndAstSubscriptElementReferenceNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstGCVariableDataArrayElementReferenceNode >> accept: aVisitor [
	^ aVisitor visitGCVariableDataArrayElementReferenceNode: self
]

{ #category : #testing }
MbndAstGCVariableDataArrayElementReferenceNode >> isGCVariableDataArrayElementReferenceNode [
	^ true
]
