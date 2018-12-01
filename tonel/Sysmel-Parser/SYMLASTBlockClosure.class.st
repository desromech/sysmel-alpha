Class {
	#name : #SYMLASTBlockClosure,
	#superclass : #SYMLASTBlock,
	#instVars : [
		'arguments'
	],
	#category : #'Sysmel-Parser-AST'
}

{ #category : #accessing }
SYMLASTBlockClosure >> arguments [
	^ arguments
]

{ #category : #accessing }
SYMLASTBlockClosure >> arguments: anObject [
	arguments := anObject
]

{ #category : #converting }
SYMLASTBlockClosure >> buildAPSG: builder [
	| body |
	body := (builder pragmas: (pragmas collect: [:pragma | pragma buildAPSG: builder]) sequence: (expressions collect: [:expr | expr buildAPSG: builder] ))
		position: self.
	^ (builder blockClosure: body arguments: arguments)
		position: self
]

{ #category : #printing }
SYMLASTBlockClosure >> children [
	^ {#arguments -> arguments} , super children
]

{ #category : #printing }
SYMLASTBlockClosure >> printOn: aStream [
	aStream nextPutAll: 'block-closure'
]
