Class {
	#name : #SysmelLiteralSymbolASTNode,
	#superclass : #SysmelLiteralASTNode,
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelLiteralSymbolASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitLiteralSymbol: self
]
