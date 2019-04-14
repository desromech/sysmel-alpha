Class {
	#name : #SYMLASTMessageSend,
	#superclass : #SYMLASTNode,
	#instVars : [
		'receiver',
		'selector',
		'arguments'
	],
	#category : #'SysmelLanguage-Sysmel-AST'
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
SYMLASTMessageSend >> buildMoebiusAST: builder [
	| selectorNode |
	selectorNode := selector isSYMLASTNode
		ifTrue: [ selector buildMoebiusAST: builder]
		ifFalse: [ (builder literalSymbol: selector)
				position: position].
	^ (builder unexpandedSend: selectorNode
		to: (receiver ifNotNil: [receiver buildMoebiusAST: builder])
		withArguments: (arguments collect: [:arg | arg buildMoebiusAST: builder]))
		position: self;
		yourself
]

{ #category : #converting }
SYMLASTMessageSend >> buildMoebiusMessageChainMessageAST: builder [
	| selectorNode |
	selectorNode := selector isSYMLASTNode
		ifTrue: [ selector buildMoebiusAST: builder]
		ifFalse: [ (builder literalSymbol: selector) position: position ].
		
	^ (builder messageChainMessageSelector: selector
		arguments: (arguments collect: [:arg | arg buildMoebiusAST: builder]))
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
