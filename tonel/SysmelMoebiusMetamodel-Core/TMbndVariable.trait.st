Trait {
	#name : #TMbndVariable,
	#traits : 'TMbndAbstractProgramEntity + TMbndFlagContainer',
	#classTraits : 'TMbndAbstractProgramEntity classTrait + TMbndFlagContainer classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #testing }
TMbndVariable >> isFieldVariable [
	^ false
]

{ #category : #testing }
TMbndVariable >> isVariable [
	^ true
]

{ #category : #accessing }
TMbndVariable >> name [
	self explicitRequirement
]

{ #category : #accessing }
TMbndVariable >> type [
	self explicitRequirement
]

{ #category : #accessing }
TMbndVariable >> valueType [
	self explicitRequirement
]
