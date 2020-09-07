Extension { #name : #MbndAggregateTypeWithFields }

{ #category : #'*SysmelCalypso' }
MbndAggregateTypeWithFields >> buildRingDefinitionFor: aRGEnvironment [
	| def metaclassDef |
	def := super buildRingDefinitionFor: aRGEnvironment.
	metaclassDef := def metaclass.
	name isMbndAnonymousSymbol ifTrue: [ ^ nil ].
		
	self isTrait ifFalse: [
		fields do: [ :each |
			each name isMbndAnonymousSymbol ifFalse: [
				def layout addSlot: (RGInstanceVariableSlot named: each name parent: def layout)
			]
		].
	
		type fields do: [ :each |
			each name isMbndAnonymousSymbol ifFalse: [
				metaclassDef layout addSlot: (RGInstanceVariableSlot named: each name parent: metaclassDef layout)
			]
		].
	].

	^ def
]
