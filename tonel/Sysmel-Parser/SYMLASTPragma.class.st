Class {
	#name : #SYMLASTPragma,
	#superclass : #SYMLASTNode,
	#instVars : [
		'selector',
		'arguments'
	],
	#category : #'Sysmel-Parser-AST'
}

{ #category : #accessing }
SYMLASTPragma >> arguments [
	^ arguments
]

{ #category : #accessing }
SYMLASTPragma >> arguments: anObject [
	arguments := anObject
]

{ #category : #converting }
SYMLASTPragma >> buildAPSG: builder [
	^ (builder pragmaSelector: selector arguments: (arguments collect: [ :arg | arg buildAPSG: builder ]))
		position: position;
		yourself
]

{ #category : #accessing }
SYMLASTPragma >> children [
	^ { selector .
		#arguments -> arguments .
	}
]

{ #category : #printing }
SYMLASTPragma >> printOn: aStream [
	aStream nextPutAll: 'pragma'
]

{ #category : #accessing }
SYMLASTPragma >> selector [
	^ selector
]

{ #category : #accessing }
SYMLASTPragma >> selector: anObject [
	selector := anObject
]
