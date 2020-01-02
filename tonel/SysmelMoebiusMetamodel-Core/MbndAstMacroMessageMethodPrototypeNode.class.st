Class {
	#name : #MbndAstMacroMessageMethodPrototypeNode,
	#superclass : #MbndAstAbstractFunctionPrototypeNode,
	#instVars : [
		'selector'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMacroMessageMethodPrototypeNode >> accept: aVisitor [
	^ aVisitor visitMacroMessagePrototypeNode: self
]

{ #category : #testing }
MbndAstMacroMessageMethodPrototypeNode >> isMacroMessageMethodPrototypeNode [
	^ true
]

{ #category : #accessing }
MbndAstMacroMessageMethodPrototypeNode >> selector [
	^ selector
]

{ #category : #accessing }
MbndAstMacroMessageMethodPrototypeNode >> selector: anObject [
	selector := anObject
]
