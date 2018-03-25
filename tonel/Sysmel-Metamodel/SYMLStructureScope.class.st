Class {
	#name : #SYMLStructureScope,
	#superclass : #SYMLAbstractScope,
	#instVars : [
		'structure'
	],
	#category : #Sysmel-Metamodel-Semantic
}

{ #category : #variables }
SYMLStructureScope >> lookSymbol: identifier ifPresent: aBlock [
	^ structure lookSymbol: identifier ifPresent: aBlock
]

{ #category : #variables }
SYMLStructureScope >> lookSymbol: identifier ifPresent: ifPresentBlock ifAbsentPut: ifAbsentBlock [
	^ structure lookSymbol: identifier ifPresent: ifPresentBlock ifAbsentPut: ifAbsentBlock
]

{ #category : #accessing }
SYMLStructureScope >> structure [
	^ structure
]

{ #category : #accessing }
SYMLStructureScope >> structure: anObject [
	structure := anObject
]
