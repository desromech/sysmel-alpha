Trait {
	#name : #TMbndFlagContainer,
	#instVars : [
		'flags'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Object'
}

{ #category : #flags }
TMbndFlagContainer >> addFlag: aFlag [
	flags := (self flags copyWithout: aFlag) copyWith: aFlag
]

{ #category : #flags }
TMbndFlagContainer >> addFlags: aCollectionOfFlags [
	aCollectionOfFlags do: [ :flag | self addFlag: flag ]
]

{ #category : #accessing }
TMbndFlagContainer >> flags [
	^ flags ifNil: [ flags := #() ]
]

{ #category : #accessing }
TMbndFlagContainer >> flags: anArrayOfFlags [
	self assert: anArrayOfFlags isArray.
	flags := anArrayOfFlags
]

{ #category : #flags }
TMbndFlagContainer >> hasFlag: aFlags [
	flags ifNil: [ ^ false ].
	^ flags includes: aFlags
]

{ #category : #flags }
TMbndFlagContainer >> removeFlag: aFlag [
	flags := self flags copyWithout: aFlag
]

{ #category : #flags }
TMbndFlagContainer >> setFlag: flag value: value [
	value
		ifTrue: [ self addFlag: flag ]
		ifFalse: [ self removeFlag: flag ]
]
