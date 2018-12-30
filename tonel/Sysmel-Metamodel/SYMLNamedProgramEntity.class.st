Class {
	#name : #SYMLNamedProgramEntity,
	#superclass : #SYMLProgramEntityWithLocation,
	#instVars : [
		'name',
		'sysmelMangledValue',
		'fullUnmangledName'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #accessing }
SYMLNamedProgramEntity >> ensureSemanticAnalysis [
	self module addPendingSemanticAnalysis: self
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

{ #category : #testing }
SYMLNamedProgramEntity >> hasDontCareName [
	^ name = '_'
]

{ #category : #initialization }
SYMLNamedProgramEntity >> initializeWithValidName [
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
	self initializeWithValidName.
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
	self ensureSemanticAnalysis
]

{ #category : #accessing }
SYMLNamedProgramEntity >> validName [
	^ name ifNil: [ parent allocateAnonName ]
]
