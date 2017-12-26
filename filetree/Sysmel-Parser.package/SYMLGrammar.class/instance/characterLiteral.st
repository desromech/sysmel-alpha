accessing
characterLiteral
	^ self token: $' asParser , ($' asParser negate / ($\ asParser , #any asParser)) star , $' asParser