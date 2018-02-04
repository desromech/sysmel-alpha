converting
buildAPSG: builder
	^ (builder chain: (receiver buildAPSG: builder)
		messages: (messages collect: [:message | message buildAPSG: builder]))
		position: self;
		yourself