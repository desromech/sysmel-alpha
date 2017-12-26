converting
buildAPSG: builder
	^ (builder send: selector
		to: (receiver ifNotNil: [receiver buildAPSG: builder])
		withArguments: (arguments collect: [:arg | arg buildAPSG: builder]))
		position: self;
		yourself