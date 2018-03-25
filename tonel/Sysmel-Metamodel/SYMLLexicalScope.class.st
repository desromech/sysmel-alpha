Class {
	#name : #SYMLLexicalScope,
	#superclass : #SYMLAbstractScope,
	#instVars : [
		'symbols'
	],
	#category : #Sysmel-Metamodel-Semantic
}

{ #category : #accessing }
SYMLLexicalScope >> findLocalDefinitionScopeFrom: startingPoint [
	^ self
]

{ #category : #initialization }
SYMLLexicalScope >> initialize [
	super initialize.
	symbols := Dictionary new.
]

{ #category : #variables }
SYMLLexicalScope >> lookSymbol: identifier ifPresent: aBlock [
	^ symbols at: identifier ifPresent: aBlock
]

{ #category : #variables }
SYMLLexicalScope >> lookSymbol: identifier ifPresent: ifPresentBlock ifAbsentPut: ifAbsentBlock [
	^ symbols at: identifier ifPresent: ifPresentBlock ifAbsentPut: ifAbsentBlock
]
