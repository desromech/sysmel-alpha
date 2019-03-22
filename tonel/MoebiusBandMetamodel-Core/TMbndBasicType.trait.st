Trait {
	#name : #TMbndBasicType,
	#instVars : [
		'overloadedMethodDict',
		'supertype',
		'type'
	],
	#traits : 'TMbndType',
	#classTraits : 'TMbndType classTrait',
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #'macro expansion' }
TMbndBasicType >> lookupMacroSelector: aSelector [
	| macro |
	macro := self macroMethodDict at: aSelector ifAbsent: [ nil ]..
	macro ifNotNil: [ ^ macro ].
	^ self supertype ifNotNil: [ :st | st lookupMacroSelector: aSelector ]
]

{ #category : #accessing }
TMbndBasicType >> overloadedMethodDict [
	^ overloadedMethodDict ifNil: [ overloadedMethodDict := Dictionary new ]
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
