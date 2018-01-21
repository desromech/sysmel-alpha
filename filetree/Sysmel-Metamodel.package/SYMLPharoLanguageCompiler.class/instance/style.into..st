styling
style: token into: commands
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