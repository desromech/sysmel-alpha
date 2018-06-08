Class {
	#name : #SYMLSourcePosition,
	#superclass : #Object,
	#instVars : [
		'collection',
		'start',
		'stop',
		'line',
		'column',
		'endLine',
		'endColumn'
	],
	#category : #'Sysmel-Metamodel'
}

{ #category : #requirements }
SYMLSourcePosition class >> empty [
	^ self new
]

{ #category : #comparing }
SYMLSourcePosition >> = other [
	^ self class == other class and:
		[ collection  == other collection and:
		[ start = other start and:
		[ stop = other stop ] ] ]
]

{ #category : #converting }
SYMLSourcePosition >> asSysmelSourcePosition [
	^ self
]

{ #category : #accessing }
SYMLSourcePosition >> collection [
	^ collection
]

{ #category : #accessing }
SYMLSourcePosition >> collection: anObject [
	collection := anObject
]

{ #category : #accessing }
SYMLSourcePosition >> column [
	column ifNil: [ self fetchLineAndColumn ].
	^ column
]

{ #category : #accessing }
SYMLSourcePosition >> endColumn [
	endColumn ifNil: [ self fetchEndLineAndColumn ].
	^ endColumn
]

{ #category : #accessing }
SYMLSourcePosition >> endLine [
	endLine ifNil: [ self fetchEndLineAndColumn ].
	^ endLine
]

{ #category : #accessing }
SYMLSourcePosition >> fetchEndLineAndColumn [
	| lineColumn |
	collection ifNil: [
		endLine := 0.
		endColumn := 0.
		^ self
	].

	lineColumn := collection lineColumnAt: stop.
	endLine := lineColumn first.
	endColumn := lineColumn second.
]

{ #category : #accessing }
SYMLSourcePosition >> fetchLineAndColumn [
	| lineColumn |
	(collection isNil or: [collection isString]) ifTrue: [
		line := 0.
		column := 0.
		^ self
	].

	lineColumn := collection lineColumnAt: start.
	line := lineColumn first.
	column := lineColumn second.
]

{ #category : #accessing }
SYMLSourcePosition >> fileName [
	^ collection ifNil: ['generated'] ifNotNil: [collection isString ifTrue: [collection] ifFalse: [ collection name]]
]

{ #category : #accessing }
SYMLSourcePosition >> fullPrintOn: aStream [
	
]

{ #category : #comparing }
SYMLSourcePosition >> hash [
	^ self class identityHash bitXor:
		( collection identityHash bitXor: 
		( start hash bitXor: stop hash))
]

{ #category : #accessing }
SYMLSourcePosition >> line [
	line ifNil: [ self fetchLineAndColumn ].
	^ line
]

{ #category : #accessing }
SYMLSourcePosition >> position [
	^ self
]

{ #category : #accessing }
SYMLSourcePosition >> printOn: aStream [
	aStream nextPutAll: self fileName; nextPut: $:; print: self line; nextPut: $:; print: self column 
]

{ #category : #accessing }
SYMLSourcePosition >> sourceCode [
	^ collection copyFrom: start to: stop
]

{ #category : #accessing }
SYMLSourcePosition >> start [
	^ start
]

{ #category : #accessing }
SYMLSourcePosition >> start: anObject [
	start := anObject
]

{ #category : #accessing }
SYMLSourcePosition >> stop [
	^ stop
]

{ #category : #accessing }
SYMLSourcePosition >> stop: anObject [
	stop := anObject
]

{ #category : #'as yet unclassified' }
SYMLSourcePosition >> until: endPosition [
	^ self class new collection: collection; start: start; stop: endPosition stop; yourself
]
