Class {
	#name : #MbndLexicalScope,
	#superclass : #MbndAbstractScope,
	#instVars : [
		'metaMethods',
		'symbols'
	],
	#category : #'MoebiusBandMetamodel-Core-Scope'
}

{ #category : #initialization }
MbndLexicalScope >> initialize [
	super initialize.
	symbols := Dictionary new.
	metaMethods := Dictionary new.
]

{ #category : #accessing }
MbndLexicalScope >> metaMethods [
	^ metaMethods
]

{ #category : #accessing }
MbndLexicalScope >> symbols [
	^ symbols
]
