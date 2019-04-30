Trait {
	#name : #TMbndObjectWithFlags,
	#instVars : [
		'flags'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Utility'
}

{ #category : #flags }
TMbndObjectWithFlags >> addFlag: aFlag [
	flags := (flags copyWithout: aFlag) copyWith: aFlag
]

{ #category : #accessing }
TMbndObjectWithFlags >> flags [
	^ flags
]

{ #category : #accessing }
TMbndObjectWithFlags >> flags: anArrayOfFlags [
	self assert: anArrayOfFlags isArray.
	flags := anArrayOfFlags
]

{ #category : #flags }
TMbndObjectWithFlags >> hasFlag: aFlags [
	flags ifNil: [ ^ false ].
	^ flags includes: aFlags
]

{ #category : #flags }
TMbndObjectWithFlags >> removeFlag: aFlag [
	flags := (flags copyWithout: aFlag) copyWith: aFlag
]
