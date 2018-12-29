Class {
	#name : #SYMLASTDictionaryConstruction,
	#superclass : #SYMLASTNode,
	#instVars : [
		'associations'
	],
	#category : #'Sysmel-Parser-AST'
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
SYMLASTDictionaryConstruction >> buildAPSG: builder [
	^ (builder contructDictionaryWith: (associations collect: [:assoc | assoc buildAPSG: builder]))
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
