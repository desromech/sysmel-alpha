Extension { #name : #MbndAggregateTypeWithFields }

{ #category : #'*SysmelCalypso' }
MbndAggregateTypeWithFields >> ensureRingDefinitionIn: aRGEnvironment [
	name isMbndAnonymousSymbol ifTrue: [ ^ nil ].
	^ aRGEnvironment backend definitionFor: self ifAbsentRegister: [
		| def metaclassDef |
		def := aRGEnvironment ensureClassNamed: name asSymbol.
		metaclassDef := aRGEnvironment ensureClassNamed: (name, ' class') asSymbol.
		def metaclass: metaclassDef.
		(supertype isNotNil and: [supertype name isMbndAnonymousSymbol not])
			ifTrue: [ def superclass: (aRGEnvironment ensureClassNamed: supertype name) ]
			ifFalse: [ def superclass: nil ].

		def layout: (RGFixedLayout parent: def).
		metaclassDef layout: (RGFixedLayout parent: metaclassDef).
		def traitComposition: (RGTraitComposition parent: def).
		metaclassDef traitComposition: (RGTraitComposition parent: metaclassDef).
		
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

		def
	]
]
