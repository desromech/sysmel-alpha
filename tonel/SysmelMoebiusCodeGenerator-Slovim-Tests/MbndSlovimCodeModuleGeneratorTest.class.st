"
A MbndSlovimCodeModuleGeneratorTest is a test class for testing the behavior of MbndSlovimCodeModuleGenerator
"
Class {
	#name : #MbndSlovimCodeModuleGeneratorTest,
	#superclass : #TestCase,
	#instVars : [
		'semanticModule',
		'ssaModule'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Tests-Module'
}

{ #category : #running }
MbndSlovimCodeModuleGeneratorTest >> evaluateSysmelSource: sourceString [
	semanticModule evaluateLanguage: #sysmel source: sourceString.
]

{ #category : #running }
MbndSlovimCodeModuleGeneratorTest >> generateSSAModule [
	semanticModule finishSemanticAnalysis.
	ssaModule := semanticModule generateTargetCodeModule.
]

{ #category : #running }
MbndSlovimCodeModuleGeneratorTest >> setUp [
	semanticModule := MbndStandaloneModule llvm_x86_64.
]

{ #category : #running }
MbndSlovimCodeModuleGeneratorTest >> testCStringCFunction [
	| function |
	self
		evaluateSysmelSource: 'function cstringFunction externC() => UInt8 const pointer := "Hello World\n"';
		generateSSAModule.

	function := ssaModule globalNamed: #cstringFunction.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isJump.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #running }
MbndSlovimCodeModuleGeneratorTest >> testEmptyModule [
	self generateSSAModule.
	
	self assert: ssaModule globalValues isEmpty.

]

{ #category : #running }
MbndSlovimCodeModuleGeneratorTest >> testIdentityCFunction [
	| function |
	self
		evaluateSysmelSource: 'function identity externC(x: Int32) => Int32 := x';
		generateSSAModule.

	function := ssaModule globalNamed: #identity.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isJump.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #running }
MbndSlovimCodeModuleGeneratorTest >> testIdentityScopedCFunction [
	| function |
	self
		evaluateSysmelSource: 'function identity externC(x: Int32) => Int32 := {x}';
		generateSSAModule.

	function := ssaModule globalNamed: #identity.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isJump.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #running }
MbndSlovimCodeModuleGeneratorTest >> testIdentityScopedSequenceCFunction [
	| function |
	self
		evaluateSysmelSource: 'function identity externC(x: Int32) => Int32 := {1 . x}';
		generateSSAModule.

	function := ssaModule globalNamed: #identity.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isJump.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #running }
MbndSlovimCodeModuleGeneratorTest >> testMainPutsCFunction [
	| function |
	self
		evaluateSysmelSource: '
	function puts externC(value: UInt8 const pointer) => Int32.

	function main externC() => Int32 := {
		puts("Hello World").
		0
	}.
';
		generateSSAModule.

	function := ssaModule globalNamed: #main.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isJump.
	self assert: function basicBlocks second firstInstruction isCall.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #running }
MbndSlovimCodeModuleGeneratorTest >> testMainPutsThenReturnCFunction [
	| function |
	self
		evaluateSysmelSource: '
	function puts externC(value: UInt8 const pointer) => Int32.

	function main externC() => Int32 := {
		puts("Hello World").
		return: 0
	}.
';
		generateSSAModule.

	function := ssaModule globalNamed: #main.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isJump.
	self assert: function basicBlocks second firstInstruction isCall.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #running }
MbndSlovimCodeModuleGeneratorTest >> testZeroCFunction [
	| function |
	self
		evaluateSysmelSource: 'function zero externC() => Int32 := 0';
		generateSSAModule.

	function := ssaModule globalNamed: #zero.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isJump.
	self assert: function basicBlocks second firstInstruction isReturn.
]
