Extension { #name : #MbndStandaloneModule }

{ #category : #'*SysmelCalypso' }
MbndStandaloneModule >> addSmalltalkPackageFromDirectory: directory intoRGEnvironment: environment [
	| packageFileReference packageName package |
	packageFileReference := directory / 'package.st'.
	packageFileReference isFile ifFalse: [ ^ self ].
	
	packageName := directory basename asSymbol.
	package := environment ensurePackageNamed: packageName.
	
	directory children
		select: [ :each | each isFile
			and: [ each extension = 'st'
			and: [ each ~= packageFileReference ] ] ]
		thenDo: [ :each |
		(each readStreamDo: [ :in | TonelParser parseStream: in ])
			do: [ :def | def ensureRingDefinitionIn: environment package: package ]
	]
]

{ #category : #'*SysmelCalypso' }
MbndStandaloneModule >> addSmalltalkPackagesFromFileSystemIntoRGEnvironment: environment [
	sourceLocations do: [ :eachLocation |
		eachLocation children do: [ :eachChild |
			eachChild isDirectory ifTrue: [
				self addSmalltalkPackageFromDirectory: eachChild intoRGEnvironment: environment
			]
		]
	].
]
