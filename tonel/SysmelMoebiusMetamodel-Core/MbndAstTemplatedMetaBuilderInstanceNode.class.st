Class {
	#name : #MbndAstTemplatedMetaBuilderInstanceNode,
	#superclass : #MbndAstMetaBuilderInstanceNode,
	#instVars : [
		'templateNode'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #'as yet unclassified' }
MbndAstTemplatedMetaBuilderInstanceNode >> accept: aVisitor [
	^ aVisitor visitTemplatedMetaBuilderInstanceNode: self
]

{ #category : #'as yet unclassified' }
MbndAstTemplatedMetaBuilderInstanceNode >> isTemplatedMetaBuilderInstanceNode [
	^ true
]

{ #category : #accessing }
MbndAstTemplatedMetaBuilderInstanceNode >> templateNode [
	^ templateNode
]

{ #category : #accessing }
MbndAstTemplatedMetaBuilderInstanceNode >> templateNode: anObject [
	templateNode := anObject
]
