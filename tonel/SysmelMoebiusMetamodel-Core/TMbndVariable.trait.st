Trait {
	#name : #TMbndVariable,
	#traits : 'TMbndSymbolBinding',
	#classTraits : 'TMbndSymbolBinding classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

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
