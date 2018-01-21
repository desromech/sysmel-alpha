initialization
initialize
	ParserForSelectors := Dictionary new.
	self allSubclassesDo: [ :sc |
		ParserForSelectors at: sc selector put: sc
	]