tokens
identifier
	^ self token: identifierStart ,  identifierInner star , $: asParser not