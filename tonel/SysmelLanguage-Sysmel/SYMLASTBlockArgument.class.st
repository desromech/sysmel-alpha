Class {
	#name : #SYMLASTBlockArgument,
	#superclass : #SYMLASTNode,
	#instVars : [
		'name',
		'optionalType'
	],
	#category : #'SysmelLanguage-Sysmel-AST'
}

{ #category : #converting }
SYMLASTBlockArgument >> buildMoebiusAST: builder [
	^ builder argument: name type: (optionalType ifNotNil: [optionalType buildMoebiusAST: builder])
]

{ #category : #accessing }
SYMLASTBlockArgument >> children [
	^ { name . optionalType }
]

{ #category : #accessing }
SYMLASTBlockArgument >> name [
	^ name
]

{ #category : #accessing }
SYMLASTBlockArgument >> name: anObject [
	name := anObject
]

{ #category : #accessing }
SYMLASTBlockArgument >> optionalType [
	^ optionalType
]

{ #category : #accessing }
SYMLASTBlockArgument >> optionalType: anObject [
	optionalType := anObject
]

{ #category : #printing }
SYMLASTBlockArgument >> printOn: aStream [
	aStream nextPutAll: 'block-argument'
]
