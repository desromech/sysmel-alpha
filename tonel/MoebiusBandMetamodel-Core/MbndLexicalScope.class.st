Class {
	#name : #MbndLexicalScope,
	#superclass : #MbndAbstractScope,
	#instVars : [
		'symbols'
	],
	#category : #'MoebiusBandMetamodel-Core-Scope'
}

{ #category : #initialization }
MbndLexicalScope >> initialize [
	super initialize.
	symbols := Dictionary new.
]

{ #category : #accessing }
MbndLexicalScope >> symbols [
	^ symbols
]
