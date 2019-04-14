Class {
	#name : #MbndAstPragmaNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'selector',
		'arguments'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstPragmaNode >> accept: aVisitor [
	^ aVisitor visitPragmaNode: self
]

{ #category : #accessing }
MbndAstPragmaNode >> arguments [
	^ arguments
]

{ #category : #accessing }
MbndAstPragmaNode >> arguments: anObject [
	arguments := anObject
]

{ #category : #testing }
MbndAstPragmaNode >> isPragmaNode [
	^ true
]

{ #category : #accessing }
MbndAstPragmaNode >> selector [
	^ selector
]

{ #category : #accessing }
MbndAstPragmaNode >> selector: anObject [
	selector := anObject
]
