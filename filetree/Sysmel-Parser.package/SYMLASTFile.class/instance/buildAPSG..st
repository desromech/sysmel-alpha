converting
buildAPSG: builder
	^ (builder sequence: (expressions collect: [:expr | expr buildAPSG: builder] ))
		position: self;
		yourself