Trait {
	#name : #TMbndMethodContainer,
	#instVars : [
		'overloadedMethodDict',
		'methodDict'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #adding }
TMbndMethodContainer >> addOverloadedMethod: method [
	self assert: method boundType isNotNil.
	self assert: method boundType isFunctionType.
	self overloadedMethodDict at: method name ifPresent: [ :existent |
		self halt
	] ifAbsentPut: [ method ]
]

{ #category : #adding }
TMbndMethodContainer >> addOverloadedMethod: method argumentTypes: argumentTypes returnType: returnType [
	| functionType |
	functionType := self compilationTarget functionTypeWithArguments: argumentTypes returnType: returnType.
	^ self addOverloadedMethod: (method copy
		type: functionType;
		boundType: functionType;
		yourself)
]

{ #category : #adding }
TMbndMethodContainer >> addOverloadedMethod: method receiverType: receiverType argumentTypes: argumentTypes returnType: returnType [
	| functionType boundFunctionType |
	boundFunctionType := self compilationTarget functionTypeWithArguments: argumentTypes returnType: returnType.
	functionType := self compilationTarget functionTypeWithArguments: {receiverType} , argumentTypes returnType: returnType.
	^ self addOverloadedMethod: (method copy
		receiverType: receiverType;
		type: functionType;
		boundType: boundFunctionType;
		yourself)
]

{ #category : #methods }
TMbndMethodContainer >> lookupOverloadedSelector: aSelector [
	^ self overloadedMethodDict at: aSelector ifAbsent: [ nil ].
]

{ #category : #methods }
TMbndMethodContainer >> lookupSelector: aSelector [
	^ self methodDict at: aSelector ifAbsent: [ nil ].
]

{ #category : #accessing }
TMbndMethodContainer >> methodDict [
	^ methodDict ifNil: [ methodDict := Dictionary new ]
]

{ #category : #accessing }
TMbndMethodContainer >> overloadedMethodDict [
	^ overloadedMethodDict ifNil: [ overloadedMethodDict := Dictionary new ]
]
