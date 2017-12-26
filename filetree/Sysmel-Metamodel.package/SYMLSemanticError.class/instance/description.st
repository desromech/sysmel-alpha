accessing
description
	"Return a textual description of the exception."

	^ String streamContents: [ :stream |
		sourcePosition position ifNotNil: [ :position | position printOn: stream ].
		stream nextPutAll: ': '; nextPutAll: self messageText
	]