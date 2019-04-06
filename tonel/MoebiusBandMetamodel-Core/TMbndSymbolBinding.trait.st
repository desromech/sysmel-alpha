Trait {
	#name : #TMbndSymbolBinding,
	#category : #'MoebiusBandMetamodel-Core-Variables'
}

{ #category : #'semantic analysis' }
TMbndSymbolBinding >> analyzeReferenceNode: referenceNode with: analyzer [
	self explicitRequirement
]

{ #category : #testing }
TMbndSymbolBinding >> isMbndSymbolBinding [
	^ true
]
