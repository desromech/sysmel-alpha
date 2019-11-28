Trait {
	#name : #TMbndMethodContainer,
	#instVars : [
		'overloadedMethodDict',
		'methodDict'
	],
	#traits : 'TMbndAbstractMethodContainer',
	#classTraits : 'TMbndAbstractMethodContainer classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #adding }
TMbndMethodContainer >> addOverloadedMethod: method [
	self assert: method boundType isNotNil.
	self assert: method boundType isFunctionType.
	method typedSelector ifNotNil: [ :typedSelector |
		self methodDict at: typedSelector put: method
	].
	self overloadedMethodDict at: method name ifPresent: [ :existent |
		| methodGroup|
		methodGroup := existent.
		existent isMethodGroup ifFalse: [ 
			methodGroup := MbndFunctionGroup new
				name: existent name;
				addOverloadedEntity: existent;
				yourself.
			self addChild: methodGroup.
			self overloadedMethodDict at: method name put: methodGroup.
		].
		methodGroup addOverloadedEntity: method
	] ifAbsentPut: [ method ].
]

{ #category : #methods }
TMbndMethodContainer >> lookupLocalOverloadedSelector: aSelector [
	^ self overloadedMethodDict at: aSelector ifAbsent: [ nil ].
]

{ #category : #methods }
TMbndMethodContainer >> lookupLocalSelector: aSelector [
	^ self methodDict at: aSelector ifAbsent: [ nil ].
]

{ #category : #methods }
TMbndMethodContainer >> lookupOverloadedSelector: aSelector [
	^ self lookupLocalOverloadedSelector: aSelector
]

{ #category : #methods }
TMbndMethodContainer >> lookupSelector: aSelector [
	^ self lookupLocalSelector: aSelector
]

{ #category : #accessing }
TMbndMethodContainer >> methodDict [
	^ methodDict ifNil: [ methodDict := Dictionary new ]
]

{ #category : #accessing }
TMbndMethodContainer >> overloadedMethodDict [
	^ overloadedMethodDict ifNil: [ overloadedMethodDict := Dictionary new ]
]
