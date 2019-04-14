"
A MbndLexicalScopeTest is a test class for testing the behavior of MbndLexicalScope
"
Class {
	#name : #MbndLexicalScopeTest,
	#superclass : #TestCase,
	#category : #'SysmelMoebiusMetamodel-Core-Tests-Scope'
}

{ #category : #tests }
MbndLexicalScopeTest >> testAddInvalidSymbolBinding [
	| scope |
	scope := MbndLexicalScope empty.
	self should: [
		scope addSymbol: #test binding: 42 ifPresent: nil
	] raise: Error
]

{ #category : #tests }
MbndLexicalScopeTest >> testAddParentSymbol [
	| scope binding parentScope |
	binding := MbndValue new value: 42.
	parentScope := MbndLexicalScope empty
		addSymbol: #test binding: binding;
		yourself.

	scope := MbndLexicalScope parent: parentScope.
	self assert: (scope lookupSymbol: #test) equals: nil.
	self assert: (scope lookupSymbolRecursively: #test ifAbsent: [self error]) equals: binding.
]

{ #category : #tests }
MbndLexicalScopeTest >> testAddSymbol [
	| scope binding |
	scope := MbndLexicalScope empty.
	binding := MbndValue new value: 42.
	scope addSymbol: #test binding: binding.
	self assert: (scope lookupSymbol: #test) equals: binding.
	self assert: (scope lookupSymbolRecursively: #test ifAbsent: [self error]) equals: binding.
]

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
