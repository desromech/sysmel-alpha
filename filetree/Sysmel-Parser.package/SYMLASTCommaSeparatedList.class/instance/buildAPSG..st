converting
buildAPSG: builder
	^ (builder tuple: (expressions collect: [:expr | expr buildAPSG: builder] ))
		position: self;
		yourself