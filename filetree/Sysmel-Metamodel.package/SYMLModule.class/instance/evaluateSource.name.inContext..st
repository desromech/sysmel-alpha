evaluating
evaluateSource: aSourceString name: aSourceName inContext: context
	| ast contents |

	contents := aSourceString asSysmelCollectionWithContext.
	contents name: aSourceName.

	ast := SYMLParser parse: contents.
	self convertParseFailure: ast collection: contents.
	^ ast evaluateInEnvironment: context.
