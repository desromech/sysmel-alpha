Extension { #name : #MbndBasicType }

{ #category : #'*SysmelCalypso' }
MbndBasicType >> buildRingDefinitionFor: aRGEnvironment [
	| def metaclassDef |
	def := aRGEnvironment ensureClassNamed: name asSymbol.
	metaclassDef := aRGEnvironment ensureClassNamed: (name, ' class') asSymbol.
	def metaclass: metaclassDef.
	def traitComposition: (RGTraitComposition parent: def).
	metaclassDef traitComposition: (RGTraitComposition parent: metaclassDef).
	(supertype isNotNil and: [supertype name isMbndAnonymousSymbol not])
		ifTrue: [ def superclass: (aRGEnvironment ensureClassNamed: supertype name) ]
		ifFalse: [ def superclass: nil ].

	self type supertype isMetaType ifTrue: [ 
		metaclassDef superclass: (aRGEnvironment ensureClassNamed: self type supertype instanceType name asSymbol).
	] ifFalse: [ 
		metaclassDef superclass: (aRGEnvironment ensureClassNamed: self type supertype name asSymbol).
	].
	metaclassDef metaclass: (aRGEnvironment ensureClassNamed: self type type name asSymbol).
		
	def layout: (RGFixedLayout parent: def).
	metaclassDef layout: (RGFixedLayout parent: metaclassDef).

	^ def
]

{ #category : #'*SysmelCalypso' }
MbndBasicType >> ensureRingDefinitionIn: aRGEnvironment [
	name isMbndAnonymousSymbol ifTrue: [ ^ nil ].
	^ aRGEnvironment backend definitionFor: self ifAbsentRegister: [
		self buildRingDefinitionFor: aRGEnvironment
	]
]
