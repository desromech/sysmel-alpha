Class {
	#name : #MbndSequenceableAggregateType,
	#superclass : #MbndAggregateType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndSequenceableAggregateType class >> typeName [
	^ #_SequenceableAggregatType
]

{ #category : #initialization }
MbndSequenceableAggregateType >> addInstanceMacros [
	| ordinalSelectors |
	self class == MbndSequenceableAggregateType ifFalse: [ ^ self ].
	self isTrait ifFalse: [ ^ self ].
	
	ordinalSelectors := #(
		first second third fourth fifth sixth seventh eighth ninth tenth
	).
	self
		onMacroSelectors: ordinalSelectors do: [ :node :builder |
			(builder unexpandedSend: ((builder literalSymbol: #at:) position: node) to: node receiver withArguments: {
				builder literalInteger: (ordinalSelectors indexOf: node selector value)
			})
				position: node
		]
]
