Trait {
	#name : #TMbndMethod,
	#traits : 'TMbndProgramEntity + TMbndFlagContainer',
	#classTraits : 'TMbndProgramEntity classTrait + TMbndFlagContainer classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #'semantic analysis' }
TMbndMethod >> analyzeExpandedMessageSendNode: node with: analyzer [
	self explicitRequirement
]

{ #category : #accessing }
TMbndMethod >> argumentTypes [
	^ self boundType argumentTypes
]

{ #category : #accessing }
TMbndMethod >> boundType [
	^ self type
]

{ #category : #evaluation }
TMbndMethod >> evaluateWithReceiver: receiver arguments: arguments withEvaluator: evaluator at: node [
	self explicitRequirement
]

{ #category : #'as yet unclassified' }
TMbndMethod >> isMethod [
	^ true
]

{ #category : #testing }
TMbndMethod >> isMethodGroup [
	^ false
]

{ #category : #'as yet unclassified' }
TMbndMethod >> lookupBoundReceiverSymbol: aSymbol [
	^ nil
]

{ #category : #accessing }
TMbndMethod >> receiverType [
	^ nil
]

{ #category : #accessing }
TMbndMethod >> returnType [
	^ self boundType returnType
]

{ #category : #accessing }
TMbndMethod >> type [
	self explicitRequirement
]
