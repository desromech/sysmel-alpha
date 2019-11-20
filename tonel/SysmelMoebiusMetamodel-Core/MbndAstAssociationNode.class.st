Class {
	#name : #MbndAstAssociationNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'key',
		'value'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #testing }
MbndAstAssociationNode >> accept: visitor [
	^ visitor visitAssociationNode: self
]

{ #category : #testing }
MbndAstAssociationNode >> isAssociationNode [
	^ true
]

{ #category : #accessing }
MbndAstAssociationNode >> key [
	^ key
]

{ #category : #accessing }
MbndAstAssociationNode >> key: anObject [
	key := anObject
]

{ #category : #accessing }
MbndAstAssociationNode >> value [
	^ value
]

{ #category : #accessing }
MbndAstAssociationNode >> value: anObject [
	value := anObject
]
