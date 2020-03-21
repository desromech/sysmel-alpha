Trait {
	#name : #TMbndAbstractMacroMethodContainer,
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #'as yet unclassified' }
TMbndAbstractMacroMethodContainer >> createMacroMethodEntityForPrototype: prototype defineInModule: moduleForDefinition [
	^ self createMacroMethodEntityForPrototype: prototype withReceiverType: self compilationTarget voidType defineInModule: moduleForDefinition
]

{ #category : #'as yet unclassified' }
TMbndAbstractMacroMethodContainer >> createMacroMethodEntityForPrototype: methodPrototype withReceiverType: receiverType defineInModule: moduleForDefinition [
	| method macroMethod |
	macroMethod := MbndMacroMessageMethod new.
	
	method := MbndConcreteMacroMessageMethod new
		module: moduleForDefinition;
		name: methodPrototype selector;
		flags: methodPrototype flags;
		declarationPosition: methodPrototype;
		receiverType: receiverType;
		boundType: methodPrototype functionType;
		yourself.
	receiverType isVoidType ifTrue: [ 
		method type: methodPrototype functionType.
	] ifFalse: [
		method type: (methodPrototype functionType withExplicitReceiverType: receiverType)
	].

	macroMethod concreteMethod: method.
	self addChild: macroMethod.
	methodPrototype concreteMethod: method.
	^ macroMethod
]

{ #category : #'as yet unclassified' }
TMbndAbstractMacroMethodContainer >> findOrAddMacroSelectorPrototype: prototype defineInModule: moduleForDefinition [
	(self lookupLocalMacroSelector: prototype selector) ifNil: [
		self addMacroMethod: (self createMacroMethodEntityForPrototype: prototype defineInModule: moduleForDefinition)
	] ifNotNil: [ :existent |
		self halt
	]
]

{ #category : #'macro expansion' }
TMbndAbstractMacroMethodContainer >> lookupLocalMacroSelector: aSelector [
	self explicitRequirement
]

{ #category : #'macro expansion' }
TMbndAbstractMacroMethodContainer >> lookupMacroSelector: aSelector [
	^ nil
]
