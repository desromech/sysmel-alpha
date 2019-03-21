"
A MbndLexicalScopeTest is a test class for testing the behavior of MbndLexicalScope
"
Class {
	#name : #MbndLexicalScopeTest,
	#superclass : #TestCase,
	#category : #'MoebiusBandMetamodel-Core-Tests-Scope'
}

{ #category : #tests }
MbndLexicalScopeTest >> testNew [
	| scope |
	scope := MbndLexicalScope empty.
	self assert: scope symbols isEmpty.
	self assert: scope metaMethods isEmpty.
]
