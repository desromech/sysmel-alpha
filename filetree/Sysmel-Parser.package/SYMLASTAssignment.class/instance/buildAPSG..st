converting
buildAPSG: builder
	^ (builder send: #assignValue:
		to: (reference buildAPSG: builder)
		withArguments: {value buildAPSG: builder})
		position: self;
		yourself
