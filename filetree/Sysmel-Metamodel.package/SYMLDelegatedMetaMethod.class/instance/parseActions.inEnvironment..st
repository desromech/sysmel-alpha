parsing
parseActions: actions inEnvironment: environment
	actions type isAPSGNode ifFalse: [ self error: 'Expected an APSG node for the meta method actions.' ].
	actions value isSequenceNode ifFalse: [ self error: 'Expected a sequence of actions.' at: actions value ].
	actions value do: [ :action | self parseAction: action inEnvironment: environment ].