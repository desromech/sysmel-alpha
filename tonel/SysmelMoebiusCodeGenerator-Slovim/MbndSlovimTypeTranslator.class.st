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
MbndSlovimTypeTranslator >> visitDecoratedType: type [
	^ self translateType: type baseType
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
MbndSlovimTypeTranslator >> visitPrimitiveIntegerType: integerType [
	self halt
]
