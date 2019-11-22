Class {
	#name : #MbndAbstractMethodGroup,
	#superclass : #MbndAbstractMethod,
	#instVars : [
		'overloadedEntities'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #adding }
MbndAbstractMethodGroup >> addOverloadedEntity: entity [
	overloadedEntities add: entity.
]

{ #category : #'as yet unclassified' }
MbndAbstractMethodGroup >> analyzeExpandedMessageSendNode: node with: analyzer [
	| receiverType matchingMethod |
	receiverType := node receiver ifNil: [ self compilationTarget voidType ] ifNotNil: [ :r | r type ].
	self assert: receiverType isNotNil.
	
	matchingMethod := self findSingleOverloadedEntityMatchingArguments: node arguments withReceiverType: receiverType with: analyzer at: node.
	^ matchingMethod analyzeExpandedMessageSendNode: node with: analyzer
]

{ #category : #'as yet unclassified' }
MbndAbstractMethodGroup >> analyzeFunctionCallNode: node with: analyzer [
	| receiverType matchingEntity newBinding newCallNode |
	self flag: 'TODO: Support a receiver type in this location.'.
	receiverType := analyzer compilationTarget voidType.
	matchingEntity := self findSingleOverloadedEntityMatchingArguments: node arguments withReceiverType: receiverType with: analyzer at: node.
	
	newBinding := node function copy
		binding: matchingEntity;
		type: matchingEntity type ref.
	newCallNode := node copy function: newBinding.
	^ analyzer visitNode: newCallNode
]

{ #category : #evaluation }
MbndAbstractMethodGroup >> evaluateWithReceiver: receiver arguments: arguments withEvaluator: evaluator at: node [
	self error: 'Cannot evaluate a method/function group with arguments.'
]

{ #category : #'as yet unclassified' }
MbndAbstractMethodGroup >> findMatchingPrototypeNode: functionPrototype withReceiverType: prototypeReceiverType [
	overloadedEntities do: [ :entity |
		(entity matchesPrototypeNode: functionPrototype withReceiverType: prototypeReceiverType) ifTrue: [ 			^ entity
		]
	].

	^ nil
]

{ #category : #'as yet unclassified' }
MbndAbstractMethodGroup >> findSingleOverloadedEntityMatchingArguments: arguments withReceiverType: receiverType with: analyzer at: node [
	| bestMatchingCost bestMatchingCandidates entityCost |
	bestMatchingCost := Float infinity.
	bestMatchingCandidates := OrderedCollection new.
	
	overloadedEntities do: [ :entity |
		entityCost := entity computeMatchingCostWithArguments: arguments receiverType: receiverType analyzer: analyzer at: node.
		entityCost ifNotNil: [ 
			entityCost < bestMatchingCost ifTrue: [ 
				bestMatchingCandidates removeAll.
				bestMatchingCandidates add: entity.
				bestMatchingCost := entityCost
			] ifFalse: [
				entityCost = bestMatchingCost ifTrue: [ 
					bestMatchingCandidates add: entity.
				]
			]
		].
	].

	bestMatchingCandidates ifEmpty: [
		self error: 'Failed to find a matching overladed function for "{1}".' format: { name asPrettySymbolName } at: node
	].

	bestMatchingCandidates size ~= 1 ifTrue: [ 
		
	self error: (ByteString streamContents: [:out |
			out nextPutAll: ('Ambiguous matching overloaded functions for "{1}". The matching candidates have the following types:' format: {name asPrettySymbolName}); lf.
			bestMatchingCandidates do: [ :candidate |
				out tab; nextPutAll: candidate boundType asString; lf.
			].
		]) at: node
	].

	^ bestMatchingCandidates first
]

{ #category : #adding }
MbndAbstractMethodGroup >> initialize [
	super initialize.
	overloadedEntities := OrderedCollection new.
]

{ #category : #testing }
MbndAbstractMethodGroup >> isMethodGroup [
	^ true
]

{ #category : #accessing }
MbndAbstractMethodGroup >> type [
	^ self compilationTarget functionGroupType
]
