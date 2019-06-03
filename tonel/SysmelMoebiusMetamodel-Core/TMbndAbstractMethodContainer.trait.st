Trait {
	#name : #TMbndAbstractMethodContainer,
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #adding }
TMbndAbstractMethodContainer >> addOverloadedMethod: method [
	self explicitRequirement
]

{ #category : #adding }
TMbndAbstractMethodContainer >> addOverloadedMethod: method argumentTypes: argumentTypes returnType: returnType [
	| functionType |
	functionType := self compilationTarget functionTypeWithArguments: argumentTypes returnType: returnType.
	^ self addOverloadedMethod: (method copy
		type: functionType;
		boundType: functionType;
		yourself)
]

{ #category : #adding }
TMbndAbstractMethodContainer >> addOverloadedMethod: method receiverType: receiverType argumentTypes: argumentTypes returnType: returnType [
	| functionType boundFunctionType |
	boundFunctionType := self compilationTarget functionTypeWithArguments: argumentTypes returnType: returnType.
	functionType := self compilationTarget functionTypeWithArguments: {receiverType} , argumentTypes returnType: returnType.
	^ self addOverloadedMethod: (method copy
		receiverType: receiverType;
		type: functionType;
		boundType: boundFunctionType;
		yourself)
]

{ #category : #adding }
TMbndAbstractMethodContainer >> createMethodEntityForPrototype: functionPrototype [
	^ self createMethodEntityForPrototype: functionPrototype withReceiverType: self compilationTarget voidType
]

{ #category : #adding }
TMbndAbstractMethodContainer >> createMethodEntityForPrototype: methodPrototype withReceiverType: receiverType [
	| method |
	method := MbndConcreteMessageMethod new
		name: methodPrototype selector;
		flags: methodPrototype flags;
		declarationPosition: methodPrototype;
		receiverType: receiverType;
		boundType: methodPrototype functionType;
		yourself.
	receiverType isVoidType ifTrue: [ 
		method type: methodPrototype functionType.
	] ifFalse: [
		method type: (methodPrototype functionType prependArguments: {receiverType}).
	].

	self addChild: method.
	methodPrototype concreteMethod: method.
	^ method
]

{ #category : #adding }
TMbndAbstractMethodContainer >> findOrAddOverloadedSelectorPrototype: prototype [
	(self lookupLocalOverloadedSelector: prototype selector) ifNil: [
		self addOverloadedMethod: (self createMethodEntityForPrototype: prototype)
	] ifNotNil: [ :existent |
		self halt
	]
]

{ #category : #methods }
TMbndAbstractMethodContainer >> lookupLocalOverloadedSelector: aSelector [
	^ nil
]

{ #category : #methods }
TMbndAbstractMethodContainer >> lookupOverloadedSelector: aSelector [
	^ nil
]

{ #category : #methods }
TMbndAbstractMethodContainer >> lookupSelector: aSelector [
	^ nil
]
