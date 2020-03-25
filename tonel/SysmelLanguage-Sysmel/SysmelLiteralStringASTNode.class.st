Class {
	#name : #SysmelLiteralStringASTNode,
	#superclass : #SysmelLiteralASTNode,
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelLiteralStringASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitLiteralString: self
]
