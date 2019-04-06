"
A MbndGenericMacroLanguageTopLevelScopeTest is a test class for testing the behavior of MbndGenericMacroLanguageTopLevelScope
"
Class {
	#name : #MbndGenericMacroLanguageTopLevelScopeTest,
	#superclass : #TestCase,
	#instVars : [
		'module',
		'builder',
		'scope',
		'analyzer',
		'compilationTarget'
	],
	#category : #'MoebiusBandMetamodel-Core-Tests-Scope'
}

{ #category : #tests }
MbndGenericMacroLanguageTopLevelScopeTest >> setUp [
	super setUp.
	module := MbndDummyModule new.
	compilationTarget := module compilationTarget.
	builder := MbndAstBuilder forModule: module.
	scope := MbndGenericMacroLanguageTopLevelScope for: module.
	analyzer := MbndAstSemanticAnalyzer new scope: scope.
]

{ #category : #tests }
MbndGenericMacroLanguageTopLevelScopeTest >> testBasicTypeLookup [
	| identifier literal |
	identifier := builder identifier: MbndLiteralIntegerType typeName.
	literal := analyzer visitNode: identifier.
	self assert: literal isLiteralValueNode.
	self assert: literal value class equals: MbndLiteralIntegerType.
	self assert: literal type isMetaType.
]

{ #category : #tests }
MbndGenericMacroLanguageTopLevelScopeTest >> testFalseConstant [
	| identifier literal |
	identifier := builder identifier: #false.
	literal := analyzer visitNode: identifier.
	self assert: literal isLiteralValueNode.
	self assert: literal value equals: false.
	self assert: literal type equals: compilationTarget literalBooleanFalseType.
]

{ #category : #tests }
MbndGenericMacroLanguageTopLevelScopeTest >> testNew [
	scope := MbndGenericMacroLanguageTopLevelScope for: module.
	self assert: (scope lookupMacroSelector: #return:) isNotNil.
	
	self assert: (scope lookupMacroSelector: #if:then:) isNotNil.
	self assert: (scope lookupMacroSelector: #if:then:else:) isNotNil.

	self assert: (scope lookupMacroSelector: #while:do:) isNotNil.
	self assert: (scope lookupMacroSelector: #do:while:) isNotNil.

	self assert: (scope lookupMacroSelector: #until:do:) isNotNil.
	self assert: (scope lookupMacroSelector: #do:until:) isNotNil.
	
	self assert: (scope lookupSymbolRecursively: #nil ifAbsent: [nil]) isNotNil.
	self assert: (scope lookupSymbolRecursively: #true ifAbsent: [nil]) isNotNil.
	self assert: (scope lookupSymbolRecursively: #false ifAbsent: [nil]) isNotNil.

]

{ #category : #tests }
MbndGenericMacroLanguageTopLevelScopeTest >> testNilConstant [
	| identifier literal |
	identifier := builder identifier: #nil.
	literal := analyzer visitNode: identifier.
	self assert: literal isLiteralValueNode.
	self assert: literal value equals: nil.
	self assert: literal type equals: compilationTarget undefinedType.
]

{ #category : #tests }
MbndGenericMacroLanguageTopLevelScopeTest >> testTrueConstant [
	| identifier literal |
	identifier := builder identifier: #true.
	literal := analyzer visitNode: identifier.
	self assert: literal isLiteralValueNode.
	self assert: literal value equals: true.
	self assert: literal type equals: compilationTarget literalBooleanTrueType.
]
