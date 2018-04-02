Class {
	#name : #SYMLPharoLanguageCompiler,
	#superclass : #SYMLScapedLanguageCompiler,
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #accessing }
SYMLPharoLanguageCompiler class >> languageName [
	^ #Pharo
]

{ #category : #compiling }
SYMLPharoLanguageCompiler >> evaluateNode: aNode inEnvironment: anEnvironment [
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
]

{ #category : #styling }
SYMLPharoLanguageCompiler >> style: token into: commands [
	| source sourceStart styledSource |
	source := token inputValue.
	sourceStart := token start.
	
	(source first = ${) ifTrue: [
		sourceStart := sourceStart + 1.
		source := source copyFrom: 2 to: source size - 1.
		styledSource := (SHRBTextStyler new
			classOrMetaClass: UndefinedObject;
			isForWorkspace: false;
			styledTextFor: source asText)
	] ifFalse: [
		styledSource := (SHRBTextStyler new
			classOrMetaClass: UndefinedObject;
			isForWorkspace: true;
			styledTextFor: source asText)
	].

	commands add: ((Smalltalk globals at: #PhanideHighlightCommandCopyFromText) new
		start: sourceStart;
		text: styledSource;
		yourself)
]
