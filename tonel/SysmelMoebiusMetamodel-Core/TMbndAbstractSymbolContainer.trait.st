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
	method := MbndConcreteMethod new
		parent: self;
		name: functionPrototype name;
		declarationPosition: functionPrototype;
		receiverType: receiverType;
		boundType: functionPrototype functionType;
		yourself.
	receiverType isVoidType ifTrue: [ 
		method type: functionPrototype functionType.
	] ifFalse: [ 
		self halt
	].

	functionPrototype concreteMethod: method.
	^ method
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
