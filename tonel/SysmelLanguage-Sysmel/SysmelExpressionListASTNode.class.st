Class {
	#name : #SysmelExpressionListASTNode,
	#superclass : #SysmelAbstractASTNode,
	#instVars : [
		'expressions',
		'dots'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelExpressionListASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitExpressionList: self
]

{ #category : #generated }
SysmelExpressionListASTNode >> compositeNodeVariables [
	^ #(#expressions)
]

{ #category : #generated }
SysmelExpressionListASTNode >> compositeTokenVariables [
	^ #(#dots)
]

{ #category : #generated }
SysmelExpressionListASTNode >> dots [
	^ dots
]

{ #category : #generated }
SysmelExpressionListASTNode >> dots: anOrderedCollection [
	dots := anOrderedCollection
]

{ #category : #generated }
SysmelExpressionListASTNode >> expressions [
	^ expressions
]

{ #category : #generated }
SysmelExpressionListASTNode >> expressions: anOrderedCollection [
	self setParents: self expressions to: nil.
	expressions := anOrderedCollection.
	self setParents: self expressions to: self
]

{ #category : #'generated-initialize-release' }
SysmelExpressionListASTNode >> initialize [
	super initialize.
	expressions := OrderedCollection new: 2.
	dots := OrderedCollection new: 2.
]
