"
A MbndSysmelLanguageTest is a test class for testing the behavior of MbndSysmelLanguage
"
Class {
	#name : #MbndSysmelLanguageCompileTimeEvaluationTest,
	#superclass : #TestCase,
	#instVars : [
		'module'
	],
	#category : #'SysmelLanguage-Sysmel-Tests-Parser'
}

{ #category : #'as yet unclassified' }
MbndSysmelLanguageCompileTimeEvaluationTest >> evaluateSource: aString [
	^ module evaluateLanguage: #sysmel source: aString
]

{ #category : #running }
MbndSysmelLanguageCompileTimeEvaluationTest >> setUp [
	module := MbndDummyModule new
]

{ #category : #tests }
MbndSysmelLanguageCompileTimeEvaluationTest >> testBooleanLiteralMessages [
	self assert: (self evaluateSource: 'true and: false') value equals: false.
	self assert: (self evaluateSource: 'true and: false') type isLiteralBooleanFalseType.
	self assert: (self evaluateSource: 'true or: false') value equals: true.
	self assert: (self evaluateSource: 'true or: false') type isLiteralBooleanTrueType.

]

{ #category : #tests }
MbndSysmelLanguageCompileTimeEvaluationTest >> testBooleanLiterals [
	self assert: (self evaluateSource: 'true') value equals: true.
	self assert: (self evaluateSource: 'true') type isLiteralBooleanTrueType.
	self assert: (self evaluateSource: 'false') value equals: false.
	self assert: (self evaluateSource: 'false') type isLiteralBooleanFalseType.
]

{ #category : #tests }
MbndSysmelLanguageCompileTimeEvaluationTest >> testLet [
	self assert: (self evaluateSource: 'let x := 5. x') value equals: 5.
	self assert: (self evaluateSource: 'let x mutable := 5. x') type isReferenceType.
	self assert: (self evaluateSource: 'let x mutable := 5. x') value isInteger not.
	self assert: (self evaluateSource: 'let x mutable type: Int32 := 5. x') type isReferenceType.
	self assert: (self evaluateSource: 'let x mutable type: Int32 := 5. x') value isInteger not.
]

{ #category : #tests }
MbndSysmelLanguageCompileTimeEvaluationTest >> testLiteralType [
	self assert: (self evaluateSource: '_LiteralInteger') type isMetaType.
	self assert: (self evaluateSource: '_LiteralInteger') value equals: module compilationTarget literalIntegerType.
]

{ #category : #tests }
MbndSysmelLanguageCompileTimeEvaluationTest >> testSequence [
	self assert: (self evaluateSource: '{1 + 2}. 5') value equals: 5.
]
