"
A MbndCollectionWithContextTest is a test class for testing the behavior of MbndCollectionWithContext
"
Class {
	#name : #MbndCollectionWithContextTest,
	#superclass : #TestCase,
	#category : #'MoebiusBandMetamodel-Core-Tests-Parsing'
}

{ #category : #tests }
MbndCollectionWithContextTest >> testLineColumnAt [
	| string |
	string := 'a
c d
e' asMoebiusBandCollectionWithContext.

	self assert: (string lineColumnAt: (string collection indexOf: $d)) equals: #(2 3)
]

{ #category : #tests }
MbndCollectionWithContextTest >> testSourcePosition [
	| string sourcePosition |
	string := 'a
c d
e' asMoebiusBandCollectionWithContext.

	sourcePosition := MbndSourcePosition new
		collection: string;
		start: (string collection indexOf: $c);
		stop: (string collection indexOf: $d);
		yourself.
		
	self assert: sourcePosition line equals: 2.
	self assert: sourcePosition column equals: 1.
	self assert: sourcePosition endLine equals: 2.
	self assert: sourcePosition endColumn equals: 3.
]
