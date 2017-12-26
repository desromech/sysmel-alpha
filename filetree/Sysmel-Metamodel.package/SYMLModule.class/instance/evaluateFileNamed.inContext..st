evaluating
evaluateFileNamed: aFileName inContext: context
	| fileReference oldDirectory |
	fileReference := currentDirectory resolve: aFileName asFileReference.
	oldDirectory := currentDirectory.
	currentDirectory := fileReference parent.

	[
		^ self evaluateSource: fileReference contents name: fileReference fullName inContext: context
	] ensure: [  currentDirectory := oldDirectory ]
