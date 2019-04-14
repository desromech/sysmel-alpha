Class {
	#name : #SYMLASTDictionaryConstruction,
	#superclass : #SYMLASTNode,
	#instVars : [
		'associations'
	],
	#category : #'SysmelLanguage-Sysmel-AST'
}

{ #category : #accessing }
SYMLASTDictionaryConstruction >> associations [
	^ associations
]

{ #category : #accessing }
SYMLASTDictionaryConstruction >> associations: anObject [
	associations := anObject
]

{ #category : #converting }
SYMLASTDictionaryConstruction >> buildMoebiusAST: builder [
	^ (builder contructDictionaryWith: (associations collect: [:assoc | assoc buildMoebiusAST: builder]))
		position: self;
		yourself
]

{ #category : #accessing }
SYMLASTDictionaryConstruction >> children [
	^ associations
]

{ #category : #printing }
SYMLASTDictionaryConstruction >> printOn: aStream [
	aStream nextPutAll: 'dictionary'
]
