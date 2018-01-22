accessing
tuple: types
	| tuple |
	tuple := SYMLTupleType new
		target: self;
		types: types;
		yourself.
	^ tupleTypes at: tuple ifAbsentPut: [ tuple ]