evaluating
convertParseFailure: aFailure collection: collection
	| position |
	aFailure isPetitFailure ifFalse: [ ^ self ].
	position := SYMLSourcePosition new collection: collection; start: aFailure position; stop: aFailure position.
	SYMLParseError new signal: position asString , ': ' , aFailure message.