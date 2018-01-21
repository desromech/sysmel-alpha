accessing
addRules: rulesExpression toSelectors: selectors hasReceiver: hasReceiver in: definitionEnvironment
	| rules metaMethod |
	rulesExpression type isAPSGNode ifFalse: [
		self error: 'Expected an APSG node for the meta-method rules.'
	].

	rulesExpression value isSequenceNode ifFalse: [
		self error: 'Expected a sequence node for the rules.' at: rulesExpression value
	].

	rules := self parseRules: rulesExpression value in: rulesExpression environment.
	selectors do: [ :selector |
		metaMethod := definitionEnvironment lookMetaMethod: selector hasReceiver: hasReceiver ifPresent: [ :existing |
			existing isRuleBasedMetaMethod ifFalse: [
				self error: 'Overriding the non rule based meta method {1}' format: { selector printString }
			].
			existing
		] ifAbsentPut: [ SYMLRuleBasedMetaMethod new ].
		metaMethod addRules: rules
	].
	