Class {
	#name : #SYMLLexicalScope,
	#superclass : #SYMLAbstractScope,
	#instVars : [
		'symbols'
	],
	#category : #'Sysmel-Metamodel-Scope'
}

{ #category : #adding }
SYMLLexicalScope >> addSymbol: symbol value: value [
	symbols at: symbol ifPresent: [ :existent |
		self error: 'Trying to override top-level symbol {1} with value {2}.' format: { symbol printString . value }
	] ifAbsentPut: [ value ]
]

{ #category : #initialization }
SYMLLexicalScope >> initialize [
	super initialize.
	symbols := Dictionary new.
	
]

{ #category : #'as yet unclassified' }
SYMLLexicalScope >> lookSymbol: symbol ifPresent: ifPresentBlock [
	symbols at: symbol ifPresent: ifPresentBlock
	
]
