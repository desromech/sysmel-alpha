compiling
evaluateNode: aNode inEnvironment: anEnvironment
	| source compiler |
	source := aNode sourceCode withSqueakLineEndings.
	(source first = ${) ifTrue: [
		source := source copyFrom: 2 to: source size - 1.
		compiler := Smalltalk compiler
			class: UndefinedObject;
			source: source.
		compiler compilationContext compiledMethodTrailer sourceCode: source.
		^ compiler compile asSysmelValueInEnvironment: anEnvironment.
	] ifFalse: [
		^ (Smalltalk compiler source: source; evaluate) asSysmelValueInEnvironment: anEnvironment
	].