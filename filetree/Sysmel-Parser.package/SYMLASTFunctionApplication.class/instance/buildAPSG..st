converting
buildAPSG: builder
	^ (builder send: #applyWithArguments:
		to: (function buildAPSG: builder)
		withArguments: {builder tuple: (arguments asList collect: [:arg | arg buildAPSG: builder])})
		position: self;
		yourself