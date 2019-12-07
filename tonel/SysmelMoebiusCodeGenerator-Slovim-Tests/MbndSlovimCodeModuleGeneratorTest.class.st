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
MbndSlovimCodeModuleGeneratorTest >> testArraySubscriptAt [
	| function |
	self
		evaluateSysmelSource: '
global theArray mutable type: (Int32 array: 32).

function f externC(x: Int32) => Int32 ref
	:= theArray[x].';
		generateSSAModule.

	function := ssaModule globalNamed: #f.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isGetElementPointer.
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
MbndSlovimCodeModuleGeneratorTest >> testClassGetSuperclassField [
	| function |
	self
		evaluateSysmelSource: '
class SuperClass definition: { 
	field int32Field type: Int32.
}.

class SubClass superclass: SuperClass; definition: { 
	field float32Field type: Float32.
	
	message getField => Int32 := int32Field.
}.

';
		generateSSAModule.

	function := ssaModule globalNamed: #_S8SubClass8getFieldFRTc_S8SubClass.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isJump.
	self assert: function basicBlocks second firstInstruction isGetElementPointer.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testClassGetSuperclassField2 [
	| function |
	self
		evaluateSysmelSource: '
class SuperClass definition: { 
	field int32Field type: Int32.
}.

class SubClass superclass: SuperClass; definition: { 
	field float32Field type: Float32.
	
	function getField externC() => Int32 := int32Field.
}.

';
		generateSSAModule.

	function := ssaModule globalNamed: #getField.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isJump.
	self assert: function basicBlocks second firstInstruction isGetElementPointer.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testClassPointerUpcast [
	| function |
	self
		evaluateSysmelSource: '
class SuperClass definition: { 
	field int32Field type: Int32.
}.

class SubClass superclass: SuperClass; definition: { 
	field float32Field type: Float32.
}.

function upcast externC(x: SubClass pointer) => SuperClass pointer := x
';
		generateSSAModule.

	function := ssaModule globalNamed: #upcast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks first firstInstruction isJump.
	self assert: function basicBlocks second firstInstruction isBitCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testCompileTimeLocalVariableCapture [
	| function |
	self
		evaluateSysmelSource: '
let localGlobalVariable := 0.
function returnValue externC() => Int32 := localGlobalVariable';
		generateSSAModule.

	function := ssaModule globalNamed: #returnValue.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function functionType returnType isIntegerType.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testCompileTimeLocalVariableMutableCapture [
	| function |
	self
		evaluateSysmelSource: '
let localGlobalVariable mutable := 0.
function returnValue externC() => Int32 := localGlobalVariable';
		generateSSAModule.

	function := ssaModule globalNamed: #returnValue.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function functionType returnType isIntegerType.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isLoad.
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
MbndSlovimCodeModuleGeneratorTest >> testEnumSelectCase [
	| function |
	self
		evaluateSysmelSource: '
enum TestEnum values: #{
	First: 1.
	Second: 2.
}.

		function selectCaseTest externC(value: TestEnum) => Float32
			:= value selectCase: #{
	TestEnum First : 0.0.
	TestEnum Second : 1.0.
}';
		generateSSAModule.

	function := ssaModule globalNamed: #selectCaseTest.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 6.
	self assert: function basicBlocks second firstInstruction isSwitch.
	self assert: function basicBlocks last lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testEnumSelectSingleCase [
	| function |
	self
		evaluateSysmelSource: '
enum TestEnum values: #{
	First: 1.
	Second: 2.
}.

		function selectCaseTest externC(value: TestEnum) => Float32
			:= value selectCase: #{
	TestEnum First : 42.0.
}';
		generateSSAModule.

	function := ssaModule globalNamed: #selectCaseTest.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 5.
	self assert: function basicBlocks second firstInstruction isSwitch.
	self assert: function basicBlocks last lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testEnumValueAsIntegerCastReturn [
	| function |
	self
		evaluateSysmelSource: '
enum TestEnum values: #{
	First: 1.
	Second: 2.
}.

function returnValue externC() => Int64 := TestEnum First castTo: Int64';
		generateSSAModule.

	function := ssaModule globalNamed: #returnValue.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function functionType returnType isIntegerType.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isSignExtend.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testEnumValueAsIntegerReturn [
	| function |
	self
		evaluateSysmelSource: '
enum TestEnum values: #{
	First: 1.
	Second: 2.
}.

function returnValue externC() => Int32 := TestEnum First value';
		generateSSAModule.

	function := ssaModule globalNamed: #returnValue.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function functionType returnType isIntegerType.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testEnumValueFromValueCast2Return [
	| function |
	self
		evaluateSysmelSource: '
enum TestEnum values: #{
	First: 1.
	Second: 2.
}.

function asEnum externC(value: Int64) => TestEnum := value castTo: TestEnum';
		generateSSAModule.

	function := ssaModule globalNamed: #asEnum.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function functionType returnType isIntegerType.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isTruncate.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testEnumValueFromValueCastReturn [
	| function |
	self
		evaluateSysmelSource: '
enum TestEnum values: #{
	First: 1.
	Second: 2.
}.

