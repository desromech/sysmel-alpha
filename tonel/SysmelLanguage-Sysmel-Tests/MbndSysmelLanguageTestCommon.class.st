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
}.

compileTimeConstant RefCountedPtr := IntrusivePointer(RefCounted).
'
	
]

{ #category : #tests }
MbndSysmelLanguageTestCommon >> evaluateIntrusivePointerTemplate [
	^ self evaluateSource: '
template IntrusivePointer(PT: Type)
	:= struct definition: {
	compileTimeConstant PointedType := PT.
	compileTimeConstant PointerType := PointedType pointer.

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
	
	method initializeFrom: (o: SelfType const ref) ::=> Void := {
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
MbndSysmelLanguageTestCommon >> evaluateMiniObjectModelRuntime [
	^ self evaluateSource: '
compileTimeConstant _BasicInitializeFunctionPointerType := ((Void pointer) => Void) pointer.

gcclass ProtoObject.
gcclass Metaclass.

ProtoObject metaClassClass: Metaclass.
Metaclass metaClassClass: Metaclass.

Compiler compilationTarget dynamicObjectType: ProtoObject.

gcclass Object superclass: ProtoObject.
    gcclass Behavior superclass: Object.
        gcclass ClassDescription superclass: Behavior.
            gcclass Class superclass: ClassDescription.
            gcclass Metaclass superclass: ClassDescription.

    ## Boolean8
    gcclass Boolean superclass: Object.
        gcclass True superclass: Boolean.
        gcclass False superclass: Boolean.

    ## Undefined object
    gcclass UndefinedObject superclass: Object.

    ## Numbers
    gcclass Magnitude superclass: Object.
        gcclass Number superclass: Magnitude.
            gcclass Float superclass: Number.
                gcclass BoxedFloat64 superclass: Float.
                gcclass SmallFloat64 superclass: Float.
            gcclass Integer superclass: Number.
                gcclass LargeInteger superclass: Integer.
                    gcclass LargeNegativeInteger superclass: LargeInteger.
                    gcclass LargePositiveInteger superclass: LargeInteger.
                gcclass SmallInteger superclass: Integer.
		gcclass Character superclass: Magnitude.

		gcclass LookupKey superclass: Magnitude.
			gcclass Association superclass: LookupKey.
				gcclass LiteralVariable superclass: Association.
					gcclass AdditionalBinding superclass: LiteralVariable.
					gcclass ClassVariable superclass: LiteralVariable.
					gcclass GlobalVariable superclass: LiteralVariable.
					gcclass UndeclaredVariable superclass: LiteralVariable.
					gcclass WorkspaceVariable superclass: LiteralVariable.
					
    gcclass GCLayout superclass: Object.

## Essential collections
gcclass Collection superclass: Object.
    gcclass HashedCollection superclass: Collection.
        gcclass Dictionary superclass: HashedCollection.
            gcclass MethodDictionary superclass: Dictionary.
    gcclass SequenceableCollection superclass: Collection.
        gcclass ArrayedCollection superclass: SequenceableCollection.
            gcclass Array superclass: ArrayedCollection.
            gcclass ByteArray superclass: ArrayedCollection.
            gcclass FloatArray superclass: ArrayedCollection.
            gcclass IntegerArray superclass: ArrayedCollection.
            gcclass WordArray superclass: ArrayedCollection.

            gcclass String superclass: ArrayedCollection.
                gcclass Symbol superclass: String.

## Methods
gcclass CompiledMethod superclass: Object.
gcclass AdditionalMethodState superclass: Object.

## Block closures
gcclass BlockClosureHeaderClass superclass: Object.
gcclass BlockClosure superclass: BlockClosureHeaderClass.

## ProtoObject
ProtoObject type supertype: Class.

Compiler compilationTarget defaultGCClassSuperClass: Object.

ProtoObject definition: {
    ## We use a fixed 16-byte object header, to be able to use SSE instructions.
    (SelfType addMainVTableFieldNamed: #__vtable) private.

    ## 32 bits: gc color, isPinned, isImmutable.
    field _ private bits: 5; type: UInt32.

    field __gcBits private type: UInt32; bits: 3.
    field __isPinned private type: UInt32; bits: 1.
    field __isImmutable private type: UInt32; bits: 1.
    field __identityHash private type: UInt32; bits: 22.

    ## Variable data size
    field __variableDataSize private type: UInt32.
}.

Behavior definition: {
    field superclass public type: Behavior.
    field methodDict public type: MethodDictionary.
    field gclayout public type: GCLayout.
    field basicInitializeFunctionPointer public type: _BasicInitializeFunctionPointerType.
    field slots public type: Array.

    field instanceDataSize public type: UInt32.
    field instanceDataAlignment public type: UInt32.

    field variableInstanceElementSize public type: UInt32.
    field variableInstanceElementAlignment public type: UInt32.
}.

## GCLayoutRecord
struct GCLayoutRecord definition: {
    field type public type: UIntPointer.
    field offset public type: UIntPointer.
    field size public type: UIntPointer.
}.

## GCLayout
GCLayout definition: {
    field records public type: GCLayoutRecord array.
}.

## String
String definition: {
    field __data protected type: UInt8 array.
}.

Array definition: {
    field __data protected type: ProtoObject array.
}.

HashedCollection definition: {
    field tally protected type: UIntPointer.
    field array protected type: Array.
}.

MethodDictionary definition: {
    field values protected type: Array.
}.

LookupKey definition: {
	public field key type: ProtoObject.
}.

Association definition: {
	public field value type: ProtoObject.
}.

Compiler compilationTarget managedObjectModel
    arrayClass: Array;
    associationClass: Association;
    byteArrayClass: ByteArray;
    compiledMethodClass: CompiledMethod;
    dictionaryClass: Dictionary;
    methodDictionaryClass: MethodDictionary;
	additionalMethodStateClass: AdditionalMethodState;
    symbolClass: Symbol;
    stringClass: String;
	characterClass: Character;
	integerClass: Integer;
	floatClass: Float;
	boolClass: Boolean;
	trueClass: True;
	falseClass: False;

	additionalBindingClass: AdditionalBinding;
	classVariableClass: ClassVariable;
	globalVariableClass: GlobalVariable;
	undeclaredVariableClass: UndeclaredVariable;
	workspaceVariableClass: WorkspaceVariable;
	
	blockClosureHeaderClass: BlockClosureHeaderClass;
	blockClosureClass: BlockClosure;
    yourself
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
