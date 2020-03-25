Class {
	#name : #SysmelChainedMessageASTNode,
	#superclass : #SysmelAbstractASTNode,
	#instVars : [
		'keywords',
		'arguments',
		'selector'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelChainedMessageASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitChainedMessage: self
]

{ #category : #generated }
SysmelChainedMessageASTNode >> arguments [
	^ arguments
]

{ #category : #generated }
SysmelChainedMessageASTNode >> arguments: anOrderedCollection [
	self setParents: self arguments to: nil.
	arguments := anOrderedCollection.
	self setParents: self arguments to: self
]

{ #category : #generated }
SysmelChainedMessageASTNode >> compositeNodeVariables [
	^ #(#arguments)
]

{ #category : #generated }
SysmelChainedMessageASTNode >> compositeTokenVariables [
	^ #(#keywords)
]

{ #category : #'generated-initialize-release' }
SysmelChainedMessageASTNode >> initialize [
	super initialize.
	keywords := OrderedCollection new: 2.
	arguments := OrderedCollection new: 2.
]

{ #category : #generated }
SysmelChainedMessageASTNode >> keywords [
	^ keywords
]

{ #category : #generated }
SysmelChainedMessageASTNode >> keywords: anOrderedCollection [
	keywords := anOrderedCollection
]

{ #category : #generated }
SysmelChainedMessageASTNode >> selector [
	^ selector
]

{ #category : #generated }
SysmelChainedMessageASTNode >> selector: aSmaCCToken [
	selector := aSmaCCToken
]

{ #category : #generated }
SysmelChainedMessageASTNode >> tokenVariables [
	^ #(#selector)
]
