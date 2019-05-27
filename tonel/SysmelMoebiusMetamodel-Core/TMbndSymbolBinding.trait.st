Trait {
	#name : #TMbndSymbolBinding,
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #'semantic analysis' }
TMbndSymbolBinding >> analyzeReferenceNode: referenceNode with: analyzer [
	self explicitRequirement
]

{ #category : #converting }
TMbndSymbolBinding >> asCompileTimeValueReferenceOfType: referenceType withEvaluator: evaluator at: node [
	self explicitRequirement
]

{ #category : #converting }
TMbndSymbolBinding >> asSymbolBoundWithReceiverBinding: receiverBinding [
	^ nil
]

{ #category : #converting }
TMbndSymbolBinding >> evaluateLocalDefinition: node withEvaluator: evaluator [
	self explicitRequirement
]

{ #category : #testing }
TMbndSymbolBinding >> isMbndSymbolBinding [
	^ true
]
