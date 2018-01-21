parsing
parseRule: ruleDefinition in: environment
	| condition actions metaMethod |
	condition := ruleDefinition arguments first analyzeAndEvaluateInEnvironment: environment.
	actions := ruleDefinition arguments second analyzeAndEvaluateInEnvironment: environment.
	metaMethod := SYMLDelegatedMetaMethod new parseActions: actions inEnvironment: environment.
	^ SYMLMetaMethodPredicatedRule new
		condition: condition value asSysmelCompileTimeFunction;
		delegatedMetaMethod: metaMethod;
		yourself