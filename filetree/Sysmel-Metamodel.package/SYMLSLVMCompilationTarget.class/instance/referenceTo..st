composite types
referenceTo: referencedType
	^ referenceTypes at: referencedType ifAbsentPut: [
		SYMLReferenceType new
			target: self;
			referenced: referencedType;
			yourself
	]