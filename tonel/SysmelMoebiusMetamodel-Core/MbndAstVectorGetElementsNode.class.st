Class {
	#name : #MbndAstVectorGetElementsNode,
	#superclass : #MbndAstAbstractVectorAccessNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstVectorGetElementsNode >> accept: visitor [
	^ visitor visitVectorGetElementsNode: self
]

{ #category : #testing }
MbndAstVectorGetElementsNode >> isVectorGetElementsNode [
	^ true
]
