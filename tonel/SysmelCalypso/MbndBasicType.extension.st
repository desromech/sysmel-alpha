Extension { #name : #MbndBasicType }

{ #category : #'*SysmelCalypso' }
MbndBasicType >> ensureRingDefinitionIn: aRGEnvironment [
	name isMbndAnonymousSymbol ifTrue: [ ^ nil ].
	^ aRGEnvironment backend definitionFor: self ifAbsentRegister: [
		| def metaclassDef |
		def := aRGEnvironment ensureClassNamed: name asSymbol.
		metaclassDef := aRGEnvironment ensureClassNamed: (name, ' class') asSymbol.
		def metaclass: metaclassDef.
		def traitComposition: (RGTraitComposition parent: def).
		metaclassDef traitComposition: (RGTraitComposition parent: metaclassDef).
		(supertype isNotNil and: [supertype name isMbndAnonymousSymbol not])
			ifTrue: [ def superclass: (aRGEnvironment ensureClassNamed: supertype name) ]
			ifFalse: [ def superclass: nil ].

		def layout: (RGFixedLayout parent: def).
		metaclassDef layout: (RGFixedLayout parent: metaclassDef).

		def
	]
]
