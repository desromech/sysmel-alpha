Class {
	#name : #MbndCollectionWithContext,
	#superclass : #Object,
	#instVars : [
		'collection',
		'name',
		'newlines'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Parsing'
}

{ #category : #converting }
MbndCollectionWithContext >> asMoebiusBandCollectionWithContext [
	^ self
]

{ #category : #converting }
MbndCollectionWithContext >> asPetit2Stream [
	^ (Smalltalk globals at: #PP2Stream) on: self
]

{ #category : #converting }
MbndCollectionWithContext >> at: index [
	^ collection at: index
]

{ #category : #accessing }
MbndCollectionWithContext >> collection [
	^ collection
]

{ #category : #accessing }
MbndCollectionWithContext >> collection: anObject [
	collection := anObject
]

{ #category : #converting }
MbndCollectionWithContext >> copyFrom: start to: stop [
	(start isNil or: [ stop isNil ]) ifTrue: [ ^ '' ].
	^ collection copyFrom: start to: stop
]

{ #category : #initialization }
MbndCollectionWithContext >> initialize [
	super initialize.
	name := 'unnamed'
]

{ #category : #accessing }
MbndCollectionWithContext >> lineColumnAt: aPosition [
	| newlineList start end m v bestResult line column el |
	aPosition ifNil: [ ^ #(01 1) ].
	aPosition <= 1 ifTrue: [ ^ #(01 1) ].
	newlineList := self newlines.
	start := 1.
	end := newlineList size + 1.
	bestResult := nil.
	[ start < end ] whileTrue: [ 
		m := start + ((end - start) // 2).
		v := newlineList at: m.
		
		v <= aPosition ifTrue: [
			bestResult := m.
			start := m + 1
		] ifFalse: [ 
			end := m
		]
	].

	self assert: bestResult isNotNil.
	line := bestResult.
	column := 1.
	(newlineList at: line) to: aPosition - 1 do: [ :i |
		el := collection at: i.
		el = Character tab ifTrue: [
			column := ((column + 3) // 4) * 4 + 1
		] ifFalse: [
			column := column + 1
		]
	].

	^ { line . column }
]

{ #category : #accessing }
MbndCollectionWithContext >> name [
	^ name
]

{ #category : #accessing }
MbndCollectionWithContext >> name: anObject [
	name := anObject
]

{ #category : #accessing }
MbndCollectionWithContext >> newlines [
	| index size el |
	newlines ifNotNil: [ ^ newlines ].
	^ newlines := Array streamContents: [ :out |
		index := 1.
		out nextPut: index. "Line 1"
		
		size := collection size.
		[ index <= size ] whileTrue: [ 
			el := collection at: index.
			el = Character cr ifTrue: [ 
				index := index + 1.
				index <= size ifTrue: [
					el := collection at: index.
					el = Character lf ifTrue: [ 
						index := index + 1.
					].
				].
				out nextPut: index.
			] ifFalse: [
				el = Character lf ifTrue: [ 
					index := index + 1.
					out nextPut: index.
				] ifFalse: [ 
					index := index + 1.
				]
			]
		]
	]
]

{ #category : #converting }
MbndCollectionWithContext >> size [
	^ collection size
]
