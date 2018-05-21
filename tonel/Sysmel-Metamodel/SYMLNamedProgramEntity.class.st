Class {
	#name : #SYMLNamedProgramEntity,
	#superclass : #SYMLProgramEntity,
	#instVars : [
		'name',
		'module',
		'definitionPosition',
		'definitionNode',
		'definitionEnvironment',
		'sysmelMangledValue',
		'fullUnmangledName'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #accessing }
SYMLNamedProgramEntity >> compilationTarget [
	^ module compilationTarget
]

{ #category : #accessing }
SYMLNamedProgramEntity >> definitionEnvironment [
	^ definitionEnvironment
]

{ #category : #accessing }
SYMLNamedProgramEntity >> definitionEnvironment: anObject [
	definitionEnvironment := anObject
]

{ #category : #accessing }
SYMLNamedProgramEntity >> definitionNode [
	^ definitionNode
]

{ #category : #accessing }
SYMLNamedProgramEntity >> definitionNode: anObject [
	definitionNode := anObject.
	definitionNode ifNotNil: [ self definitionPosition: definitionNode position ]
]

{ #category : #accessing }
SYMLNamedProgramEntity >> definitionPosition [
	^ definitionPosition
]

{ #category : #accessing }
SYMLNamedProgramEntity >> definitionPosition: anObject [
	definitionPosition := anObject
]

{ #category : #dummy }
SYMLNamedProgramEntity >> ensureShaderInterfaceIsGenerated [
]

{ #category : #accessing }
SYMLNamedProgramEntity >> fullUnmangledName [
	| parentName |
	^ fullUnmangledName ifNil: [fullUnmangledName := ByteString streamContents: [:out |
			parentName := self parentFullUnmangledName.
			parentName ifNotEmpty: [ out nextPutAll: parentName; nextPutAll: '::' ].
			out nextPutAll: self validName
		]
	]
]

{ #category : #accessing }
SYMLNamedProgramEntity >> module [
	^ module
]

{ #category : #accessing }
SYMLNamedProgramEntity >> module: anObject [
	module := anObject
]

{ #category : #accessing }
SYMLNamedProgramEntity >> name [
	<compileTime>
	^ name
]

{ #category : #accessing }
SYMLNamedProgramEntity >> name: aNewName [
	<compileTime>
	parent ifNotNil: [
		self tryToAddToParentWithName: aNewName
	].
	name := aNewName.

]

{ #category : #accessing }
SYMLNamedProgramEntity >> setName: newName ifNewReturnNode: newReturnedNode [
	parent ifNotNil: [ 
		parent lookSymbol: newName ifPresent: [ :existent |
			existent class == self class ifTrue: [ 
				^ existent asAPSGNodeInEnvironment: definitionEnvironment at: newReturnedNode position
			].
		].
	].

	self name: newName.
	^ newReturnedNode
]

{ #category : #accessing }
SYMLNamedProgramEntity >> sysmelMangledValue [
	<compileTime>
	^ sysmelMangledValue ifNil: [sysmelMangledValue := (self sysmelPerform: #createSysmelMangledValue fallbackWith: [
			ByteString streamContents: [:out |
				out nextPut: $n;
					print: self mangledName size;
					nextPutAll: self mangledName
			]
		]) unwrapSysmelValue
	]
]

{ #category : #accessing }
SYMLNamedProgramEntity >> sysmelMangledValue: aValue [
	<compileTime>
	self assert: sysmelMangledValue isNil.
	sysmelMangledValue := aValue
]

{ #category : #accessing }
SYMLNamedProgramEntity >> tryToAddToParentWithName: aNewName [
	parent addSymbol: aNewName value: self.
]

{ #category : #accessing }
SYMLNamedProgramEntity >> validName [
	^ name ifNil: [ parent allocateAnonName ]
]
