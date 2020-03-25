Class {
	#name : #SysmelAbstractASTNode,
	#superclass : #SmaCCParseNode,
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelAbstractASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitAbstract: self
]
