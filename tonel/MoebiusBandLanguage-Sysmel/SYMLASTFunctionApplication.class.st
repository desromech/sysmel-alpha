Class {
	#name : #SYMLASTFunctionApplication,
	#superclass : #SYMLASTNode,
	#instVars : [
		'function',
		'arguments'
	],
	#category : #'MoebiusBandLanguage-Sysmel-AST'
}

{ #category : #accessing }
SYMLASTFunctionApplication >> arguments [
	^ arguments
]

{ #category : #accessing }
SYMLASTFunctionApplication >> arguments: anObject [
	arguments := anObject
]

{ #category : #converting }
SYMLASTFunctionApplication >> buildMoebiusAST: builder [
	^ (builder unexpandedSend: #applyWithArguments:
		to: (function buildMoebiusAST: builder)
		withArguments: {builder tuple: (arguments asList collect: [:arg | arg buildMoebiusAST: builder])})
		position: self;
		yourself
]

{ #category : #accessing }
SYMLASTFunctionApplication >> children [
	^ { 
		function.
		#arguments -> {arguments} .
	}
]

{ #category : #accessing }
SYMLASTFunctionApplication >> function [
	^ function
]

{ #category : #accessing }
SYMLASTFunctionApplication >> function: anObject [
	function := anObject
]

{ #category : #printing }
SYMLASTFunctionApplication >> printOn: aStream [
	aStream nextPutAll: 'apply'
]

{ #category : #'as yet unclassified' }
SYMLASTFunctionApplication >> withReceiver: aReceiver [
	function := aReceiver
]
