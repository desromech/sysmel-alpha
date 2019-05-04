Trait {
	#name : #TMbndAbstractSymbolContainer,
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #'overloaded methods' }
TMbndAbstractSymbolContainer >> createFunctionEntityForPrototype: functionPrototype [
	^ self createFunctionEntityForPrototype: functionPrototype withReceiverType: self compilationTarget voidType
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
TMbndAbstractSymbolContainer >> findOrAddOverloadedFunctionPrototype: functionPrototype [
	| localSymbolDefinition |
	localSymbolDefinition := self lookupLocalSymbol: functionPrototype name.
	localSymbolDefinition ifNil: [
		self setLocalSymbol: functionPrototype name value: (self createFunctionEntityForPrototype: functionPrototype)
	] ifNotNil: [
		self halt
	].

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
