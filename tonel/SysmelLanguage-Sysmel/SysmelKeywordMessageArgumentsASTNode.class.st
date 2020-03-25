Class {
	#name : #SysmelKeywordMessageArgumentsASTNode,
	#superclass : #SysmelAbstractASTNode,
	#instVars : [
		'keywords',
		'arguments'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelKeywordMessageArgumentsASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitKeywordMessageArguments: self
]

{ #category : #generated }
SysmelKeywordMessageArgumentsASTNode >> arguments [
	^ arguments
]

{ #category : #generated }
SysmelKeywordMessageArgumentsASTNode >> arguments: anOrderedCollection [
	self setParents: self arguments to: nil.
	arguments := anOrderedCollection.
	self setParents: self arguments to: self
]

{ #category : #generated }
SysmelKeywordMessageArgumentsASTNode >> compositeNodeVariables [
	^ #(#arguments)
]

{ #category : #generated }
SysmelKeywordMessageArgumentsASTNode >> compositeTokenVariables [
	^ #(#keywords)
]

{ #category : #'generated-initialize-release' }
SysmelKeywordMessageArgumentsASTNode >> initialize [
	super initialize.
	keywords := OrderedCollection new: 2.
	arguments := OrderedCollection new: 2.
]

{ #category : #generated }
SysmelKeywordMessageArgumentsASTNode >> keywords [
	^ keywords
]

{ #category : #generated }
SysmelKeywordMessageArgumentsASTNode >> keywords: anOrderedCollection [
	keywords := anOrderedCollection
]
