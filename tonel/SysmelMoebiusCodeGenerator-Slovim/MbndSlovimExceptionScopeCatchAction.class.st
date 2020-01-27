Class {
	#name : #MbndSlovimExceptionScopeCatchAction,
	#superclass : #Object,
	#instVars : [
		'scope',
		'catchActionBlock',
		'node'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #accessing }
MbndSlovimExceptionScopeCatchAction >> catchActionBlock [
	^ catchActionBlock
]

{ #category : #accessing }
MbndSlovimExceptionScopeCatchAction >> catchActionBlock: anObject [
	catchActionBlock := anObject
]

{ #category : #accessing }
MbndSlovimExceptionScopeCatchAction >> node [
	^ node
]

{ #category : #accessing }
MbndSlovimExceptionScopeCatchAction >> node: anObject [
	node := anObject
]

{ #category : #accessing }
MbndSlovimExceptionScopeCatchAction >> scope [
	^ scope
]

{ #category : #accessing }
MbndSlovimExceptionScopeCatchAction >> scope: anObject [
	scope := anObject
]
