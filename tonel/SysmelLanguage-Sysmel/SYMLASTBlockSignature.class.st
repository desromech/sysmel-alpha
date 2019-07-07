Class {
	#name : #SYMLASTBlockSignature,
	#superclass : #SYMLASTNode,
	#instVars : [
		'arguments',
		'returnType'
	],
	#category : #'SysmelLanguage-Sysmel-AST'
}

{ #category : #accessing }
SYMLASTBlockSignature >> arguments [
	^ arguments
]

{ #category : #accessing }
SYMLASTBlockSignature >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
SYMLASTBlockSignature >> children [
	^ { 
		#arguments -> arguments .
		returnType
	}
]

{ #category : #printing }
SYMLASTBlockSignature >> printOn: aStream [
	aStream nextPutAll: 'block-signature'
]

{ #category : #accessing }
SYMLASTBlockSignature >> returnType [
	^ returnType
]

{ #category : #accessing }
SYMLASTBlockSignature >> returnType: anObject [
	returnType := anObject
]
