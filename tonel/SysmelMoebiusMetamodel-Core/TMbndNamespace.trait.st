Trait {
	#name : #TMbndNamespace,
	#traits : 'TMbndProgramEntity',
	#classTraits : 'TMbndProgramEntity classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-ProgramEntity'
}

{ #category : #testing }
TMbndNamespace >> canHaveNamespaces [
	^ true
]

{ #category : #testing }
TMbndNamespace >> isNamespace [
	^ true
]

{ #category : #scope }
TMbndNamespace >> programEntityScopeClass [
	^ MbndNamespaceScope
]
