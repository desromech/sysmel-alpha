Class {
	#name : #SysmelLiteralIntegerASTNode,
	#superclass : #SysmelLiteralASTNode,
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelLiteralIntegerASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitLiteralInteger: self
]
