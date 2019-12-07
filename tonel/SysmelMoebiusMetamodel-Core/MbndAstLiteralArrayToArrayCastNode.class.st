Class {
	#name : #MbndAstLiteralArrayToArrayCastNode,
	#superclass : #MbndAstSpecificCastNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstLiteralArrayToArrayCastNode >> accept: visitor [
	^ visitor visitLiteralArrayToArrayCastNode: self
]

{ #category : #testing }
MbndAstLiteralArrayToArrayCastNode >> isLiteralArrayToArrayCastNode [
	^ true
]
