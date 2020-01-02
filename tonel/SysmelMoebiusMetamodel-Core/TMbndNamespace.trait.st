Trait {
	#name : #TMbndNamespace,
	#traits : 'TMbndProgramEntity',
	#classTraits : 'TMbndProgramEntity classTrait',
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

{ #category : #accessing }
TMbndNamespace >> getPublicMetaBuilderFactoryList [
	^ { 
		#macro . MbndMacroMetaBuilder metaBuilderFactory.
		#method . MbndMethodMetaBuilder metaBuilderFactory.
	} ,  self getExtraMetaBuilderFactoryList
]

{ #category : #'as yet unclassified' }
TMbndNamespace >> isNamespace [
	^ true
]

{ #category : #scope }
TMbndNamespace >> programEntityScopeClass [
	^ MbndNamespaceScope
]
