Class {
	#name : #MbndSlovimTypeNameMangler,
	#superclass : #MbndAbstractModuleVisitor,
	#traits : 'TMbndSlovimModulePartTranslator',
	#classTraits : 'TMbndSlovimModulePartTranslator classTrait',
	#instVars : [
		'builtInManglingTable'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #accessing }
MbndSlovimTypeNameMangler >> buildBuiltInTypeManglingTable [
	| target |
	target := self codeModuleGenerator compilationTarget.
	builtInManglingTable := Dictionary new.
	"This is based in the C++ itanium mangling scheme https://itanium-cxx-abi.github.io/cxx-abi/abi.html#demangler"
	#(
		voidType v
		booleanType b
		uint8Type c
		int8Type a
		uint16Type t
		int16Type s
		uint32Type j
		int32Type i
		uint64Type m
		int64Type l
		float16Type h
		float32Type f
		float64Type d
	) pairsDo: [ :typeName :mangledName |
		builtInManglingTable at: (target perform: typeName) put: mangledName
	].
]

{ #category : #accessing }
MbndSlovimTypeNameMangler >> codeModuleGenerator: anObject [
	codeModuleGenerator := anObject.
	self buildBuiltInTypeManglingTable.
]

{ #category : #visiting }
MbndSlovimTypeNameMangler >> visitArrayType: arrayType [
	self assert: arrayType elements isInteger.
	^ 'A' , arrayType elements asString , 'e' , (self visitNode: arrayType elementType)
]

{ #category : #visiting }
MbndSlovimTypeNameMangler >> visitClassType: metaType [
	^ 'Tc' , (codeModuleGenerator mangleProgramEntityName: metaType)
]

{ #category : #visiting }
MbndSlovimTypeNameMangler >> visitDecoratedType: type [
	| decorations |
	decorations := ''.
	type isConstantType ifTrue: [ decorations := 'C' ].
	
	^ decorations , (self visitNode: type baseType)
]

{ #category : #visiting }
MbndSlovimTypeNameMangler >> visitEnumType: metaType [
	^ 'Te' , (codeModuleGenerator mangleProgramEntityName: metaType)
]

{ #category : #visiting }
MbndSlovimTypeNameMangler >> visitFunctionType: functionType [
	^ ByteString streamContents: [ :out |
		out nextPut: $F.
		functionType argumentTypes do: [ :arg | out nextPutAll: (self visitNode: arg) ].
		functionType isCVariadic ifTrue: [ out nextPut: $z ]
	]
]

{ #category : #visiting }
MbndSlovimTypeNameMangler >> visitGCClassType: metaType [
	^ 'Tg' , (codeModuleGenerator mangleProgramEntityName: metaType)
]

{ #category : #visiting }
MbndSlovimTypeNameMangler >> visitInputChannelType: type [
	^ 'TCi' , (self visitNode: type messageType)
]

{ #category : #accessing }
MbndSlovimTypeNameMangler >> visitNode: node [
	builtInManglingTable at: node ifPresent: [ :existent | ^ existent ].
	^ node accept: self
]

{ #category : #visiting }
MbndSlovimTypeNameMangler >> visitOutputChannelType: type [
	^ 'TCo' , (self visitNode: type messageType)
]

{ #category : #visiting }
MbndSlovimTypeNameMangler >> visitPointerType: type [
	^ 'P' , (self visitNode: type baseType)
]

{ #category : #visiting }
MbndSlovimTypeNameMangler >> visitPrimitiveMatrixType: matrixType [
	self assert: matrixType elements isInteger.
	^ 'M' , matrixType rows asString , 'c' , matrixType columns asString , 'e' , (self visitNode: matrixType elementType)
]

{ #category : #visiting }
MbndSlovimTypeNameMangler >> visitPrimitiveVectorType: vectorType [
	self assert: vectorType elements isInteger.
	^ 'V' , vectorType elements asString , 'e' , (self visitNode: vectorType elementType)
]

{ #category : #visiting }
MbndSlovimTypeNameMangler >> visitReferenceType: type [
	^ 'R' , (self visitNode: type baseType)
]

{ #category : #visiting }
MbndSlovimTypeNameMangler >> visitSimpleMetaType: metaType [
	^ 'Tm' , (codeModuleGenerator mangleProgramEntityName: metaType)
]

{ #category : #visiting }
MbndSlovimTypeNameMangler >> visitStructureType: metaType [
	^ 'Ts' , (codeModuleGenerator mangleProgramEntityName: metaType)
]

{ #category : #visiting }
MbndSlovimTypeNameMangler >> visitUnionType: metaType [
	^ 'Tu' , (codeModuleGenerator mangleProgramEntityName: metaType)
]
