Class {
	#name : #SysmelLiteralFloatASTNode,
	#superclass : #SysmelLiteralASTNode,
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelLiteralFloatASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitLiteralFloat: self
]
