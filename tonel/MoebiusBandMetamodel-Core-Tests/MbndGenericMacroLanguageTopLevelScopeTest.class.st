"
A MbndGenericMacroLanguageTopLevelScopeTest is a test class for testing the behavior of MbndGenericMacroLanguageTopLevelScope
"
Class {
	#name : #MbndGenericMacroLanguageTopLevelScopeTest,
	#superclass : #TestCase,
	#category : #'MoebiusBandMetamodel-Core-Tests-Scope'
}

{ #category : #tests }
MbndGenericMacroLanguageTopLevelScopeTest >> testNew [
	| scope |
	scope := MbndGenericMacroLanguageTopLevelScope new.
	self assert: (scope lookupMacroSelector: #return:) isNotNil.
	
	self assert: (scope lookupMacroSelector: #if:then:) isNotNil.
	self assert: (scope lookupMacroSelector: #if:then:else:) isNotNil.

	self assert: (scope lookupMacroSelector: #while:do:) isNotNil.
	self assert: (scope lookupMacroSelector: #do:while:) isNotNil.

	self assert: (scope lookupMacroSelector: #until:do:) isNotNil.
	self assert: (scope lookupMacroSelector: #do:until:) isNotNil.

]
