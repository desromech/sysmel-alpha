Class {
	#name : #MbndSysmelLanguageTestCommon,
	#superclass : #TestCase,
	#instVars : [
		'semanticModule'
	],
	#category : #'SysmelLanguage-Sysmel-Tests-Parser'
}

{ #category : #testing }
MbndSysmelLanguageTestCommon class >> isAbstract [
	^ self  == MbndSysmelLanguageTestCommon
]

{ #category : #tests }
MbndSysmelLanguageTestCommon >> evaluateIntrusivePointerClass [
	self evaluateIntrusivePointerTemplate.
	^ self evaluateSource: '
class RefCounted definition: { 
	method retain => Void := { 
	}.
	method release => Void := { 
	}.
	
	method sideEffect => Void := {
	}.
}.

compileTime constant RefCountedPtr := IntrusivePointer(RefCounted).
'
	
]

{ #category : #tests }
MbndSysmelLanguageTestCommon >> evaluateIntrusivePointerTemplate [
	^ self evaluateSource: '
template IntrusivePointer(PT: Type)
	:= struct definition: {
	compileTime constant PointedType := PT.
	compileTime constant PointerType := PointedType pointer.

	private field pointer_ type: PointerType.
	
	meta method for: (pointer: PointerType) ::=> SelfType
		:= SelfType basicNewValue initializeWith: pointer; yourself.
	
	method finalize => Void := {
		if: pointer_ ~~ nil then: { 
			pointer_ _ release.
		}.
	}.

	method initializeWith: (pointer: PointerType) ::=> Void := {
		pointer_ := pointer
	}.
	
	method initializeCopyingFrom: (o: SelfType const ref) ::=> Void := {
		pointer_ := o __private pointer_.
		if: pointer_ ~~ nil then: {
			pointer_ _ retain
		}.
	}.

	method initializeMovingFrom: (o: SelfType tempRef) ::=> Void := {
		pointer_ := o __private pointer_.
		o __private pointer_ := nil
	}.

	method _ => PointedType ref
		:= pointer_ _.
		
	method getPointer => PointerType
		:= pointer_.
		
	method reset: (newPointer: PointerType) ::=> Void := {
		if: pointer_ ~~ nil then: { 
			pointer_ _ release
		}.

		pointer_ := newPointer
	}.
	
	method assignValue: (o: SelfType const ref) ::=> SelfType const ref := { 
		let newPointer := o __private pointer_.
		if: newPointer ~~ nil then: {
			newPointer _ retain
		}.
		if: pointer_ ~~ nil then: {
			pointer_ _ release
		}.

		pointer_ := newPointer.
		self
	}.
	
	method assignValue: (o: SelfType tempRef) ::=> SelfType const ref := { 
		let newPointer := o __private pointer_.
		o __private pointer_ := nil.
		if: pointer_ ~~ nil then: {
			pointer_ _ release
		}.

		pointer_ := newPointer.
		self
	}.
}.

'
	
]

{ #category : #tests }
MbndSysmelLanguageTestCommon >> evaluateIntrusiveRefClass [
	self evaluateIntrusiveRefTemplate.
	^ self evaluateSource: '
compileTime constant RefCountedRef := IntrusiveRef(RefCounted).
'
	
]

{ #category : #tests }
MbndSysmelLanguageTestCommon >> evaluateIntrusiveRefTemplate [
	^ self evaluateSource: '
template IntrusiveRef(PT: Type)
	:= struct definition: {
	compileTime constant PointedType := PT.
	compileTime constant IntrusivePointerType := IntrusivePointer(PointedType).

	public field __intrusivePointer__ type: IntrusivePointerType.
	
	macro method doesNotUnderstand: aMessage
		:= ``(`,self __intrusivePointer__ _ __macroSendMessage: `,aMessage)
}.

'
	
]

{ #category : #tests }
MbndSysmelLanguageTestCommon >> evaluateMiniExceptionRuntime [
	self evaluateSource: '
	
class Exception definition: {
	public field message type: Char8 const pointer.
}.
class Error superclass: Exception; definition: {}.
class AssertionFailure superclass: Error; definition: {}.
class InternalNonLocalReturn superclass: Exception; definition: {}.
Compiler compilationTarget internalNonLocalReturnExceptionClass: InternalNonLocalReturn.
'.
	semanticModule compilationTarget hasNoExceptionModel ifTrue: [ 
	self evaluateSource: '
	struct JmpBuffer definition: {
		public field state type: UIntPointer.
	}.

	struct ExceptionContext definition: {
		public field landingPadContext type: JmpBuffer.
		public field catchedExceptionDescriptor type: UIntPointer.
		public field catchedExceptionTypes type: Void pointer pointer.
	}.

Compiler compilationTarget
	exceptionContextType: ExceptionContext.
' 
]
]

{ #category : #tests }
MbndSysmelLanguageTestCommon >> evaluateMiniRTTI [
	^ self evaluateSource: '
compileTime constant NativeBasicInitializeFunctionPointerType := ((Void pointer) => Void) pointer.
compileTime constant CopyConstructorFunctionPointerType := ((Void pointer -- Void pointer) => Void) pointer.
compileTime constant MoveConstructorFunctionPointerType := ((Void pointer -- Void pointer) => Void) pointer.
compileTime constant FinalizeFunctionPointerType := ((Void pointer) => Void) pointer.

class TypeInformation definition: {
	public field superclass type: TypeInformation pointer.
	public field instanceDataSize type: UIntPointer.
	public field instanceDataAlignment type: UIntPointer.
	public field basicInitializationFunctionPointer type: NativeBasicInitializeFunctionPointerType.
	public field copyConstructorFunctionPointer type: CopyConstructorFunctionPointerType.
	public field moveConstructorFunctionPointer type: MoveConstructorFunctionPointerType.
   public field finalizeFunctionPointer type: FinalizeFunctionPointerType.
}.

Compiler compilationTarget
    typeInformationClass: TypeInformation.
'
	
]

{ #category : #tests }
MbndSysmelLanguageTestCommon >> evaluateShaderMetadata [
	^ self evaluateSource: '
class ComputeStageInput definition: {
	<gpu>

	public field numberOfWorkGroups type: UInt32x3; intrinsic: #workgroupCount.
	public field workgroupID type: UInt32x3; intrinsic: #workgroupID.
	public field localInvocationID type: UInt32x3; intrinsic: #localInvocationID.
	public field globalInvocationID type: UInt32x3; intrinsic: #globalInvocationID.
	public field localInvocationIndex type: UInt32; intrinsic: #localInvocationIndex.

	method gridSizeForLocalSize: (localSize: UInt32x3) ::=> UInt32x3
		:= numberOfWorkGroups*localSize.

	method globalIndexForGridSize: (gridSize: UInt32x3) ::=> UInt32
		:= globalInvocationID x +
		   globalInvocationID y*gridSize x +
		   globalInvocationID z*gridSize x*gridSize y.

	method globalIndexForLocalSize: (localSize: UInt32x3) ::=> UInt32
		:= self globalIndexForGridSize: (self gridSizeForLocalSize: localSize).

	macro method gridSize := ``(`,self gridSizeForLocalSize: localSize).
	macro method globalIndex := ``(`,self globalIndexForLocalSize: localSize).
}.

class VertexStageInput definition: {
	<gpu>
	public field vertexID type: Int32; intrinsic: #vertexID.
	public field instanceID type: Int32; intrinsic: #instanceID.
}.

class VertexStageOutput definition: {
	<gpu>
	public field screenPosition type: Float32x4; intrinsic: #position.
}.

class FragmentStageInput definition: {
	<gpu>
	public field fragCoord type: Float32x4; intrinsic: #fragCoord.
	public field pointCoord type: Float32x2; intrinsic: #pointCoord.
	public field isFrontFacing type: Boolean8; intrinsic: #frontFacing.
}.

struct ShaderModuleInfo definition: {
	public field blobSize type: UInt32.
	public field blobStartPointer type: UInt8 const pointer.
}.

struct ShaderEntryPointInfo definition: {
	public field moduleInfo type: ShaderModuleInfo pointer.
	public field nativeShaderEntryPoint type: Void pointer.
	public field entryPointSymbol type: Char8 const pointer.
	public field stageType type: Int32.
	public field localSizeX type: UInt32.
	public field localSizeY type: UInt32.
	public field localSizeZ type: UInt32.

	public field interpolatedInputMask type: UInt32.
}.

union NativeShaderIOLocation definition: {
	public field floating type: Float32x4.
	public field integer type: Int32x4.
	public field unsignedInteger type: UInt32x4.
}.

struct NativeComputeShaderIOInterface definition: {
	class Inputs superclass: ComputeStageInput; definition: {
	}.

	public field inputs type: Inputs.
}.

struct NativeVertexShaderIOInterface definition: {
	class Inputs superclass: VertexStageInput; definition: {
		public field locations type: (NativeShaderIOLocation array: 16).
	}.

	class Outputs superclass: VertexStageOutput; definition: {
		public field locations type: (NativeShaderIOLocation array: 16).
	}.

	public field inputs type: Inputs.
	public field outputs type: Outputs.
}.

struct NativeFragmentShaderIOInterface definition: {
	class Inputs superclass: FragmentStageInput; definition: {
		public field locations type: (NativeShaderIOLocation array: 16).
	}.

	class Outputs definition: {
		public field locations type: (NativeShaderIOLocation array: 16).
	}.

	public field inputs type: Inputs.
	public field outputs type: Outputs.
}.

Compiler compilationTarget
	shaderModuleInfo: ShaderModuleInfo;
	shaderEntryPointInfo: ShaderEntryPointInfo;

	nativeComputeShaderIOInterface: NativeComputeShaderIOInterface;
	nativeVertexShaderIOInterface: NativeVertexShaderIOInterface;
	nativeFragmentShaderIOInterface: NativeFragmentShaderIOInterface.
'
]

{ #category : #'as yet unclassified' }
MbndSysmelLanguageTestCommon >> evaluateSource: aString [
	^ semanticModule evaluateLanguage: #sysmel source: aString
]

{ #category : #'as yet unclassified' }
MbndSysmelLanguageTestCommon >> evaluateSysmelSource: aString [
	^ semanticModule evaluateLanguage: #sysmel source: aString
]

{ #category : #running }
MbndSysmelLanguageTestCommon >> setUp [
	semanticModule := MbndDummyModule new
]
