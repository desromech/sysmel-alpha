"
A MbndReturnContextScopeTest is a test class for testing the behavior of MbndReturnContextScope
"
Class {
	#name : #MbndReturnContextScopeTest,
	#superclass : #TestCase,
	#category : #'MoebiusBandMetamodel-Core-Tests-Scope'
}

{ #category : #tests }
MbndReturnContextScopeTest >> testReturnContext [
	| scope |
	scope := MbndReturnContextScope new.
	self assert: scope returnContextScope equals: scope
]
