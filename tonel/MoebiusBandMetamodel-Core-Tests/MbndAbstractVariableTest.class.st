"
A MbndAbstractVariableTest is a test class for testing the behavior of MbndAbstractVariable
"
Class {
	#name : #MbndAbstractVariableTest,
	#superclass : #TestCase,
	#instVars : [
		'module',
		'compilationTarget'
	],
	#category : #'MoebiusBandMetamodel-Core-Tests-Variables'
}

{ #category : #testing }
MbndAbstractVariableTest class >> isAbstract [
	^ self == MbndAbstractVariableTest
]

{ #category : #running }
MbndAbstractVariableTest >> setUp [
	super setUp.
	module := MbndDummyModule new.
	compilationTarget := module compilationTarget.
]

{ #category : #tests }
MbndAbstractVariableTest >> testIsSymbolBinding [
	| variable |
	variable := self variableClass new.
	self deny: 42 isMbndSymbolBinding.
	self assert: variable isMbndSymbolBinding.
]

{ #category : #running }
MbndAbstractVariableTest >> variableClass [
	self subclassResponsibility
]
