Class {
	#name : #SYMLNamedProgramEntity,
	#superclass : #SYMLProgramEntity,
	#instVars : [
		'name',
		'module',
		'definitionEnvironment',
		'sysmelMangledValue'
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
SYMLNamedProgramEntity >> sysmelMangledValue [
	^ sysmelMangledValue ifNil: [sysmelMangledValue := ByteString streamContents: [:out |
			out nextPut: $n;
				print: self mangledName size;
				nextPutAll: self mangledName
		]
	]
]

{ #category : #accessing }
SYMLNamedProgramEntity >> tryToAddToParentWithName: aNewName [
	parent addSymbol: aNewName value: self.
]

{ #category : #accessing }
SYMLNamedProgramEntity >> validName [
	^ name ifNil: [ parent allocateAnonName ]
]
