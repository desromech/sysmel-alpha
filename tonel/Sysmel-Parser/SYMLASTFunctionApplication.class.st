Class {
	#name : #SYMLASTFunctionApplication,
	#superclass : #SYMLASTNode,
	#instVars : [
		'function',
		'arguments'
	],
	#category : #Sysmel-Parser-AST
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
SYMLASTFunctionApplication >> buildAPSG: builder [
	^ (builder send: #applyWithArguments:
		to: (function buildAPSG: builder)
		withArguments: {builder tuple: (arguments asList collect: [:arg | arg buildAPSG: builder])})
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
