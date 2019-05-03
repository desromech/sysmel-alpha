Class {
	#name : #MbndAstSubscriptElementReferenceNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'container',
		'index',
		'isOneBasedIndex'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstSubscriptElementReferenceNode >> container [
	^ container
]

{ #category : #accessing }
MbndAstSubscriptElementReferenceNode >> container: anObject [
	container := anObject
]

{ #category : #accessing }
MbndAstSubscriptElementReferenceNode >> index [
	^ index
]

{ #category : #accessing }
MbndAstSubscriptElementReferenceNode >> index: anObject [
	index := anObject
]

{ #category : #initialization }
MbndAstSubscriptElementReferenceNode >> initialize [
	super initialize.
	isOneBasedIndex := false.
]

{ #category : #accessing }
MbndAstSubscriptElementReferenceNode >> isOneBasedIndex [
	^ isOneBasedIndex
]

{ #category : #accessing }
MbndAstSubscriptElementReferenceNode >> isOneBasedIndex: anObject [
	isOneBasedIndex := anObject
]

{ #category : #testing }
MbndAstSubscriptElementReferenceNode >> isSubscriptElementReferenceNode [
	^ true
]
