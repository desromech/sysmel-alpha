Trait {
	#name : #TMbndNamespace,
	#traits : 'TMbndProgramEntity',
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #'as yet unclassified' }
TMbndNamespace >> accept: aVisitor [
	^ aVisitor visitNamespace: self
]

{ #category : #'as yet unclassified' }
TMbndNamespace >> canHaveNamespaces [
	^ true
]

{ #category : #testing }
TMbndNamespace >> hasPublicOrExternalVisibility [
	^ true
]

{ #category : #'as yet unclassified' }
TMbndNamespace >> isNamespace [
	^ true
]

{ #category : #scope }
TMbndNamespace >> programEntityScopeClass [
	^ MbndNamespaceScope
]
