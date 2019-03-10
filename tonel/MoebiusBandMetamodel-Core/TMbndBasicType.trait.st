Trait {
	#name : #TMbndBasicType,
	#instVars : [
		'overloadedMethodDict'
	],
	#traits : 'TMbndType',
	#classTraits : 'TMbndType classTrait',
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #accessing }
TMbndBasicType >> overloadedMethodDict [
	^ overloadedMethodDict ifNil: [ overloadedMethodDict := Dictionary new ]
]
