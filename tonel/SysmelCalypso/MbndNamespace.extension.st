Extension { #name : #MbndNamespace }

{ #category : #'*SysmelCalypso' }
MbndNamespace >> ensureRingDefinitionIn: aRGEnvironment [
	name isMbndAnonymousSymbol ifTrue: [ ^ nil ].
	self importedNamespaces ifNotEmpty: [ ^ nil ].
	^ aRGEnvironment backend definitionFor: self ifAbsentRegister: [
		| def |
		def := aRGEnvironment ensureClassNamed: name asSymbol.
		def metaclass: (aRGEnvironment ensureClassNamed: self type name).
		def superclass: nil.
		def traitComposition: (RGTraitComposition parent: def).
		def layout: (RGFixedLayout parent: def).

		def
	]
]
