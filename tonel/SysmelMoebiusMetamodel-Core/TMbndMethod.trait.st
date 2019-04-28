Trait {
	#name : #TMbndMethod,
	#traits : 'TMbndProgramEntity',
	#classTraits : 'TMbndProgramEntity classTrait',
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

{ #category : #testing }
TMbndMethod >> isMethodGroup [
	^ false
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
