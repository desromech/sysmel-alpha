"
A MbndAstBuilderTest is a test class for testing the behavior of MbndAstBuilder
"
Class {
	#name : #MbndAstBuilderTest,
	#superclass : #TestCase,
	#instVars : [
		'builder'
	],
	#category : #'MoebiusBandMetamodel-Core-Tests-AST'
}

{ #category : #running }
MbndAstBuilderTest >> setUp [
	builder := MbndAstBuilder new.
]

{ #category : #running }
MbndAstBuilderTest >> testIdentifier [
	| node |
	node := builder identifier: #symbol.
	self assert: node isIdentifierReferenceNode.
	self assert: node symbol equals: #symbol.
]

{ #category : #running }
MbndAstBuilderTest >> testLiteralInteger [
	| node |
	node := builder literalInteger: 1.
	self assert: node isLiteralValueNode.
	self assert: node value equals: 1.
	self assert: node type isLiteralIntegerType.
]
