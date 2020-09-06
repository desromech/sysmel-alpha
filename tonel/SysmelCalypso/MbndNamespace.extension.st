Extension { #name : #MbndNamespace }

{ #category : #'*SysmelCalypso' }
MbndNamespace >> ensureRingDefinitionIn: aRGEnvironment [
	name isMbndAnonymousSymbol ifTrue: [ ^ nil ].
	self importedNamespaces ifNotEmpty: [ ^ nil ].
	^ aRGEnvironment backend definitionFor: self ifAbsentRegister: [
		| def metaclassDef |
		def := aRGEnvironment ensureClassNamed: name asSymbol.
		metaclassDef := aRGEnvironment ensureClassNamed: (name, ' class') asSymbol.
		def metaclass: (aRGEnvironment ensureClassNamed: self type name).
		def superclass: nil.

		def layout: (RGFixedLayout parent: def).
		metaclassDef layout: (RGFixedLayout parent: metaclassDef).

		def
	]
]
