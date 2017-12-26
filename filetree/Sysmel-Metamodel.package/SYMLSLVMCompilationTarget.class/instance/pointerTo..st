composite types
pointerTo: pointedType
	^ pointerTypes at: pointedType ifAbsentPut: [
		SYMLPointerType new
			target: self;
			pointed: pointedType;
			yourself
	]