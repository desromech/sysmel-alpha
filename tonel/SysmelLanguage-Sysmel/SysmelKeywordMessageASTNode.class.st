Class {
	#name : #SysmelKeywordMessageASTNode,
	#superclass : #SysmelExpressionASTNode,
	#instVars : [
		'keywords',
		'arguments'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelKeywordMessageASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitKeywordMessage: self
]

{ #category : #generated }
SysmelKeywordMessageASTNode >> arguments [
	^ arguments
]

{ #category : #generated }
SysmelKeywordMessageASTNode >> arguments: anOrderedCollection [
	self setParents: self arguments to: nil.
	arguments := anOrderedCollection.
	self setParents: self arguments to: self
]

{ #category : #generated }
SysmelKeywordMessageASTNode >> compositeNodeVariables [
	^ #(#arguments)
]

{ #category : #generated }
SysmelKeywordMessageASTNode >> compositeTokenVariables [
	^ #(#keywords)
]

{ #category : #'generated-initialize-release' }
SysmelKeywordMessageASTNode >> initialize [
	super initialize.
	keywords := OrderedCollection new: 2.
	arguments := OrderedCollection new: 2.
]

{ #category : #generated }
SysmelKeywordMessageASTNode >> keywords [
	^ keywords
]

{ #category : #generated }
SysmelKeywordMessageASTNode >> keywords: anOrderedCollection [
	keywords := anOrderedCollection
]
