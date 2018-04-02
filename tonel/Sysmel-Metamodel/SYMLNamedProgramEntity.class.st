Class {
	#name : #SYMLNamedProgramEntity,
	#superclass : #SYMLProgramEntity,
	#instVars : [
		'name',
		'module',
		'definitionEnvironment'
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
		parent addSymbol: aNewName value: self.
	].
	name := aNewName.

]

{ #category : #accessing }
SYMLNamedProgramEntity >> validName [
	^ name ifNil: [ 'anon' ]
]
