tokens
token: aParser
	^ (whites, (aParser token: SYMLToken)) ==> [ :parts |
		parts second
			previousComments: parts first;
			yourself
	]