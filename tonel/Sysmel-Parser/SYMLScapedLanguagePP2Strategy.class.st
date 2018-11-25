Class {
	#name : #SYMLScapedLanguagePP2Strategy,
	#superclass : #PP2Strategy,
	#category : #'Sysmel-Parser-Parser'
}

{ #category : #parsing }
SYMLScapedLanguagePP2Strategy >> parseOn: aPP2Context [

	| memento stream activeCount result c |
	memento := aPP2Context remember.
	stream := aPP2Context.
	stream next ~= node openCharacter ifTrue: [
		aPP2Context restore: memento.
		^ PP2Failure message: 'Expected a delimiter for the scaped language' context: aPP2Context
	].

	activeCount := 1.
	result := ByteString streamContents: [ :out |
		out nextPut: node openCharacter.
		
		[activeCount > 0 and: [stream atEnd not ]] whileTrue: [
			c := stream next.
			c = node openCharacter ifTrue: [
				activeCount := activeCount + 1.
			].
			c = node closeCharacter ifTrue: [ 
				activeCount := activeCount - 1.
			].
		
			out nextPut: c
		]
	].

	activeCount ~= 0 ifTrue: [ 
		aPP2Context restore: memento.
		^ PP2Failure message: 'Failed to parse a scaped language completely.' context: aPP2Context
	].

	^ result
]
