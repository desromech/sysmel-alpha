Class {
	#name : #SysmelCommaExpressionASTNode,
	#superclass : #SysmelExpressionASTNode,
	#instVars : [
		'expressions',
		'commas'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelCommaExpressionASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitCommaExpression: self
]

{ #category : #generated }
SysmelCommaExpressionASTNode >> commas [
	^ commas
]

{ #category : #generated }
SysmelCommaExpressionASTNode >> commas: anOrderedCollection [
	commas := anOrderedCollection
]

{ #category : #generated }
SysmelCommaExpressionASTNode >> compositeNodeVariables [
	^ #(#expressions)
]

{ #category : #generated }
SysmelCommaExpressionASTNode >> compositeTokenVariables [
	^ #(#commas)
]

{ #category : #generated }
SysmelCommaExpressionASTNode >> expressions [
	^ expressions
]

{ #category : #generated }
SysmelCommaExpressionASTNode >> expressions: anOrderedCollection [
	self setParents: self expressions to: nil.
	expressions := anOrderedCollection.
	self setParents: self expressions to: self
]

{ #category : #'generated-initialize-release' }
SysmelCommaExpressionASTNode >> initialize [
	super initialize.
	expressions := OrderedCollection new: 2.
	commas := OrderedCollection new: 2.
]
