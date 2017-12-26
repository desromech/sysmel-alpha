composite types
volatileType: valueType
	valueType isVolatile ifTrue: [ ^ valueType ].
	^ volatileTypes at: valueType ifAbsentPut: [ SYMLVolatileType new target: self; decorated: valueType ]