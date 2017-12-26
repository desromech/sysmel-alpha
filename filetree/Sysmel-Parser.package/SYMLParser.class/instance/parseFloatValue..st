accessing
parseFloatValue: aString
	^ (aString first = $+ ifTrue: [ aString allButFirst ] ifFalse: [ aString ]) asNumber asFloat