Class {
	#name : #MbndAstDictionaryNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'elements'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstDictionaryNode >> accept: visitor [
	^ visitor visitDictionaryNode: self
]

{ #category : #accessing }
MbndAstDictionaryNode >> elements [
	^ elements
]

{ #category : #accessing }
MbndAstDictionaryNode >> elements: anObject [
	elements := anObject
]

{ #category : #visiting }
MbndAstDictionaryNode >> isDictionaryNode [
	^ true
]
