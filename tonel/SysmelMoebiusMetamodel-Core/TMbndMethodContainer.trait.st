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
	self overloadedMethodDict at: method name ifPresent: [ :existent |
		self halt
	] ifAbsentPut: [ method ]
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
