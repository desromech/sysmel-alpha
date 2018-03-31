Class {
	#name : #SYMLNamespace,
	#superclass : #SYMLProgramEntity,
	#instVars : [
		'name',
		'module',
		'symbols'
	],
	#category : #Sysmel-Metamodel-Program
}

{ #category : #accessing }
SYMLNamespace >> compilationTarget [
	^ module compilationTarget
]

{ #category : #'semantic analysis' }
SYMLNamespace >> generateSSACode [
	symbols valuesDo: #generateSSACode
]

{ #category : #variables }
SYMLNamespace >> initialize [
	super initialize.
	symbols := SYMLOrderedDictionary new.
	
]

{ #category : #testing }
SYMLNamespace >> isNamespace [
	^ true
]

{ #category : #variables }
SYMLNamespace >> lookSymbol: identifier [
	^ symbols at: identifier
]

{ #category : #variables }
SYMLNamespace >> lookSymbol: identifier ifPresent: aBlock [
	^ symbols at: identifier ifPresent: aBlock
]

{ #category : #variables }
SYMLNamespace >> lookSymbol: identifier ifPresent: ifPresentBlock ifAbsentPut: ifAbsentBlock [
	^ symbols at: identifier ifPresent: ifPresentBlock ifAbsentPut: ifAbsentBlock
]

{ #category : #'semantic analysis' }
SYMLNamespace >> mangledName [
	(parent isNil and: [ name = #__global ]) ifTrue: [ ^ self parentMangledName ].
	^ self parentMangledName , name size asString , name

]

{ #category : #'meta methods' }
SYMLNamespace >> metaMethodForMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition [
	^ nil
]

{ #category : #accessing }
SYMLNamespace >> module [
	^ module
]

{ #category : #accessing }
SYMLNamespace >> module: anObject [
	module := anObject
]

{ #category : #accessing }
SYMLNamespace >> name [
	^ name
]

{ #category : #accessing }
SYMLNamespace >> name: anObject [
	name := anObject
]

{ #category : #'semantic analysis' }
SYMLNamespace >> semanticAnalysis [
	symbols valuesDo: #semanticAnalysis
]
