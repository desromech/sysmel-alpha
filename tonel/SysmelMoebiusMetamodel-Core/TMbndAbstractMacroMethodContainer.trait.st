Trait {
	#name : #TMbndAbstractMacroMethodContainer,
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #'as yet unclassified' }
TMbndAbstractMacroMethodContainer >> createMacroMethodEntityForPrototype: prototype [
	^ self createMacroMethodEntityForPrototype: prototype withReceiverType: self compilationTarget voidType
]

{ #category : #'as yet unclassified' }
TMbndAbstractMacroMethodContainer >> createMacroMethodEntityForPrototype: methodPrototype withReceiverType: receiverType [
	| method macroMethod |
	macroMethod := MbndMacroMessageMethod new.
	
	method := MbndConcreteMacroMessageMethod new
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
TMbndAbstractMacroMethodContainer >> findOrAddMacroSelectorPrototype: prototype [
	(self lookupLocalMacroSelector: prototype selector) ifNil: [
		self addMacroMethod: (self createMacroMethodEntityForPrototype: prototype)
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
