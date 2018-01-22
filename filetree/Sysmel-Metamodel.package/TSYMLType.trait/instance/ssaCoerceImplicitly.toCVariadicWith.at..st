coercion
ssaCoerceImplicitly: value toCVariadicWith: builder at: aSourcePosition
	self error: 'Unimplemented coercion from {1} to C variadic argument.' format: { self asString } at: aSourcePosition