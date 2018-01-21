accessing
tryToStyle: token language: language into: commands
	CompilersForLanguages at: language ifPresent: [ :compiler | compiler tryToStyle: token into: commands ]