tokens
token: aParser
	^ (whites , aParser token) ==> [ :parts | parts second ]