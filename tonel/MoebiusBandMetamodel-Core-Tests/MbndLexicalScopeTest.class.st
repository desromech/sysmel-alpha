"
A MbndLexicalScopeTest is a test class for testing the behavior of MbndLexicalScope
"
Class {
	#name : #MbndLexicalScopeTest,
	#superclass : #TestCase,
	#category : #'MoebiusBandMetamodel-Core-Tests-Scope'
}

{ #category : #tests }
MbndLexicalScopeTest >> testEmptyLookup [
	| scope |
	scope := MbndLexicalScope empty.
	self assert: (scope lookupMacroSelector: #return:) equals: nil.
	self assert: (scope lookupSymbol: #undefined) equals: nil.
	self assert: (scope lookupSymbolRecursively: #undefined ifAbsent: [nil] ) equals: nil.
]

{ #category : #tests }
MbndLexicalScopeTest >> testNew [
	| scope |
	scope := MbndLexicalScope empty.
	self assert: scope symbolTable isEmpty.
	self assert: scope returnType isNil.
	self assert: scope returnContextScope isNil.
]
