Class {
	#name : #MbndAstVectorSetElementsNode,
	#superclass : #MbndAstAbstractVectorAccessNode,
	#instVars : [
		'values'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstVectorSetElementsNode >> accept: visitor [
	^ visitor visitVectorSetElementsNode: self
]

{ #category : #testing }
MbndAstVectorSetElementsNode >> isVectorSetElementsNode [
	^ true
]

{ #category : #accessing }
MbndAstVectorSetElementsNode >> values [
	^ values
]

{ #category : #accessing }
MbndAstVectorSetElementsNode >> values: anObject [
	values := anObject
]
