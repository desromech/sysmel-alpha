Trait {
	#name : #TMbndGlobalVariable,
	#traits : 'TMbndProgramEntity',
	#category : #'SysmelMoebiusMetamodel-Core-Module'
}

{ #category : #'as yet unclassified' }
TMbndGlobalVariable >> accept: aVisitor [
	^ aVisitor visitGlobalVariable: self
]
