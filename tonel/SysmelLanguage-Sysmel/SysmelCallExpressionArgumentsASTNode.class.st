Class {
	#name : #SysmelCallExpressionArgumentsASTNode,
	#superclass : #SysmelAbstractASTNode,
	#instVars : [
		'arguments',
		'commaTokens'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelCallExpressionArgumentsASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitCallExpressionArguments: self
]

{ #category : #generated }
SysmelCallExpressionArgumentsASTNode >> arguments [
	^ arguments
]

{ #category : #generated }
SysmelCallExpressionArgumentsASTNode >> arguments: anOrderedCollection [
	self setParents: self arguments to: nil.
	arguments := anOrderedCollection.
	self setParents: self arguments to: self
]

{ #category : #generated }
SysmelCallExpressionArgumentsASTNode >> commaTokens [
	^ commaTokens
]

{ #category : #generated }
SysmelCallExpressionArgumentsASTNode >> commaTokens: anOrderedCollection [
	commaTokens := anOrderedCollection
]

{ #category : #generated }
SysmelCallExpressionArgumentsASTNode >> compositeNodeVariables [
	^ #(#arguments)
]

{ #category : #generated }
SysmelCallExpressionArgumentsASTNode >> compositeTokenVariables [
	^ #(#commaTokens)
]

{ #category : #'generated-initialize-release' }
SysmelCallExpressionArgumentsASTNode >> initialize [
	super initialize.
	arguments := OrderedCollection new: 2.
	commaTokens := OrderedCollection new: 2.
]
