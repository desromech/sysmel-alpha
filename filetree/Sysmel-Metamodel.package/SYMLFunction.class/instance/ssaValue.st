semantic analysis
ssaValue
	ssaValue ifNil: [ self createSSAValue ].
	^ ssaValue