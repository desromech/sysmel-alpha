comparing
= other
	^ self class == other class and:
	[ arguments = other arguments and:
	[ returnType = other returnType and:
	[ variadic = other variadic and:
	[ callingConvention == other callingConvention ]]]]