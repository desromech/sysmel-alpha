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

Compiler compilationTarget managedObjectModel
    arrayClass: Array;
    byteArrayClass: ByteArray;
    compiledMethodClass: CompiledMethod;
    dictionaryClass: Dictionary;
    methodDictionaryClass: MethodDictionary;
    symbolClass: Symbol;
    stringClass: String;
	integerClass: Integer;
	floatClass: Float;
	boolClass: Boolean;
	trueClass: True;
	falseClass: False;
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
