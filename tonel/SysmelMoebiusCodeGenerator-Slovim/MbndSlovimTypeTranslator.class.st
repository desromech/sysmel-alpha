Class {
	#name : #MbndSlovimTypeTranslator,
	#superclass : #MbndAbstractModuleVisitor,
	#traits : 'TMbndSlovimModulePartTranslator',
	#classTraits : 'TMbndSlovimModulePartTranslator classTrait',
	#instVars : [
		'translatedTypes'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #initialization }
MbndSlovimTypeTranslator >> initialize [
	super initialize.
	translatedTypes := Dictionary new.
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> setType: type ssaType: ssaType [
	translatedTypes at: type put: ssaType
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> translateAggregateType: aggregateType [
	| ssaStructureType |
	ssaStructureType := SLVMStructureType name: (codeModuleGenerator mangleProgramEntityName: aggregateType)
		types: #() kind: SLVMStructureType genericKind names: #().
	translatedTypes at: aggregateType put: ssaStructureType.
	
	aggregateType isDefined ifTrue: [ 
		ssaStructureType
			names: (aggregateType slotLayout slots collect: #name);
			types: (aggregateType slotLayout slots collect: [:slot | self translateType: slot type]).
	].
		
	^ ssaStructureType
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> translateType: aType [
	^ translatedTypes at: aType ifAbsentPut: [
		aType isTrait ifFalse: [
			aType accept: self
		] ifTrue: [
			self halt
		].
	]

]

{ #category : #visiting }
MbndSlovimTypeTranslator >> translateTypes: aCollectionOfTypes [
	^ aCollectionOfTypes collect: [ :type | self translateType: type ]
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitArrayType: arrayType [
	| elementType |
	elementType := self translateType: arrayType elementType.
	^ SLVMArrayType baseType: elementType elements: arrayType elements
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitClassType: structureType [
	^ self translateAggregateType: structureType

]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitDecoratedType: type [
	^ self translateType: type baseType
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitEnumType: enumType [
	^ self translateType: enumType valueType
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitFunctionType: functionType [
	| argumentSSATypes returnSSAType |
	argumentSSATypes := self translateTypes: functionType argumentTypes.
	returnSSAType := self translateType: functionType returnType.
	^ (SLVMFunctionType callingConvention: functionType callingConvention arguments: argumentSSATypes returnType: returnSSAType)
		variadic: functionType cvariadic;
		yourself
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitGCClassType: structureType [
	^ self translateAggregateType: structureType

]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitPointerType: pointerType [
	"This could be a recursive type."
	| ssaPointerType |
	ssaPointerType := SLVMPointerType new
		size: self slvmCompilationTarget pointerSize;
		storage: pointerType addressSpace;
		yourself.
	translatedTypes at: pointerType put: ssaPointerType.
	
	ssaPointerType baseType: (self translateType: pointerType baseType).
	^ ssaPointerType
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitPrimitiveBooleanType: integerType [
	self error: 'Unsupported primitive type.'
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitPrimitiveIntegerType: integerType [
	self halt
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitReferenceType: referenceType [
	^ self translateType: referenceType asPointerType
]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitStructureType: structureType [
	^ self translateAggregateType: structureType

]

{ #category : #visiting }
MbndSlovimTypeTranslator >> visitUnionType: structureType [
	^ self translateAggregateType: structureType

]
