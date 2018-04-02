Class {
	#name : #SYMLLocalVariable,
	#superclass : #SYMLNamedProgramEntity,
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #accessing }
SYMLLocalVariable >> name: aNewName [
	<compileTime>
	definitionEnvironment ifNotNil: [
		definitionEnvironment addSymbol: aNewName value: self.
	].
	name := aNewName.

]
