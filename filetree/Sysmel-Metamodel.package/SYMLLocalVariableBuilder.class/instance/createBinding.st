converting
createBinding
	| parentEntity |
	type ifNil: [
		self error: 'A type or initial value is required for local variable {1}.' format: { name } at: sourcePosition
	].

	parentEntity := definitionEnvironment programEntity.
	binding := definitionEnvironment lookSymbol: name ifPresent: [ :existent |
		self error: 'Overriding existent local symbol {1}.' format: { name } at: sourcePosition
	] ifAbsentPut: [
		parentEntity createLocalVariableBinding: self
	].

	^ binding