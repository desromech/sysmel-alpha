Class {
	#name : #MbndSlovimLiteralValueGenerator,
	#superclass : #MbndAbstractModuleVisitor,
	#traits : 'TMbndSlovimModulePartTranslator',
	#classTraits : 'TMbndSlovimModulePartTranslator classTrait',
	#instVars : [
		'literalValue'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #accessing }
MbndSlovimLiteralValueGenerator >> literalValue [
	^ literalValue
]

{ #category : #accessing }
MbndSlovimLiteralValueGenerator >> literalValue: anObject [
	literalValue := anObject
]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> translateLiteralValue: theLiteralValueToTranslate ofType: literalType [
	literalValue := theLiteralValueToTranslate.
	^ literalType accept: self
]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> visitDecoratedType: decoratedType [
	^ decoratedType baseType accept: self

]

{ #category : #visiting }
MbndSlovimLiteralValueGenerator >> visitLiteralValueType: type [
	^ literalValue
]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> visitPointerType: pointerType [
	| baseType undecoratedBaseType |
	(literalValue isNil or: [ literalValue isInteger ]) ifTrue: [
		^ SLVMConstant type: (self translateType: pointerType) value: literalValue
	].

	baseType := pointerType baseType.
	undecoratedBaseType := pointerType baseType withoutDecorations.
	literalValue isString ifTrue: [
		(baseType isConstantType and:
		[ undecoratedBaseType isPrimitiveIntegerType]) ifTrue: [ 
			undecoratedBaseType instanceSize = 1 ifTrue: [ 
				^ SLVMConstant pointerToConstant: (SLVMConstant cstring: literalValue)
					pointerType: (self translateType: pointerType)
			]
		].
	].

	self error: 'Unsupported generation of literals of type {1}.' format: { pointerType asString }

]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> visitPrimitiveBooleanType: integerType [
	^ SLVMConstant type: (self translateType: integerType) value: literalValue
]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> visitPrimitiveFloatType: integerType [
	^ SLVMConstant type: (self translateType: integerType) value: literalValue
]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> visitPrimitiveIntegerType: integerType [
	^ SLVMConstant type: (self translateType: integerType) value: literalValue
]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> visitUndefinedType: undefinedType [
	^ SLVMConstant type: (self translateType: undefinedType) value: literalValue
]

{ #category : #'code generation' }
MbndSlovimLiteralValueGenerator >> visitVoidType: voidType [
	^ nil
]
