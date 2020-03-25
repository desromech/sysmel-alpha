Class {
	#name : #SysmelDictionaryKeyASTNode,
	#superclass : #SysmelExpressionASTNode,
	#instVars : [
		'value',
		'colonToken'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelDictionaryKeyASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitDictionaryKey: self
]

{ #category : #generated }
SysmelDictionaryKeyASTNode >> colonToken [
	^ colonToken
]

{ #category : #generated }
SysmelDictionaryKeyASTNode >> colonToken: aSmaCCToken [
	colonToken := aSmaCCToken
]

{ #category : #generated }
SysmelDictionaryKeyASTNode >> nodeVariables [
	^ #(#value)
]

{ #category : #generated }
SysmelDictionaryKeyASTNode >> tokenVariables [
	^ #(#colonToken)
]

{ #category : #generated }
SysmelDictionaryKeyASTNode >> value [
	^ value
]

{ #category : #generated }
SysmelDictionaryKeyASTNode >> value: aSysmelExpressionASTNode [
	self value notNil
		ifTrue: [ self value parent: nil ].
	value := aSysmelExpressionASTNode.
	self value notNil
		ifTrue: [ self value parent: self ]
]
