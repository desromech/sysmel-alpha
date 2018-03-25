Class {
	#name : #SYMLMetaMethodMetaBuilder,
	#superclass : #SYMLDefaultMetaBuilder,
	#category : #Sysmel-Metamodel-MetaBuilders
}

{ #category : #accessing }
SYMLMetaMethodMetaBuilder >> addRules: rulesExpression toSelectors: selectors hasReceiver: hasReceiver in: definitionEnvironment [
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
	
]

{ #category : #accessing }
SYMLMetaMethodMetaBuilder >> name [
	^ #metaMethod
]

{ #category : #accessing }
SYMLMetaMethodMetaBuilder >> parseRule: ruleDefinition in: environment [
	ruleDefinition isImplicitContextMessageNode ifFalse: [ 
		self error: 'Expected an implicit message send' at: ruleDefinition.
	].
	^ (SYMLMetaMethodRuleParser parserForSelector: ruleDefinition selector) new parseRule: ruleDefinition in: environment
]

{ #category : #accessing }
SYMLMetaMethodMetaBuilder >> parseRules: ruleDefinitions in: environment [
	^ ruleDefinitions collect: [:ruleDefinition | self parseRule: ruleDefinition in: environment]
]

{ #category : #accessing }
SYMLMetaMethodMetaBuilder >> selector: aSelector rules: someRules [
	<compileTime>
	<lazy>
	| definitionEnvironment |
	definitionEnvironment := aSelector environment findProgramEntityDefinitionScope.
	^ self addRules: someRules evaluate toSelectors: { aSelector evaluate } hasReceiver: true in: definitionEnvironment
]

{ #category : #accessing }
SYMLMetaMethodMetaBuilder >> selectorWithoutReceiver: aSelector rules: someRules [
	<compileTime>
	<lazy>
	| definitionEnvironment |
	definitionEnvironment := aSelector environment findProgramEntityDefinitionScope.
	^ self addRules: someRules evaluate toSelectors: { aSelector evaluate } hasReceiver: false in: definitionEnvironment
]

{ #category : #accessing }
SYMLMetaMethodMetaBuilder >> selectors: someSelectors rules: someRules [
	<compileTime>
	<lazy>
	| definitionEnvironment |
	definitionEnvironment := someSelectors environment findProgramEntityDefinitionScope.
	^ self addRules: someRules evaluate toSelectors: someSelectors evaluate value hasReceiver: true in: definitionEnvironment
]

{ #category : #accessing }
SYMLMetaMethodMetaBuilder >> selectorsWithoutReceiver: someSelectors rules: someRules [
	<compileTime>
	<lazy>
	| definitionEnvironment |
	definitionEnvironment := someSelectors environment findProgramEntityDefinitionScope.
	^ self addRules: someRules evaluate toSelectors: someSelectors evaluate value hasReceiver: false in: definitionEnvironment
]
