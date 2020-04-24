Trait {
	#name : #TMbndGlobalVariable,
	#traits : 'TMbndProgramEntity',
	#classTraits : 'TMbndProgramEntity classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-Module'
}

{ #category : #'as yet unclassified' }
TMbndGlobalVariable >> accept: aVisitor [
	^ aVisitor visitGlobalVariable: self
]
