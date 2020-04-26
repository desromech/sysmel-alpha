Class {
	#name : #MbndAbstractConcreteCompilationTarget,
	#superclass : #Object,
	#traits : 'TMbndCoreCompilationTarget',
	#classTraits : 'TMbndCoreCompilationTarget classTrait',
	#category : #'SysmelMoebiusMetamodel-Core-CompilationTarget'
}

{ #category : #'instance creation' }
MbndAbstractConcreteCompilationTarget class >> for: aCompilationTarget [
	^ self basicNew initializeWithCompilationTarget: aCompilationTarget
]

{ #category : #serialization }
MbndAbstractConcreteCompilationTarget class >> materializeObjectWithType: objectType earlyFields: earlyFields withMessagePackGraphDecoder: graphDecoder [
	self assert: objectType = #CompilationTarget.
	graphDecoder registerObjectInstance: graphDecoder compilationTarget.
	graphDecoder decodeNext.
	^ graphDecoder compilationTarget
]

{ #category : #'derived types' }
MbndAbstractConcreteCompilationTarget >> blockClosureTypeWithArguments: argumentTypes returnType: returnType [
	^ (self functionTypeWithArguments: argumentTypes returnType: returnType) asGCBlockClosureType
]

{ #category : #initialization }
MbndAbstractConcreteCompilationTarget >> initializeArithmeticConversionRules [
	| booleanType char8Type char16Type char32Type int8Type int16Type int32Type int64Type uint8Type uint16Type uint32Type uint64Type float16Type float32Type float64Type |
	booleanType := self booleanType.
	char8Type := self char8Type.
	char16Type := self char16Type.
	char32Type := self char32Type.

	int8Type := self int8Type.
	int16Type := self int16Type.
	int32Type := self int32Type.
	int64Type := self int64Type.
	uint8Type := self uint8Type.
	uint8Type := self uint8Type.
	uint16Type := self uint16Type.
	uint32Type := self uint32Type.
	uint64Type := self uint64Type.
	float16Type := self float16Type.
	float32Type := self float32Type.
	float64Type := self float64Type.
	
	"Positive literal -> Unsigned type"
	int8Type | int16Type | int32Type | int64Type addImplicitConversionTo:
		uint8Type | uint16Type | uint32Type | uint64Type
	rule: MbndPositiveLiteralToUnsignedTypeConversionRule.

	"Bit cast"
	char8Type addConversionTo: uint8Type rule: MbndBitCastTypeConversionRule.
	char16Type addConversionTo: uint16Type rule: MbndBitCastTypeConversionRule.
	char32Type addConversionTo: uint32Type rule: MbndBitCastTypeConversionRule.
	uint8Type addConversionTo: char8Type rule: MbndBitCastTypeConversionRule.
	uint16Type addConversionTo: char16Type rule: MbndBitCastTypeConversionRule.
	uint32Type addConversionTo: char32Type rule: MbndBitCastTypeConversionRule.
	
	int64Type addExplicitConversionTo: uint64Type rule: MbndBitCastTypeConversionRule.
	uint64Type addExplicitConversionTo: int64Type rule: MbndBitCastTypeConversionRule.
	int32Type addExplicitConversionTo: uint32Type rule: MbndBitCastTypeConversionRule.
	uint32Type addExplicitConversionTo: int32Type rule: MbndBitCastTypeConversionRule.
	int16Type addExplicitConversionTo: uint16Type rule: MbndBitCastTypeConversionRule.
	uint16Type addExplicitConversionTo: int16Type rule: MbndBitCastTypeConversionRule.
	int8Type addExplicitConversionTo: uint8Type rule: MbndBitCastTypeConversionRule.
	uint8Type addExplicitConversionTo: int8Type rule: MbndBitCastTypeConversionRule.
	
	"Truncate"
	int64Type | uint64Type |
	int32Type | uint32Type |
	int16Type | uint16Type
		addExplicitConversionTo: int8Type | uint8Type rule: MbndTruncateTypeConversionRule.
	int64Type | uint64Type |
	int32Type | uint32Type
		addExplicitConversionTo: int16Type | uint16Type rule: MbndTruncateTypeConversionRule.
	int64Type | uint64Type
		addExplicitConversionTo: int32Type | uint32Type rule: MbndTruncateTypeConversionRule.
	
	"Sign extension"
	int8Type | int16Type | int32Type addConversionTo:
		int64Type | uint64Type
		rule: MbndSignExtensionTypeConversionRule.
	int8Type | int16Type addConversionTo:
		int32Type | uint32Type | int64Type | uint64Type
		rule: MbndSignExtensionTypeConversionRule.
	int8Type addConversionTo:
		int16Type | uint16Type | int32Type | uint32Type | int64Type | uint64Type
		rule: MbndSignExtensionTypeConversionRule.
	
	"Zero extension"
	uint8Type | uint16Type | uint32Type addConversionTo:
		int64Type | uint64Type
		rule: MbndZeroExtensionTypeConversionRule.
	uint8Type | uint16Type addConversionTo:
		int32Type | uint32Type | int64Type | uint64Type
		rule: MbndZeroExtensionTypeConversionRule.
	uint8Type addConversionTo:
		int16Type | uint16Type | int32Type | uint32Type | int64Type | uint64Type
		rule: MbndZeroExtensionTypeConversionRule.
		
	"Int -> FP"
	int8Type | uint8Type |
	int16Type | uint16Type |
	int32Type | uint32Type |
	int64Type | uint64Type addConversionTo:
		float16Type | float32Type | float64Type
		rule: MbndIntegerToFloatingPointTypeConversionRule.
	
	"FP -> Int"
	float16Type | float32Type | float64Type addExplicitConversionTo:
		int8Type | uint8Type |
		int16Type | uint16Type |
		int32Type | uint32Type |
		int64Type | uint64Type
		rule: MbndFloatingPointToIntegerTypeConversionRule.

	"FP -> FP"
	float16Type addConversionTo: float32Type | float64Type rule: MbndFloatingPointSizeTypeConversionRule.

	float32Type addConversionTo: float64Type rule: MbndFloatingPointSizeTypeConversionRule.
	float32Type addExplicitConversionTo: float16Type rule: MbndFloatingPointSizeTypeConversionRule.

	float64Type addExplicitConversionTo: float16Type | float32Type rule: MbndFloatingPointSizeTypeConversionRule.


	"Bool -> Int"
	booleanType addExplicitConversionTo: uint8Type | int8Type | uint16Type | int16Type |
		uint32Type | int32Type | uint64Type | int64Type
		rule: MbndZeroExtensionTypeConversionRule.
		
	uint8Type | int8Type | uint16Type | int16Type |
		uint32Type | int32Type | uint64Type | int64Type addExplicitConversionTo: booleanType
		rule: MbndNumberToBooleanConversionRule
]

{ #category : #'convenience type accessors' }
MbndAbstractConcreteCompilationTarget >> patternMatchingPatternType [
	^ self getBasicTypeNamed: MbndPatternMatchingPatternType typeName
]

{ #category : #accessing }
MbndAbstractConcreteCompilationTarget >> pointerAlignment [
	self subclassResponsibility
]

{ #category : #accessing }
MbndAbstractConcreteCompilationTarget >> pointerSize [
	self subclassResponsibility
]
