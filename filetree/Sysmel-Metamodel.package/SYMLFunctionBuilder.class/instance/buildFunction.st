private
buildFunction
	| functionGroup |
	function := SYMLFunction new
		name: name;
		module: definitionEnvironment module;
		functionType: self functionType;
		argumentNames: (arguments collect: #first);
		argumentNodes: (arguments collect: #third);
		flags: flags;
		yourself.
		
	name ifNotNil: [
		(definitionEnvironment hasSupportForOverloadedFunctions and: [self isExternC not]) ifTrue: [ 
			definitionEnvironment lookSymbol: name ifPresent: [ :existing |
				existing isFunctionGroup ifFalse: [ 
					self error: 'Cannot override program entity {1} with function.' format: { name }
				].
				functionGroup := existing
			] ifAbsentPut: [
				functionGroup := SYMLFunctionGroup new
					module: definitionEnvironment module;
					parent: definitionEnvironment findDefinitionProgramEntity;
					name: name;
					yourself
			].
		
			function := functionGroup findWithType: functionType ifAbsentPut: [function].
		] ifFalse: [
			definitionEnvironment lookSymbol: name ifPresent: [ :existing |
				existing isFunction ifFalse: [ 
					self error: 'Cannot override program entity {1} with function.' format: { name }
				].
			
				(function functionType ~= existing functionType) ifTrue: [ 
					self error: 'Cannot override overload function {1}.' format: { name }
				].
			
				function := existing
			] ifAbsentPut: [ function parent: definitionEnvironment findDefinitionProgramEntity; yourself ].
		].
	].
