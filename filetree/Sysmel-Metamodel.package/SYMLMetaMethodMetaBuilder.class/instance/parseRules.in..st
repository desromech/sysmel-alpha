accessing
parseRules: ruleDefinitions in: environment
	^ ruleDefinitions collect: [:ruleDefinition | self parseRule: ruleDefinition in: environment]