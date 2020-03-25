Class {
	#name : #SysmelDictionaryKeywordKeyASTNode,
	#superclass : #SysmelExpressionASTNode,
	#instVars : [
		'value'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelDictionaryKeywordKeyASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitDictionaryKeywordKey: self
]

{ #category : #generated }
SysmelDictionaryKeywordKeyASTNode >> tokenVariables [
	^ #(#value)
]

{ #category : #generated }
SysmelDictionaryKeywordKeyASTNode >> value [
	^ value
]

{ #category : #generated }
SysmelDictionaryKeywordKeyASTNode >> value: aSmaCCToken [
	value := aSmaCCToken
]
