Trait {
	#name : #TMbndGlobalVariable,
	#traits : 'TMbndProgramEntity',
	#classTraits : 'TMbndProgramEntity classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-Module'
}

{ #category : #visiting }
TMbndGlobalVariable >> accept: aVisitor [
	^ aVisitor visitGlobalVariable: self
]
