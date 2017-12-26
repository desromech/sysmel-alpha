accessing
fillWithBuiltInTypes
	module compilationTarget builtInTypes do: [ :type |
		symbols at: type name put: type
	]