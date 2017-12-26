evaluating
evaluateSource: aSourceString name: aSourceName inContext: context
	| ast contents apsg |

	contents := aSourceString asSysmelCollectionWithContext.
	contents name: aSourceName.

	ast := SYMLParser parse: contents.
	self convertParseFailure: ast collection: contents.
	apsg := ast buildAPSG: (SYMLAPSGBuilder new environment: context).
	^ apsg evaluateInEnvironment: context
