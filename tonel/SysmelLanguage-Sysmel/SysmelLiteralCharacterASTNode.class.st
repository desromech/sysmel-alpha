Class {
	#name : #SysmelLiteralCharacterASTNode,
	#superclass : #SysmelLiteralASTNode,
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelLiteralCharacterASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitLiteralCharacter: self
]
