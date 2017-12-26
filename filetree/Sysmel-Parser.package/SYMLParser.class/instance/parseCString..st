accessing
parseCString: aString
	| in c |
	^ (ByteArray streamContents: [ :out |
		in := ReadStream on: aString from: 2 to: aString size - 1 .
		[in atEnd] whileFalse: [
			c := in next.
			c = $\ ifTrue: [
				self parseCEscapeSequenceFrom: in into: out
			] ifFalse: [
				out nextPut: c asInteger
			]
		].
	]) utf8Decoded