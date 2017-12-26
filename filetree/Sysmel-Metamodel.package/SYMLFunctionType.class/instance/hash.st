comparing
hash
	^ self class identityHash bitXor:
	( arguments hash bitXor:
	( returnType hash bitXor:
	( variadic hash bitXor:
	( callingConvention identityHash))))