initialization
initialize
	CompilersForLanguages := Dictionary new.
	self allSubclassesDo: [ :sc |
		CompilersForLanguages at: sc languageName put: sc new
	]