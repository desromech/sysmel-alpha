Class {
	#name : #MbndAstLexicalScopeNode,
	#superclass : #MbndAstCleanUpScopeNode,
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstLexicalScopeNode >> accept: aVisitor [
	^ aVisitor visitLexicalScopeNode: self
]

{ #category : #testing }
MbndAstLexicalScopeNode >> isLexicalScopeNode [
	^ true
]

{ #category : #'as yet unclassified' }
MbndAstLexicalScopeNode >> lexicallyScoped [
	^ self
]
