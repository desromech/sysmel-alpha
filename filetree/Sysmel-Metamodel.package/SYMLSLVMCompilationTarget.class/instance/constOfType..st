composite types
constOfType: valueType
	valueType isConstant ifTrue: [ ^ valueType ].
	^ constTypes at: valueType ifAbsentPut: [ SYMLConstType new target: self; decorated: valueType ]