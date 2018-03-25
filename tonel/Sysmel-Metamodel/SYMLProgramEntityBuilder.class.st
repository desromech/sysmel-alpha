Class {
	#name : #SYMLProgramEntityBuilder,
	#superclass : #SYMLObject,
	#instVars : [
		'definitionEnvironment',
		'flags',
		'sourcePosition'
	],
	#category : #Sysmel-Metamodel-MetaBuilders
}

{ #category : #accessing }
SYMLProgramEntityBuilder >> addFlag: aFlag [
	flags := (flags copyWithout: aFlag) copyWith: aFlag
]

{ #category : #accessing }
SYMLProgramEntityBuilder >> compilationTarget [
	^ definitionEnvironment compilationTarget
]

{ #category : #accessing }
SYMLProgramEntityBuilder >> definitionEnvironment [
	^ definitionEnvironment
]

{ #category : #accessing }
SYMLProgramEntityBuilder >> definitionEnvironment: anObject [
	definitionEnvironment := anObject
]

{ #category : #accessing }
SYMLProgramEntityBuilder >> flags [
	^ flags
]

{ #category : #accessing }
SYMLProgramEntityBuilder >> flags: anObject [
	flags := anObject
]

{ #category : #accessing }
SYMLProgramEntityBuilder >> hasFlag: aFlag [
	^ flags includes: aFlag
]

{ #category : #initialization }
SYMLProgramEntityBuilder >> initialize [
	super initialize.
	flags := #().
	
]

{ #category : #accessing }
SYMLProgramEntityBuilder >> sourcePosition [
	^ sourcePosition
]

{ #category : #accessing }
SYMLProgramEntityBuilder >> sourcePosition: anObject [
	sourcePosition := anObject
]
