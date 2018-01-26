composite types
constOfType: valueType
	valueType isConstantType ifTrue: [ ^ valueType ].
	^ constTypes at: valueType ifAbsentPut: [ SYMLConstType new target: self; decorated: valueType ]