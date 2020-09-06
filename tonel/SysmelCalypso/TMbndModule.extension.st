Extension { #name : #TMbndModule }

{ #category : #'*SysmelCalypso' }
TMbndModule >> emitSmalltalkClassDeclarationsIntoRGEnvironment: environment package: rgpackage [
	| topLevelElements |
	topLevelElements := OrderedCollection new.
	self compilationTarget coreDefinitionsModule == self ifTrue: [
		topLevelElements addAll: (self compilationTarget basicTypes)
	].

	topLevelElements addAll: globalNamespace children.
	
	(globalNamespace lookupSymbol: #Smalltalk) ifNotNil: [:nspace |
		topLevelElements addAll: nspace children.
	].

	topLevelElements select: [ :each | each isMbndType or: [ each isNamespace ] ]
		thenDo: [ :each |
		(each ensureRingDefinitionIn: environment) ifNotNil: [:ringDefinition |
			ringDefinition
				package: rgpackage.
			each category ifNotNil: [ :cat |
				ringDefinition category: cat 
			]. 
		].
	]

]
