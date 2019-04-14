"
I am a sequence of expression. I evaluate all of my elements in sequence, and then I return the value of my last element.
"
Class {
	#name : #MbndAstSequenceNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'pragmas',
		'elements'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstSequenceNode >> accept: aVisitor [
	^ aVisitor visitSequenceNode: self
]

{ #category : #accessing }
MbndAstSequenceNode >> elements [
	^ elements
]

{ #category : #accessing }
MbndAstSequenceNode >> elements: anObject [
	elements := anObject
]

{ #category : #initialization }
MbndAstSequenceNode >> initialize [
	super initialize.
	pragmas := #().
	
]

{ #category : #testing }
MbndAstSequenceNode >> isSequenceNode [
	^ true
]

{ #category : #accessing }
MbndAstSequenceNode >> pragmas [
	^ pragmas
]

{ #category : #accessing }
MbndAstSequenceNode >> pragmas: anObject [
	pragmas := anObject
]
