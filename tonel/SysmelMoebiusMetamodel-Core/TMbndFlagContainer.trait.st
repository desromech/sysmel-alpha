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
	flags := (flags copyWithout: aFlag) copyWith: aFlag
]
