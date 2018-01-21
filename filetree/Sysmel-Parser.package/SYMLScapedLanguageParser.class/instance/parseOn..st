parsing
parseOn: aPPContext

	| memento stream activeCount result c |
	memento := aPPContext remember.
	stream := aPPContext stream.
	stream next ~= openCharacter ifTrue: [
		aPPContext restore: memento.
		^ PPFailure message: 'Expected a delimiter for the scaped language' context: aPPContext
	].

	activeCount := 1.
	result := ByteString streamContents: [ :out |
		out nextPut: openCharacter.
		
		[activeCount > 0 and: [stream atEnd not ]] whileTrue: [
			c := stream next.
			c = openCharacter ifTrue: [
				activeCount := activeCount + 1.
			].
			c = closeCharacter ifTrue: [ 
				activeCount := activeCount - 1.
			].
		
			out nextPut: c
		]
	].

	activeCount ~= 0 ifTrue: [ 
		aPPContext restore: memento.
		^ PPFailure message: 'Failed to parse a scaped language completely.' context: aPPContext
	].

	^ result