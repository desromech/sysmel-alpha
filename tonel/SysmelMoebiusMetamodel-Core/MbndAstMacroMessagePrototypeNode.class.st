Class {
	#name : #MbndAstMacroMessagePrototypeNode,
	#superclass : #MbndAstAbstractFunctionPrototypeNode,
	#instVars : [
		'selector'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMacroMessagePrototypeNode >> accept: aVisitor [
	^ aVisitor visitMacroMessagePrototypeNode: self
]

{ #category : #testing }
MbndAstMacroMessagePrototypeNode >> isMacroMessagePrototypeNode [
	^ true
]

{ #category : #accessing }
MbndAstMacroMessagePrototypeNode >> selector [
	^ selector
]

{ #category : #accessing }
MbndAstMacroMessagePrototypeNode >> selector: anObject [
	selector := anObject
]
