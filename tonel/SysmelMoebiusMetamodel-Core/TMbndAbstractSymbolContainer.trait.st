Trait {
	#name : #TMbndAbstractSymbolContainer,
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #'overloaded methods' }
TMbndAbstractSymbolContainer >> createFunctionEntityForPrototype: functionPrototype [
	^ self createFunctionEntityForPrototype: functionPrototype withReceiverType: self implicitFunctionReceiverType
]

{ #category : #'overloaded methods' }
TMbndAbstractSymbolContainer >> createFunctionEntityForPrototype: functionPrototype withReceiverType: receiverType [
	| method |
	method := MbndConcreteFunctionMethod new
		name: functionPrototype name;
		flags: functionPrototype flags;
		declarationPosition: functionPrototype;
		receiverType: receiverType;
		boundType: functionPrototype functionType;
		yourself.
	receiverType isVoidType ifTrue: [ 
		method type: functionPrototype functionType.
	] ifFalse: [ 
		self halt
	].

	self addChild: method.
	functionPrototype concreteMethod: method.
	^ method
]

{ #category : #'member symbols' }
TMbndAbstractSymbolContainer >> ensureSymbolIsNamespace: namespaceName [
	^ self ensureSymbolIsNamespace: namespaceName at: MbndSourcePosition empty
]

{ #category : #'member symbols' }
TMbndAbstractSymbolContainer >> ensureSymbolIsNamespace: namespaceName at: position [
	| namespace |
	self canHaveNamespaces ifFalse: [
		self error: 'Cannot define a namespace in this context.' at: position
	].

	(self lookupLocalSymbol: namespaceName) ifNil: [
		namespace := MbndNamespace new
			name: namespaceName;
			module: self module;
			yourself.
		self
			setLocalSymbol: namespaceName value: namespace;
			addChild: namespace.
	] ifNotNil: [ :previousDefinition |
		previousDefinition isNamespace ifFalse: [
			self error: 'Cannot create namespace with name {1} because it overrides previously defined symbol {2}.'
				format: { namespaceName asPrettySymbolName . previousDefinition } at: position
		].
	
		namespace := previousDefinition
	].

	^ namespace
]

{ #category : #'overloaded methods' }
TMbndAbstractSymbolContainer >> findOrAddGlobalVariableNamed: name valueType: valueType type: type at: node [
	| globalVariable |
	globalVariable := self lookupLocalSymbol: name.
	globalVariable ifNotNil: [
		globalVariable isGlobalVariable ifFalse: [ 
			self error: 'Global variable "{1}" clashes with the name of something that already exists.' at: node.
		].
	
		(globalVariable valueType ~~ valueType or: [ globalVariable type ~~ type ]) ifTrue: [
			self error: 'Global variable "{1}" another variable with a different type.' at: node.
		].
	
		^ globalVariable
	].

	globalVariable := MbndGlobalVariable new
		definitionNode: node;
		flags: node flags;
		name: name;
		valueType: valueType;
		type: type;
		currentValue: (valueType defaultValueAt: node)
		yourself.
	self addChild: globalVariable.
	self setLocalSymbol: name value: globalVariable.
	^ globalVariable
]

{ #category : #'overloaded methods' }
TMbndAbstractSymbolContainer >> findOrAddOverloadedFunctionPrototype: functionPrototype [
	| localSymbolDefinition |
	localSymbolDefinition := self lookupLocalSymbol: functionPrototype name.
	localSymbolDefinition ifNil: [
		self setLocalSymbol: functionPrototype name value: (self createFunctionEntityForPrototype: functionPrototype)
	] ifNotNil: [
		localSymbolDefinition isMethodGroup ifFalse: [
			(localSymbolDefinition matchesPrototypeNode: functionPrototype withReceiverType: self implicitFunctionReceiverType) ifTrue: [
				functionPrototype concreteMethod: localSymbolDefinition.
				^ self
			].
			
			localSymbolDefinition := MbndFunctionGroup new
				name: localSymbolDefinition name;
				addOverloadedEntity: localSymbolDefinition;
				yourself.
			self addChild: localSymbolDefinition.
			self setLocalSymbol: localSymbolDefinition name value: localSymbolDefinition
		].
		(localSymbolDefinition findMatchingPrototypeNode: functionPrototype withReceiverType: self implicitFunctionReceiverType) ifNotNil: [ :existent |
			functionPrototype concreteMethod: existent.
			^ self
		].
	
		localSymbolDefinition addOverloadedEntity: (self createFunctionEntityForPrototype: functionPrototype)
	].

]

{ #category : #'overloaded methods' }
TMbndAbstractSymbolContainer >> implicitFunctionReceiverType [
	^ self compilationTarget voidType
]

{ #category : #'member symbols' }
TMbndAbstractSymbolContainer >> lookupLocalSymbol: aSymbol [
	self explicitRequirement
]

{ #category : #'member symbols' }
TMbndAbstractSymbolContainer >> lookupSymbol: aSymbol [
	^ nil
]

{ #category : #'member symbols' }
TMbndAbstractSymbolContainer >> setLocalSymbol: symbol value: value [
	self explicitRequirement
]
