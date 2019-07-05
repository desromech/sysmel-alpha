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

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanEquality [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: BooleanBit, y: BooleanBit) => BooleanBit := x = y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ieq.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanEquality2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: BooleanBit, y: BooleanBit) => BooleanBit := x == y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ieq.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanGreater [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: BooleanBit, y: BooleanBit) => BooleanBit := x > y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ugt.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanGreaterOrEqual [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: BooleanBit, y: BooleanBit) => BooleanBit := x >= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #uge.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanLess [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: BooleanBit, y: BooleanBit) => BooleanBit := x < y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ult.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanLessOrEqual [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: BooleanBit, y: BooleanBit) => BooleanBit := x <= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ule.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanNot [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: BooleanBit) => BooleanBit := !x';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isUnaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #lnot.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanNot2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: BooleanBit) => BooleanBit := x not';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isUnaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #lnot.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanNotEquality [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: BooleanBit, y: BooleanBit) => BooleanBit := x ~= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ine.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testBooleanNotEquality2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: BooleanBit, y: BooleanBit) => BooleanBit := x ~~ y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ine.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
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

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testCountTwiceCFunction [
	| function |
	self
		evaluateSysmelSource: 'function countTwice externC(destCount: Int32) => Int32 := { 
			let i mutable := 0.
			let count mutable := 0.
			while: (i < destCount) do: { 
				count := count + 2
			} continueWith: (i := i + 1).

			count
		}';
		generateSSAModule.

	function := ssaModule globalNamed: #countTwice.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size > 3.
	self assert: function basicBlocks last lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testEmptyModule [
	self generateSSAModule.
	
	self assert: ssaModule globalValues isEmpty.

]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatAdd [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32) => Float32 := x + 1.0';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #fadd.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatDivide [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32) => Float32 := x / 3.0';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #fdiv.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatEquality [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32, y: Float32) => BooleanBit := x = y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ufeq.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatEquality2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32, y: Float32) => BooleanBit := x == y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ufeq.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatGreater [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32, y: Float32) => BooleanBit := x > y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ufgt.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatGreaterOrEqual [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32, y: Float32) => BooleanBit := x >= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ufge.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatLess [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32, y: Float32) => BooleanBit := x < y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #uflt.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatLessOrEqual [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32, y: Float32) => BooleanBit := x <= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ufle.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMultiply [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32) => Float32 := x * 3.0';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #fmul.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatNegate [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32) => Float32 := -x';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isUnaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #fneg.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatNegate2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32) => Float32 := x negated';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isUnaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #fneg.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatNotEquality [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32, y: Float32) => BooleanBit := x ~= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ufne.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatNotEquality2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32, y: Float32) => BooleanBit := x ~~ y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ufne.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatSqrt [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32) => Float32 := x sqrt';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isUnaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #fsqrt.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatSubtract [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32) => Float32 := x - 1.0';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #fsub.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatToIntegerCast [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Float32) => Int32 := x castTo: Int32';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isFloatToIntCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatingPointCast [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Float32) => Float64 := x';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isFloatingPointCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGetFieldReference [
	| function |
	self
		evaluateSysmelSource: '
		struct TestStruct definition: {
			field intField public type: Int32
		}.
		
		function getFieldRef externC(s: TestStruct ref) => Int32
			:= s intField
