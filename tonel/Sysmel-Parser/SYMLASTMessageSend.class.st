Class {
	#name : #SYMLASTMessageSend,
	#superclass : #SYMLASTNode,
	#instVars : [
		'receiver',
		'selector',
		'arguments'
	],
	#category : #Sysmel-Parser-AST
}

{ #category : #accessing }
SYMLASTMessageSend >> arguments [
	^ arguments
]

{ #category : #accessing }
SYMLASTMessageSend >> arguments: anObject [
	arguments := anObject
]

{ #category : #converting }
SYMLASTMessageSend >> buildAPSG: builder [
	^ (builder send: selector
		to: (receiver ifNotNil: [receiver buildAPSG: builder])
		withArguments: (arguments collect: [:arg | arg buildAPSG: builder]))
		position: self;
		yourself
]

{ #category : #accessing }
SYMLASTMessageSend >> children [
	^ { selector .
		receiver .
		#arguments -> arguments .
	}
]

{ #category : #testing }
SYMLASTMessageSend >> isMessageNode [
	^ true
]

{ #category : #printing }
SYMLASTMessageSend >> printOn: aStream [
	aStream nextPutAll: 'send '; print: selector
]

{ #category : #accessing }
SYMLASTMessageSend >> receiver [
	^ receiver
]

{ #category : #accessing }
SYMLASTMessageSend >> receiver: anObject [
	receiver := anObject
]

{ #category : #accessing }
SYMLASTMessageSend >> selector [
	^ selector
]

{ #category : #accessing }
SYMLASTMessageSend >> selector: anObject [
	selector := anObject
]

{ #category : #'as yet unclassified' }
SYMLASTMessageSend >> withReceiver: aReceiver [
	receiver := aReceiver
]
