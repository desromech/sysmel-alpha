Class {
	#name : #MbndAstLexicalScopeNode,
	#superclass : #MbndAstCleanUpScopeNode,
	#instVars : [
		'lexicalScope'
	],
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

{ #category : #accessing }
MbndAstLexicalScopeNode >> lexicalScope [
	^ lexicalScope
]

{ #category : #accessing }
MbndAstLexicalScopeNode >> lexicalScope: anObject [
	lexicalScope := anObject
]

{ #category : #'as yet unclassified' }
MbndAstLexicalScopeNode >> lexicallyScoped [
	^ self
]
