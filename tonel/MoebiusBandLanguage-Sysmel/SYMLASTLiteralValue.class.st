Class {
	#name : #SYMLASTLiteralValue,
	#superclass : #SYMLASTNode,
	#instVars : [
		'value'
	],
	#category : #'MoebiusBandLanguage-Sysmel-AST'
}

{ #category : #converting }
SYMLASTLiteralValue >> buildMoebiusAST: builder [
	^ (builder literal: self value typeName: self literalTypeName)
			position: self

]

{ #category : #'as yet unclassified' }
SYMLASTLiteralValue >> evaluateLiteralArrayElement [
	^ self value
]

{ #category : #'as yet unclassified' }
SYMLASTLiteralValue >> literalTypeName [
	^ self subclassResponsibility
]

{ #category : #accessing }
SYMLASTLiteralValue >> value [
	^ value
]

{ #category : #accessing }
SYMLASTLiteralValue >> value: anObject [
	value := anObject
]
