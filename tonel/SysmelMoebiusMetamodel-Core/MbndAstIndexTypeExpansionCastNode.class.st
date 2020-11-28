Class {
	#name : #MbndAstIndexTypeExpansionCastNode,
	#superclass : #MbndAstSpecificCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #testing }
MbndAstIndexTypeExpansionCastNode >> accept: visitor [
	^ visitor visitIndexTypeExpansionCastNode: self
]

{ #category : #testing }
MbndAstIndexTypeExpansionCastNode >> isIndexTypeExpansionCastNode [
	^ true
]