';
		generateSSAModule.

	function := ssaModule globalNamed: #getFieldRef.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isJump.
	self assert: function basicBlocks second firstInstruction isGetElementPointer.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGetFieldValue [
	| function |
	self
		evaluateSysmelSource: '
		struct TestStruct definition: {
			field intField public type: Int32
		}.
		
		function getFieldValue externC(s: TestStruct) => Int32
			:= s intField
';
		generateSSAModule.

	function := ssaModule globalNamed: #getFieldValue.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isJump.
	self assert: function basicBlocks second firstInstruction isExtractValue.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGetPointerElementAtFunction [
	| function |
	self
		evaluateSysmelSource: '
function getPointerElement externC(pointer: Int32 pointer, index: Int32) => Int32
	:= pointer at: index';
		generateSSAModule.

	function := ssaModule globalNamed: #getPointerElement.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isJump.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction nextInstruction isGetElementPointer.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGetPointerElementFunction [
	| function |
	self
		evaluateSysmelSource: '
function getPointerElement externC(pointer: Int32 pointer, index: Int32) => Int32
	:= pointer[index]';
		generateSSAModule.

	function := ssaModule globalNamed: #getPointerElement.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isJump.
	self assert: function basicBlocks second firstInstruction isGetElementPointer.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGetUnionFieldReference [
	| function |
	self
		evaluateSysmelSource: '
		union TestUnion definition: {
			field intField public type: Int32.
			field floatField public type: Int32.
		}.
		
		function getFieldRef externC(s: TestUnion ref) => Int32
			:= s intField
';
		generateSSAModule.

	function := ssaModule globalNamed: #getFieldRef.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isJump.
	self assert: function basicBlocks second firstInstruction isBitCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGetUnionFieldValue [
	| function |
	self
		evaluateSysmelSource: '
		union TestUnion definition: {
			field intField public type: Int32.
			field floatField public type: Float64.
		}.
		
		function getFieldValue externC(s: TestUnion) => Int32
			:= s intField
';
		generateSSAModule.

	function := ssaModule globalNamed: #getFieldValue.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isAlloca.
	self assert: function basicBlocks second firstInstruction isStore.
	self assert: function basicBlocks second firstInstruction nextInstruction isBitCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
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

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIdentityCast [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Int32) => Int32 := x castTo: Int32';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerAdd [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x + 1';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #add.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerBitAnd [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x & 1';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #bitand.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerBitAnd2 [ 
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x bitAnd: 1';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #bitand.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerBitCast [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Int32) => UInt32 := x castTo: UInt32';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBitCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerBitInvert [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := ~x';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isUnaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #not.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerBitInvert2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x bitInvert';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isUnaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #not.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerBitOr [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x | 1';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #bitor.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerBitOr2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x bitOr: 1';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #bitor.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerBitShiftLeft [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x << 3';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #shiftleft.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerBitShiftRight [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x >> 3';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #shiftrightarithmetic.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerBitXor [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x ^ 1';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #bitxor.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerBitXor2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x bitXor: 1';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #bitxor.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerDivide [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x / 2';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #div.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerDivideUnsigned [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt32) => UInt32 := x / 2';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #udiv.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerEquality [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32, y: Int32) => BooleanBit := x = y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ieq.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerEquality2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32, y: Int32) => BooleanBit := x == y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ieq.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerGreater [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32, y: Int32) => BooleanBit := x > y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #igt.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerGreaterOrEqual [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32, y: Int32) => BooleanBit := x >= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ige.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerLess [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32, y: Int32) => BooleanBit := x < y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ilt.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerLessOrEqual [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32, y: Int32) => BooleanBit := x <= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ile.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerMultiply [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x * 3';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #mul.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerMultiplyUnsigned [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt32) => UInt32 := x * 3';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #mul.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerNegate [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := -x';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isUnaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #neg.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerNegate2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x negated';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isUnaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #neg.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerNotEquality [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32, y: Int32) => BooleanBit := x ~= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ine.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerNotEquality2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32, y: Int32) => BooleanBit := x ~~ y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ine.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerRemainder [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x % 2';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #rem.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerRemainderUnsigned [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt32) => UInt32 := x % 2';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #urem.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerSignExtension [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Int8) => Int32 := x';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isSignExtend.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerSubtract [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x - 1';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #sub.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerToFloatCast [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Int32) => Float32 := x';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isIntToFloatCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerToPointerCast [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: IntPointer) => Void pointer
			:= x reinterpretCastTo: Void pointer';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isIntToPointerCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerToPointerCast2 [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: UIntPointer) => Void pointer
			:= x reinterpretCastTo: Void pointer';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isIntToPointerCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerTruncate [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Int32) => Int8 := x castTo: Int8';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isTruncate.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerUnsignedBitShiftRight [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt32) => UInt32 := x >> 3';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #shiftright.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerUnsignedGreater [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt32, y: UInt32) => BooleanBit := x > y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ugt.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerUnsignedGreaterOrEqual [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt32, y: UInt32) => BooleanBit := x >= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #uge.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerUnsignedLess [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt32, y: UInt32) => BooleanBit := x < y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ult.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerUnsignedLessOrEqual [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt32, y: UInt32) => BooleanBit := x <= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ule.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerZeroExtension [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: UInt8) => UInt32 := x';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isZeroExtend.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testLetZeroCFunction [
	| function |
	self
		evaluateSysmelSource: 'function zero externC() => Int32 := {
			let x := 0.
			x
		}';
		generateSSAModule.

	function := ssaModule globalNamed: #zero.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isJump.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testLetZeroMutableAssignmentCFunction [
	| function |
	self
		evaluateSysmelSource: 'function zero externC() => Int32 := {
			let x mutable := 42.
			x := 0.
			x
		}';
		generateSSAModule.

	function := ssaModule globalNamed: #zero.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isAlloca.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testLetZeroMutableCFunction [
	| function |
	self
		evaluateSysmelSource: 'function zero externC() => Int32 := {
			let x mutable := 0.
			x
		}';
		generateSSAModule.

	function := ssaModule globalNamed: #zero.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isAlloca.
	self assert: function basicBlocks second firstInstruction isStore.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testMinCFunction [
	| function |
	self
		evaluateSysmelSource: 'function min externC(a: Int32, b: Int32) => Int32
			:= if: a <= b then: a else: b';
		generateSSAModule.

	function := ssaModule globalNamed: #min.
	function applyDominanceTopoSort.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 5.
	self assert: function basicBlocks second firstInstruction isBinaryComparison.
	self assert: function basicBlocks last firstInstruction isPhi.
	self assert: function basicBlocks last lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPlusOne [
	| function |
	self
		evaluateSysmelSource: 'function plusOne externC(x: Int32) => Int32
			:= x + 1';
		generateSSAModule.

	function := ssaModule globalNamed: #plusOne.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks last firstInstruction isBinaryOperation.
	self assert: function basicBlocks last lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerAsReference [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Float32 pointer) => Float32 ref := x _';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerAsReference2 [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Float32 pointer) => Float32 ref := x value';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerEquality [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32 pointer, y: Int32 pointer) => BooleanBit := x == y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ieq.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerEquality2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32 pointer, y: Int32 pointer) => BooleanBit := x = y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ieq.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerGreater [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32 pointer, y: Int32 pointer) => BooleanBit := x > y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ugt.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerGreaterOrEqual [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32 pointer, y: Int32 pointer) => BooleanBit := x >= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #uge.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerLess [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32 pointer, y: Int32 pointer) => BooleanBit := x < y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ult.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerLessOrEqual [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32 pointer, y: Int32 pointer) => BooleanBit := x <= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ule.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerNotEquality [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32 pointer, y: Int32 pointer) => BooleanBit := x ~~ y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ine.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerNotEquality2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32 pointer, y: Int32 pointer) => BooleanBit := x ~= y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #ine.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerReinterpretCast [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: UInt32 pointer) => Void pointer
			:= x';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBitCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerReinterpretCast2 [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: UInt32 pointer) => Void const pointer
			:= x';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBitCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerReinterpretCast3 [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Void const pointer) => UInt32 const pointer
			:= x castTo: UInt32 const pointer';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBitCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerReinterpretCast4 [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: UInt8 const pointer) => UInt32 const pointer
			:= x reinterpretCastTo: UInt32 const pointer';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBitCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerToIntegerCast [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Void pointer) => IntPointer
			:= x reinterpretCastTo: IntPointer';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isPointerToIntCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerToIntegerCast2 [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Void pointer) => UIntPointer
			:= x reinterpretCastTo: UIntPointer';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isPointerToIntCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testReferenceAsPointer [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Float32 ref) => Float32 pointer := x address';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
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
