accessing
parseIntegerValue: aString
	^ (aString first = $+ ifTrue: [ aString allButFirst ] ifFalse: [ aString ]) asInteger