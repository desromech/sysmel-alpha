Class {
	#name : #SysmelEntryASTNode,
	#superclass : #SysmelAbstractASTNode,
	#instVars : [
		'expressions',
		'periodTokens'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelEntryASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitEntry: self
]

{ #category : #generated }
SysmelEntryASTNode >> compositeNodeVariables [
	^ #(#expressions)
]

{ #category : #generated }
SysmelEntryASTNode >> compositeTokenVariables [
	^ #(#periodTokens)
]

{ #category : #generated }
SysmelEntryASTNode >> expressions [
	^ expressions
]

{ #category : #generated }
SysmelEntryASTNode >> expressions: anOrderedCollection [
	self setParents: self expressions to: nil.
	expressions := anOrderedCollection.
	self setParents: self expressions to: self
]

{ #category : #'generated-initialize-release' }
SysmelEntryASTNode >> initialize [
	super initialize.
	expressions := OrderedCollection new: 2.
	periodTokens := OrderedCollection new: 2.
]

{ #category : #generated }
SysmelEntryASTNode >> periodTokens [
	^ periodTokens
]

{ #category : #generated }
SysmelEntryASTNode >> periodTokens: anOrderedCollection [
	periodTokens := anOrderedCollection
]
