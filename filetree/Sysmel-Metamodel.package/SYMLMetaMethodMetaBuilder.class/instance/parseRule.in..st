accessing
parseRule: ruleDefinition in: environment
	ruleDefinition isImplicitContextMessageNode ifFalse: [ 
		self error: 'Expected an implicit message send' at: ruleDefinition.
	].
	^ (SYMLMetaMethodRuleParser parserForSelector: ruleDefinition selector) new parseRule: ruleDefinition in: environment