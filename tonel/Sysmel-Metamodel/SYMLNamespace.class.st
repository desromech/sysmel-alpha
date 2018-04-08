Class {
	#name : #SYMLNamespace,
	#superclass : #SYMLNamedProgramEntity,
	#instVars : [
		'symbols'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #adding }
SYMLNamespace >> addSymbol: aSymbol value: newValue [
	symbols at: aSymbol ifPresent: [ :existent |
		self error: 'Trying to override symbol {1} with {2}.' format: { aSymbol printString . newValue printString }
	] ifAbsentPut: [ newValue ]
]

{ #category : #'as yet unclassified' }
SYMLNamespace >> generateSSACode [
	symbols valuesDo: #generateSSACode
]

{ #category : #initialization }
SYMLNamespace >> initialize [
	super initialize.
	symbols := SYMLOrderedDictionary new.
	
]

{ #category : #'as yet unclassified' }
SYMLNamespace >> lookSymbol: symbol ifPresent: ifPresentBlock [
	symbols at: symbol ifPresent: ifPresentBlock
]

{ #category : #accessing }
SYMLNamespace >> name: anObject [
	name := anObject
]

{ #category : #'as yet unclassified' }
SYMLNamespace >> semanticAnalysis [
	symbols valuesDo: #semanticAnalysis
]
