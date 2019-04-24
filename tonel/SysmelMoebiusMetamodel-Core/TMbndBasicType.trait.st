Trait {
	#name : #TMbndBasicType,
	#instVars : [
		'supertype',
		'type'
	],
	#traits : 'TMbndType + TMbndMethodContainer + TMbndObjectWithFlags',
	#classTraits : 'TMbndType classTrait + TMbndMethodContainer classTrait + TMbndObjectWithFlags classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'macro expansion' }
TMbndBasicType >> lookupOverloadedSelector: aSelector [
	| method |
	method := self overloadedMethodDict at: aSelector ifAbsent: [ nil ].
	method ifNotNil: [ ^ method ].
	^ self supertype ifNotNil: [ :st | st lookupOverloadedSelector: aSelector ]
]

{ #category : #'macro expansion' }
TMbndBasicType >> lookupSelector: aSelector [
	| method |
	method := self methodDict at: aSelector ifAbsent: [ nil ].
	method ifNotNil: [ ^ method ].
	^ self supertype ifNotNil: [ :st | st lookupSelector: aSelector ]
]

{ #category : #'type hierarchy' }
TMbndBasicType >> supertype [
	^ supertype
]

{ #category : #accessing }
TMbndBasicType >> supertype: aType [
	supertype ifNotNil: [
		supertype subtypeRemoved: self
	].

	supertype := aType.
	
	supertype ifNotNil: [
		supertype subtypeAdded: self
	].

]

{ #category : #'type hierarchy' }
TMbndBasicType >> type [
	^ type
]

{ #category : #accessing }
TMbndBasicType >> type: aType [
	type := aType
]
