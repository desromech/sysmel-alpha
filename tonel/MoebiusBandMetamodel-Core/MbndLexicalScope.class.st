Class {
	#name : #MbndLexicalScope,
	#superclass : #MbndAbstractScope,
	#instVars : [
		'symbolTable'
	],
	#category : #'MoebiusBandMetamodel-Core-Scope'
}

{ #category : #initialization }
MbndLexicalScope >> initialize [
	super initialize.
	symbolTable := Dictionary new.
]

{ #category : #'macro expansion' }
MbndLexicalScope >> lookupSymbol: aSymbol [
	^ symbolTable at: aSymbol ifAbsent: [ nil ]
]

{ #category : #accessing }
MbndLexicalScope >> symbolTable [
	^ symbolTable
]
