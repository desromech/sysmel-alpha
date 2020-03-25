Class {
	#name : #SysmelDictionaryElementASTNode,
	#superclass : #SysmelExpressionASTNode,
	#instVars : [
		'key',
		'value'
	],
	#category : #'SysmelLanguage-Sysmel'
}

{ #category : #generated }
SysmelDictionaryElementASTNode >> acceptVisitor: anAbstractVisitor [
	^ anAbstractVisitor visitDictionaryElement: self
]

{ #category : #generated }
SysmelDictionaryElementASTNode >> key [
	^ key
]

{ #category : #generated }
SysmelDictionaryElementASTNode >> key: aSysmelDictionaryKeyASTNode [
	self key notNil
		ifTrue: [ self key parent: nil ].
	key := aSysmelDictionaryKeyASTNode.
	self key notNil
		ifTrue: [ self key parent: self ]
]

{ #category : #generated }
SysmelDictionaryElementASTNode >> nodeVariables [
	^ #(#key #value)
]

{ #category : #generated }
SysmelDictionaryElementASTNode >> value [
	^ value
]

{ #category : #generated }
SysmelDictionaryElementASTNode >> value: aSysmelExpressionASTNode [
	self value notNil
		ifTrue: [ self value parent: nil ].
	value := aSysmelExpressionASTNode.
	self value notNil
		ifTrue: [ self value parent: self ]
]