function asEnum externC(value: Int32) => TestEnum := value castTo: TestEnum';
		generateSSAModule.

	function := ssaModule globalNamed: #asEnum.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function functionType returnType isIntegerType.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testEnumValueReturn [
	| function |
	self
		evaluateSysmelSource: '
enum TestEnum values: #{
	First: 1.
	Second: 2.
}.

function returnValue externC() => TestEnum := TestEnum First';
		generateSSAModule.

	function := ssaModule globalNamed: #returnValue.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function functionType returnType isIntegerType.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testEnumValueReturn2 [
	| function |
	self
		evaluateSysmelSource: '
enum TestEnum values: #{
	None: .
	First: .
	Second: .
}.

function returnValue externC() => TestEnum := TestEnum First';
		generateSSAModule.

	function := ssaModule globalNamed: #returnValue.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function functionType returnType isIntegerType.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
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
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixAdd [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4x4, y: Float32x4x4) => Float32x4x4 := x + y';
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
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixConstructWithColumns [
	| function |
	self
		evaluateSysmelSource: 'function makeMatrix externC(
			firstColumn: Float32x4, secondColumn: Float32x4, thirdColumn: Float32x4, fourthColumn: Float32x4) => Float32x4x4
			:= Float32x4x4(firstColumn, secondColumn, thirdColumn, fourthColumn)';
		generateSSAModule.

	function := ssaModule globalNamed: #makeMatrix.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isMakeMatrix.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixElementwiseDivision [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4x4, y: Float32x4x4) => Float32x4x4 := x %/ y';
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
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixElementwiseProduct [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4x4, y: Float32x4x4) => Float32x4x4 := x %* y';
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
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixGetFirstColumn [
	| function |
	self
		evaluateSysmelSource: 'function getMatrixColumn externC(vector: Float32x4x4) => Float32x4
			:= vector firstColumn';
		generateSSAModule.

	function := ssaModule globalNamed: #getMatrixColumn.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isExtractValue.
	self assert: function basicBlocks second firstInstruction indices value equals: #(0).
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixGetFourthColumn [
	| function |
	self
		evaluateSysmelSource: 'function getMatrixColumn externC(vector: Float32x4x4) => Float32x4
			:= vector fourthColumn';
		generateSSAModule.

	function := ssaModule globalNamed: #getMatrixColumn.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isExtractValue.
	self assert: function basicBlocks second firstInstruction indices value equals: #(3).
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixGetSecondColumn [
	| function |
	self
		evaluateSysmelSource: 'function getMatrixColumn externC(vector: Float32x4x4) => Float32x4
			:= vector secondColumn';
		generateSSAModule.

	function := ssaModule globalNamed: #getMatrixColumn.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isExtractValue.
	self assert: function basicBlocks second firstInstruction indices value equals: #(1).
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixGetThirdColumn [
	| function |
	self
		evaluateSysmelSource: 'function getMatrixColumn externC(vector: Float32x4x4) => Float32x4
			:= vector thirdColumn';
		generateSSAModule.

	function := ssaModule globalNamed: #getMatrixColumn.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isExtractValue.
	self assert: function basicBlocks second firstInstruction indices value equals: #(2).
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixIdentity [
	| function |
	self
		evaluateSysmelSource: 'function makeIdentity externC() => Float32x4x4
			:= Float32x4x4 identity';
		generateSSAModule.

	function := ssaModule globalNamed: #makeIdentity.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
	self assert: function basicBlocks second firstInstruction value asFloatArray asArray equals: #(
		1.0 0.0 0.0 0.0
		0.0 1.0 0.0 0.0
		0.0 0.0 1.0 0.0
		0.0 0.0 0.0 1.0
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixIdentityNonSquare [
	| function |
	self
		evaluateSysmelSource: 'function makeIdentity externC() => Float32x3x4
			:= Float32x3x4 identity';
		generateSSAModule.

	function := ssaModule globalNamed: #makeIdentity.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
	self assert: function basicBlocks second firstInstruction value asFloatArray asArray equals: #(
		1.0 0.0 0.0 0.0
		0.0 1.0 0.0 0.0
		0.0 0.0 1.0 0.0
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixMatrixMultiplication [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4x3, y: Float32x3x4) => Float32x4x4 := x * y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #mulMatrixMatrix.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixOnes [
	| function |
	self
		evaluateSysmelSource: 'function makeOnes externC() => Float32x4x4
			:= Float32x4x4 ones';
		generateSSAModule.

	function := ssaModule globalNamed: #makeOnes.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
	self assert: function basicBlocks second firstInstruction value asFloatArray asArray equals: #(
		1.0 1.0 1.0 1.0
		1.0 1.0 1.0 1.0
		1.0 1.0 1.0 1.0
		1.0 1.0 1.0 1.0
	).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixReferenceGetFirstColumn [
	| function |
	self
		evaluateSysmelSource: 'function getMatrixColumn externC(vector: Float32x4x4 ref) => Float32x4
			:= vector firstColumn';
		generateSSAModule.

	function := ssaModule globalNamed: #getMatrixColumn.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isGetElementPointer.
	self assert: function basicBlocks second firstInstruction indices last value equals: 0.
	self assert: function basicBlocks second firstInstruction nextInstruction isLoad.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixReferenceGetFourthColumn [
	| function |
	self
		evaluateSysmelSource: 'function getMatrixColumn externC(vector: Float32x4x4 ref) => Float32x4
			:= vector fourthColumn';
		generateSSAModule.

	function := ssaModule globalNamed: #getMatrixColumn.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isGetElementPointer.
	self assert: function basicBlocks second firstInstruction indices last value equals: 3.
	self assert: function basicBlocks second firstInstruction nextInstruction isLoad.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixReferenceGetSecondColumn [
	| function |
	self
		evaluateSysmelSource: 'function getMatrixColumn externC(vector: Float32x4x4 ref) => Float32x4
			:= vector secondColumn';
		generateSSAModule.

	function := ssaModule globalNamed: #getMatrixColumn.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isGetElementPointer.
	self assert: function basicBlocks second firstInstruction indices last value equals: 1.
	self assert: function basicBlocks second firstInstruction nextInstruction isLoad.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixReferenceGetThirdColumn [
	| function |
	self
		evaluateSysmelSource: 'function getMatrixColumn externC(vector: Float32x4x4 ref) => Float32x4
			:= vector thirdColumn';
		generateSSAModule.

	function := ssaModule globalNamed: #getMatrixColumn.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isGetElementPointer.
	self assert: function basicBlocks second firstInstruction indices last value equals: 2.
	self assert: function basicBlocks second firstInstruction nextInstruction isLoad.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixSubtract [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4x4, y: Float32x4x4) => Float32x4x4 := x - y';
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
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixVectorMultiplication [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4x4, y: Float32x4) => Float32x4 := x * y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #mulMatrixVector.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixVectorMultiplicationError [
	self should: [ 
		self
		evaluateSysmelSource: 'function op externC(x: Float32x4x2, y: Float32x4x4) => Void := x * y';
		generateSSAModule
	] raise: MbndSemanticError.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatMatrixZeros [
	| function |
	self
		evaluateSysmelSource: 'function makeZeros externC() => Float32x4x4
			:= Float32x4x4 zeros';
		generateSSAModule.

	function := ssaModule globalNamed: #makeZeros.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
	self assert: function basicBlocks second firstInstruction value asFloatArray asArray equals: #(
		0.0 0.0 0.0 0.0
		0.0 0.0 0.0 0.0
		0.0 0.0 0.0 0.0
		0.0 0.0 0.0 0.0
	).
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
MbndSlovimCodeModuleGeneratorTest >> testFloatScalarToMatrix [
	| function |
	self
		evaluateSysmelSource: 'function scalarToMatrix externC(scalar: Float32) => Float32x4x4
			:= Float32x4x4(scalar)';
		generateSSAModule.

	function := ssaModule globalNamed: #scalarToMatrix.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second allInstructionsMnemonics equals:
		#(makeVector makeVector makeVector makeVector makeMatrix return).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatScalarToMatrix2 [
	| function |
	self
		evaluateSysmelSource: 'function scalarToMatrix externC(scalar: Float32) => Float32x4x4
			:= scalar';
		generateSSAModule.

	function := ssaModule globalNamed: #scalarToMatrix.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second allInstructionsMnemonics equals:
		#(makeVector makeVector makeVector makeVector makeMatrix return).
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
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorAdd [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32x4) => Float32x4 := x + y';
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
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorAddWithScalar [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32) => Float32x4 := x + y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isMakeVector.
	self assert: function basicBlocks second firstInstruction nextInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction nextInstruction operation equals: #fadd.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorAddWithScalarLiteral [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4) => Float32x4 := x + 1.0';
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
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorConstruction [
	| function |
	self
		evaluateSysmelSource: 'function makeVector externC(x: Float32, y: Float32) => Float32x2
			:= Float32x2 x: x y: y';
		generateSSAModule.

	function := ssaModule globalNamed: #makeVector.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isMakeVector.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorConstruction2 [
	| function |
	self
		evaluateSysmelSource: 'function makeVector externC(xy: Float32x2, z: Float32) => Float32x3
			:= Float32x3(xy, z)';
		generateSSAModule.

	function := ssaModule globalNamed: #makeVector.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isMakeVector.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorCross [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x3, y: Float32x3) => Float32x3 := x cross: y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isCall.
	self assert: function basicBlocks second firstInstruction functionValue isConstantBuiltInFunction.
	self assert: function basicBlocks second firstInstruction functionValue name equals: #'vector.cross'.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorCross2D [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x2, y: Float32x2) => Float32 := x cross: y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self deny: function basicBlocks second firstInstruction isCall.
	self deny: function basicBlocks second firstInstruction isReturn.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorDivide [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32x4) => Float32x4 := x / y';
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
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorDot [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32x4) => Float32 := x dot: y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isCall.
	self assert: function basicBlocks second firstInstruction functionValue isConstantBuiltInFunction.
	self assert: function basicBlocks second firstInstruction functionValue name equals: #'vector.dot'.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorGetW [
	| function |
	self
		evaluateSysmelSource: 'function getVectorElement externC(vector: Float32x4) => Float32
			:= vector w';
		generateSSAModule.

	function := ssaModule globalNamed: #getVectorElement.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isExtractVectorElement.
	self assert: function basicBlocks second firstInstruction index value equals: 3.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorGetX [
	| function |
	self
		evaluateSysmelSource: 'function getVectorElement externC(vector: Float32x4) => Float32
			:= vector x';
		generateSSAModule.

	function := ssaModule globalNamed: #getVectorElement.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isExtractVectorElement.
	self assert: function basicBlocks second firstInstruction index value equals: 0.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorGetY [
	| function |
	self
		evaluateSysmelSource: 'function getVectorElement externC(vector: Float32x4) => Float32
			:= vector y';
		generateSSAModule.

	function := ssaModule globalNamed: #getVectorElement.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isExtractVectorElement.
	self assert: function basicBlocks second firstInstruction index value equals: 1.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorGetZ [
	| function |
	self
		evaluateSysmelSource: 'function getVectorElement externC(vector: Float32x4) => Float32
			:= vector z';
		generateSSAModule.

	function := ssaModule globalNamed: #getVectorElement.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isExtractVectorElement.
	self assert: function basicBlocks second firstInstruction index value equals: 2.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorLength2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4) => Float32 := x length2';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isCall.
	self assert: function basicBlocks second firstInstruction functionValue isConstantBuiltInFunction.
	self assert: function basicBlocks second firstInstruction functionValue name equals: #'vector.dot'.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorMatrixMultiplication [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32x4x4) => Float32x4 := x * y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction operation equals: #mulVectorMatrix.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorMultiply [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32x4) => Float32x4 := x * y';
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
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorNegate [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4) => Float32x4 := -x';
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
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorNegate2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4) => Float32x4 := x negated';
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
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorSetYConstReferenceValue [
	| function |
	self
		evaluateSysmelSource: 'function setVectorElement externC(vector: Float32x4 const ref, value: Float32) => Float32x4
			:= vector y: value';
		generateSSAModule.

	function := ssaModule globalNamed: #setVectorElement.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isLoad.
	self assert: function basicBlocks second firstInstruction nextInstruction isInsertVectorElement.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorSetYReferenceValue [
	| function |
	self
		evaluateSysmelSource: 'function setVectorElement externC(vector: Float32x4 ref, value: Float32) => Float32
			:= vector y := value';
		generateSSAModule.

	function := ssaModule globalNamed: #setVectorElement.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isGetElementPointer.
	self assert: function basicBlocks second firstInstruction nextInstruction isStore.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorSetYReferenceValue2 [
	| function |
	self
		evaluateSysmelSource: 'function setVectorElement externC(vector: Float32x4 ref, value: Float32) => Float32x4
			:= vector y: value';
		generateSSAModule.

	function := ssaModule globalNamed: #setVectorElement.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isGetElementPointer.
	self assert: function basicBlocks second firstInstruction nextInstruction isStore.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorSqrt [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4) => Float32x4 := x sqrt';
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
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorSubtract [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Float32x4, y: Float32x4) => Float32x4 := x - y';
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
MbndSlovimCodeModuleGeneratorTest >> testFloatVectorSwizzle [
	| function |
	self
		evaluateSysmelSource: 'function getVectorElements externC(vector: Float32x4) => Float32x4
			:= vector wzyx';
		generateSSAModule.

	function := ssaModule globalNamed: #getVectorElements.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isShuffleVectors.
	self assert: function basicBlocks second firstInstruction components value equals: #(3 2 1 0).
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
MbndSlovimCodeModuleGeneratorTest >> testGlobalArrayInitialization [
	| globalVariable |
	self
		evaluateSysmelSource: '
global theArray mutable externC type: (Int32 array: 5) := #(1 2 3 4 5).
';
		generateSSAModule.

	globalVariable := ssaModule globalNamed: #theArray.
	self assert: globalVariable isGlobalVariable.
	self assert: (globalVariable initialValue slots collect: #value) equals: #(1 2 3 4 5).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGlobalArrayInitialization2 [
	| globalVariable |
	self
		evaluateSysmelSource: '
global theArray mutable externC type: (Int32 array: 5) := (1, 2, 3, 4, 5).
';
		generateSSAModule.

	globalVariable := ssaModule globalNamed: #theArray.
	self assert: globalVariable isGlobalVariable.
	self assert: (globalVariable initialValue slots collect: #value) equals: #(1 2 3 4 5).
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGlobalArrayInitialization3 [
	| globalVariable |
	self
		evaluateSysmelSource: '
global firstPointed mutable externC type: Int32.
global secondPointed mutable externC type: Int32.
global theArray mutable externC type: (Int32 pointer array: 2) := (
	firstPointed address,
	secondPointed address
).
';
		generateSSAModule.

	globalVariable := ssaModule globalNamed: #theArray.
	self assert: globalVariable isGlobalVariable.
	self assert: globalVariable initialValue slots equals: {
		ssaModule globalNamed: #firstPointed.
		ssaModule globalNamed: #secondPointed.
	}.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testGlobalVariableDefinition [
	| global |
	self
		evaluateSysmelSource: 'global testGlobal externC mutable := 42';
		generateSSAModule.

	global := ssaModule globalNamed: #testGlobal.
	self assert: global isGlobalVariable.
	self assert: global valueType isIntegerType.
	self assert: global initialValue isConstantValue.
	self assert: global initialValue value equals: 42.
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
MbndSlovimCodeModuleGeneratorTest >> testIfIntegerLiteralCoercion [
	| function |
	self
		evaluateSysmelSource: 'function coercion externC(condition: BooleanBit, uint: UInt32) => UInt32
		:= if: condition then: uint else: 0.';
		generateSSAModule.

	function := ssaModule globalNamed: #coercion.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 5.
	self assert: function basicBlocks fifth firstInstruction isPhi.
	self assert: function basicBlocks fifth lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testInputChannelReceiveInteger [
	| function |
	self
		evaluateSysmelSource: 'function receive externC(inputChannel: Int32 inputChannel) => Int32
			:= inputChannel receive';
		generateSSAModule.

	function := ssaModule globalNamed: #receive.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isMessageSend.
	self assert: function basicBlocks second lastInstruction isReturn.
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
MbndSlovimCodeModuleGeneratorTest >> testIntegerAddUInt64 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt64) => UInt64 := x + 1';
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
MbndSlovimCodeModuleGeneratorTest >> testIntegerAddUInt64Ref [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt64 ref) => UInt64 := x + 1';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isLoad.
	self assert: function basicBlocks second firstInstruction nextInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction nextInstruction operation equals: #add.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerAddUInt64Ref2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt64 ref) => UInt64 := 1 + x';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isLoad.
	self assert: function basicBlocks second firstInstruction nextInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction nextInstruction operation equals: #add.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerAddUInt64_2 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt64) => UInt64 := 1 + x';
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
MbndSlovimCodeModuleGeneratorTest >> testIntegerBitShiftLeftCoercion [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt64) => UInt64 := 1 << x';
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
MbndSlovimCodeModuleGeneratorTest >> testIntegerEmptySelectCase [
	| function |
	self
		evaluateSysmelSource: 'function selectCaseTest externC(value: Int32) => Void
			:= value selectCase: #{
}';
		generateSSAModule.

	function := ssaModule globalNamed: #selectCaseTest.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturnVoid.
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
MbndSlovimCodeModuleGeneratorTest >> testIntegerEquality3 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32 const, y: Int32) => BooleanBit := x = y';
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
MbndSlovimCodeModuleGeneratorTest >> testIntegerEquality4 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32 const, y: Int32) => BooleanBit := x == y';
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
MbndSlovimCodeModuleGeneratorTest >> testIntegerEquality5 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32 const ref, y: Int32) => BooleanBit := x = y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isLoad.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction operation equals: #ieq.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerEquality6 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32 const ref, y: Int32) => BooleanBit := x == y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isLoad.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction operation equals: #ieq.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerEquality7 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int16, y: Int32) => BooleanBit := x == y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isSignExtend.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction operation equals: #ieq.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerEquality8 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32, y: Int16) => BooleanBit := x == y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isSignExtend.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction operation equals: #ieq.
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
MbndSlovimCodeModuleGeneratorTest >> testIntegerHighBit [ 
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x highBit';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isCall.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction isBinaryOperation.
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
MbndSlovimCodeModuleGeneratorTest >> testIntegerLowBit [ 
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32) => Int32 := x lowBit';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isUnaryOperation.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction nextNonDebugInstruction isCall.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction nextNonDebugInstruction nextNonDebugInstruction isBinaryOperation.
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
MbndSlovimCodeModuleGeneratorTest >> testIntegerNotEquality3 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int16, y: Int32) => BooleanBit := x ~~ y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isSignExtend.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction operation equals: #ine.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerNotEquality4 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: Int32, y: Int16) => BooleanBit := x ~~ y';
		generateSSAModule.

	function := ssaModule globalNamed: #op.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isSignExtend.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction isBinaryOperation.
	self assert: function basicBlocks second firstInstruction nextNonDebugInstruction operation equals: #ine.
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
MbndSlovimCodeModuleGeneratorTest >> testIntegerSelectCase [
	| function |
	self
		evaluateSysmelSource: 'function selectCaseTest externC(value: Int32) => Float32
			:= value selectCase: #{
	0: 0.0.
	1: 1.0.
	2: 2.0.
	3: 3.0.
	4: 4.0.
	let v : (v castTo: Float32) * 2.0
}';
		generateSSAModule.

	function := ssaModule globalNamed: #selectCaseTest.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 9.
	self assert: function basicBlocks second firstInstruction isSwitch.
	self assert: function basicBlocks last lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerSelectSingleCase [
	| function |
	self
		evaluateSysmelSource: 'function selectCaseTest externC(value: Int32) => Float32
			:= value selectCase: #{
	0: value.
}';
		generateSSAModule.

	function := ssaModule globalNamed: #selectCaseTest.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 5.
	self assert: function basicBlocks last lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testIntegerSelectSingleCase2 [
	| function |
	self
		evaluateSysmelSource: 'function selectCaseTest externC(value: Int32 ref) => Float32
			:= value selectCase: #{
	0: 42.0.
}';
		generateSSAModule.

	function := ssaModule globalNamed: #selectCaseTest.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 5.
	self assert: function basicBlocks last lastInstruction isReturn.
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
MbndSlovimCodeModuleGeneratorTest >> testIntegerSubtractUInt64 [
	| function |
	self
		evaluateSysmelSource: 'function op externC(x: UInt64) => UInt64 := x - 20';
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
MbndSlovimCodeModuleGeneratorTest >> testMultipleChainsFunction [
	| function |
	self
		evaluateSysmelSource: 'function zero externC() => Int32
			:= {
			1 + 1; yourself.
			0 yourself; yourself.
		}';
		generateSSAModule.

	function := ssaModule globalNamed: #zero.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.

]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testOutputChannelSendInteger [
	| function |
	self
		evaluateSysmelSource: 'function send externC(outputChannel: Int32 outputChannel, message: Int32) => Void
			:= outputChannel send: message';
		generateSSAModule.

	function := ssaModule globalNamed: #send.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isMessageSend.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testOverloadedCall [
	| function call |
	self
		evaluateSysmelSource: '
function called(x: Float32) => Float32
	:= x + 2.
	
function called(x: Int32) => Int32
	:= x + 1.
	
function call externC(x: Int32) => Int32
	:= called(x).';
		generateSSAModule.

	function := ssaModule globalNamed: #call.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	call := function basicBlocks second firstInstruction.
	self assert: call isCall.
	self assert: call functionValue name equals: #_S6calledFi.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testOverloadedCallWithLiteral [
	| function call |
	self
		evaluateSysmelSource: '
function called(x: Float32) => Float32
	:= x + 2.
	
function called(x: Int32) => Int32
	:= x + 1.
	
function call externC() => Int32
	:= called(1).';
		generateSSAModule.

	function := ssaModule globalNamed: #call.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	call := function basicBlocks second firstInstruction.
	self assert: call isCall.
	self assert: call functionValue name equals: #_S6calledFi.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testOverloadedMessageSend [
	| function call |
	self
		evaluateSysmelSource: '
struct TestStruct definition: { 
	message addTo: (x: Float32) ::=> Float32
		:= x + 2.

	message addTo: (x: Int32) ::=> Int32
		:= x + 2.
}.

function call externC(x: Int32) => Int32
	:= TestStruct newValue addTo: x.';
		generateSSAModule.

	function := ssaModule globalNamed: #call.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isStore.
	call := function basicBlocks second firstInstruction nextInstruction.
	self assert: call isCall.
	self assert: call functionValue name equals:  #_S10TestStruct7addTo_cFRTs_S10TestStructi.
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
MbndSlovimCodeModuleGeneratorTest >> testPointerAsReference3 [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Float32 pointer ref) => Float32 ref := x value';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isLoad.
	self assert: function basicBlocks second lastInstruction isReturn.
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
MbndSlovimCodeModuleGeneratorTest >> testPointerNull [
	| function |
	self
		evaluateSysmelSource: 'function returnNull externC() => Int32 pointer := nil';
		generateSSAModule.

	function := ssaModule globalNamed: #returnNull.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerNull2 [
	| function |
	self
		evaluateSysmelSource: '
		function sideEffect() => Void.
		function returnNull externC() => Int32 pointer := {sideEffect() . nil}';
		generateSSAModule.

	function := ssaModule globalNamed: #returnNull.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
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
MbndSlovimCodeModuleGeneratorTest >> testPointerReinterpretCast5 [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: UInt8 const pointer ref) => UInt32 const pointer
			:= x reinterpretCastTo: UInt32 const pointer';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isLoad.
	self assert: function basicBlocks second firstInstruction nextInstruction isBitCast.
	self assert: function basicBlocks second lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testPointerToConstPointer [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Void pointer) => Void const pointer := x';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
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
MbndSlovimCodeModuleGeneratorTest >> testPointerValueMessageChain [
	| function instructions |
	self
		evaluateSysmelSource: '

struct Node definition: { 
	field previous public type: Node pointer.
	field next public type: Node pointer.
}.

function setPreviousAndNext externC(node: Node pointer, previous: Node pointer, next: Node pointer) => Void
	:= node _
		previous: previous;
		next: next.
';
		generateSSAModule.

	function := ssaModule globalNamed: #setPreviousAndNext.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	
	instructions := function basicBlocks second allInstructions.
	self assert: instructions first isGetElementPointer.
	self assert: instructions second isStore.
	self assert: instructions third isGetElementPointer.
	self assert: instructions fourth isStore.
	self assert: instructions fifth isReturnVoid.

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
MbndSlovimCodeModuleGeneratorTest >> testReferenceToConstReference [
	| function |
	self
		evaluateSysmelSource: 'function cast externC(x: Int32 ref) => Int32 const ref := x';
		generateSSAModule.

	function := ssaModule globalNamed: #cast.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testSelect [
	| function |
	self
		evaluateSysmelSource: 
'function select externC(cond: BooleanBit, left: UInt16, right: UInt16) => UInt16
	:= if: cond then: left else: right';
		generateSSAModule.

	function := ssaModule globalNamed: #select.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 5.
	self assert: function basicBlocks second firstInstruction isBranch.
	self assert: function basicBlocks fifth firstInstruction isPhi.
	self assert: function basicBlocks fifth lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testSelect2 [
	| function |
	self
		evaluateSysmelSource: 
'function select externC(cond: BooleanBit, left: UInt16 ref, right: UInt16) => UInt16
	:= if: cond then: left else: right';
		generateSSAModule.

	function := ssaModule globalNamed: #select.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 5.
	self assert: function basicBlocks second firstInstruction isBranch.
	self assert: function basicBlocks fifth firstInstruction isPhi.
	self assert: function basicBlocks fifth lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testSelect3 [
	| function |
	self
		evaluateSysmelSource: 
'function select externC(cond: BooleanBit, left: UInt16, right: UInt16 ref) => UInt16
	:= if: cond then: left else: right';
		generateSSAModule.

	function := ssaModule globalNamed: #select.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 5.
	self assert: function basicBlocks second firstInstruction isBranch.
	self assert: function basicBlocks fifth firstInstruction isPhi.
	self assert: function basicBlocks fifth lastInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testSeparateDeclarationDefinition [
	| function |
	self
		evaluateSysmelSource: '
function f externC() => Int32.
function f externC() => Int32 := 1.
';
		generateSSAModule.

	function := ssaModule globalNamed: #f.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testSeparateDeclarationDefinition2 [
	| function |
	self
		evaluateSysmelSource: '
function f externC() => Int32 := 1.
function f externC() => Int32.
';
		generateSSAModule.

	function := ssaModule globalNamed: #f.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testSeparateMessageDeclarationDefinition [
	| function |
	self
		evaluateSysmelSource: '
struct TestStruct definition: {
	message f => Int32.
	message f => Int32 := 1.

}.
';
		generateSSAModule.

	function := ssaModule globalNamed: #_S10TestStruct1fFRTs_S10TestStruct.
	self assert: function isFunction.
	self deny: function isEmpty.
	self assert: function basicBlocks size equals: 2.
	self assert: function basicBlocks second firstInstruction isReturn.
]

{ #category : #tests }
MbndSlovimCodeModuleGeneratorTest >> testSeparateMessageDeclarationDefinition2 [
	| function |
	self
		evaluateSysmelSource: '
struct TestStruct definition: {
	message f => Int32 := 1.
	message f => Int32.
}.
';
		generateSSAModule.

	function := ssaModule globalNamed: #_S10TestStruct1fFRTs_S10TestStruct.
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
