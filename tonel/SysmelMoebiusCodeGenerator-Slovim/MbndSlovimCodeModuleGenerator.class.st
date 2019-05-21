Class {
	#name : #MbndSlovimCodeModuleGenerator,
	#superclass : #MbndAbstractCodeModuleGenerator,
	#instVars : [
		'sourceModule',
		'ssaModule',
		'translatedProgramEntities',
		'typeTranslator'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> addPrimitiveTypeTranslations [
	| sourceTarget destTarget sourceType destType |
	sourceTarget := sourceModule compilationTarget.
	destTarget := self slvmCompilationTarget.
	
	#(
		(voidType void)

		(uint8Type uint8)
		(uint16Type uint16)
		(uint32Type uint32)
		(uint64Type uint64)

		(int8Type int8)
		(int16Type int16)
		(int32Type int32)
		(int64Type int64)

		(float32Type float32)
		(float64Type float64)
	) do: [ :pair |
		sourceType := sourceTarget perform: pair first.
		destType := destTarget perform: pair second.
		self typeTranslator setType: sourceType ssaType: destType
	].

]

{ #category : #'as yet unclassified' }
MbndSlovimCodeModuleGenerator >> createFunctionCodeGenerator [
	^ MbndSlovimFunctionCodeGenerator new
		codeModuleGenerator: self;
		yourself
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> csymbolForProgramEntity: programEntity [
	programEntity name ifNil: [ ^ nil ].

	(programEntity hasFlag: #externC) ifTrue: [
		^ programEntity name
	].

	^ self mangleProgramEntityName: programEntity
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> generateCodeModuleFor: aModule [
	sourceModule := aModule.
	ssaModule := SLVMModule new compilationTarget: self slvmCompilationTarget.
	self addPrimitiveTypeTranslations.
	self translateProgramEntity: sourceModule.
	
	^ ssaModule
]

{ #category : #initialization }
MbndSlovimCodeModuleGenerator >> initialize [
	super initialize.
	translatedProgramEntities := Dictionary new.
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> mangleProgramEntityName: programEntity [
	programEntity ifNil: [ ^ #_S ].
	(programEntity parent isNil and: [ programEntity isNamespace ]) ifTrue: [ ^ #_S ].
	^ ((self mangleProgramEntityName: programEntity parent) , programEntity name size asString , programEntity name) asSymbol
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> setProgramEntity: programEntity ssaValue: ssaValue [
	self setProgramEntity: programEntity translation: (MbndSlovimTranslatedProgramEntitySSAValue new
		programEntity: programEntity;
		ssaValue: ssaValue;
		yourself)
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> setProgramEntity: programEntity translation: translation [
	translatedProgramEntities at: programEntity put: translation.
	^ translation
]

{ #category : #accessing }
MbndSlovimCodeModuleGenerator >> slvmCompilationTarget [
	^ sourceModule compilationTarget slvmCompilationTarget
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> translateLiteralValue: literalValue ofType: literalType [
	^ MbndSlovimLiteralValueGenerator new
		codeModuleGenerator: self;
		translateLiteralValue: literalValue ofType: literalType
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> translateProgramEntity: programEntity [
	^ translatedProgramEntities at: programEntity ifAbsent: [
		| ssaValue |
		ssaValue := programEntity accept: self.
		translatedProgramEntities at: programEntity ifAbsent: [
			self setProgramEntity: programEntity ssaValue: ssaValue
		].
	]
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> translateType: aType [
	^ self typeTranslator translateType: aType
]

{ #category : #'code generation' }
MbndSlovimCodeModuleGenerator >> translateTypes: aType [
	^ self typeTranslator translateTypes: aType
]

{ #category : #accessing }
MbndSlovimCodeModuleGenerator >> typeTranslator [
	^ typeTranslator ifNil: [ typeTranslator := MbndSlovimTypeTranslator new codeModuleGenerator: self ]
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitAggregateTypeWithFields: type [
	| ssaType |
	ssaType := self translateType: type.
	(ssaType isStructureType and: [ ssaType name isNotNil ]) ifTrue: [ 
		ssaModule addStructure: ssaType
	].
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitClassType: type [
	^ self visitAggregateTypeWithFields: type
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitCompileTimeConstant: node [
	"For we will just ignore this here"
	^ nil
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitConcreteFunctionMethod: functionMethod [
	| ssaFunctionType csymbol ssaFunction |
	ssaFunctionType := self translateType: functionMethod type.
	
	csymbol := self csymbolForProgramEntity: functionMethod.
	ssaFunction := SLVMFunction module: ssaModule name: csymbol functionType: ssaFunctionType.
	self setProgramEntity: functionMethod ssaValue: ssaFunction.
	
	functionMethod analyzedBody ifNil: [
		ssaFunction makeExternal
	] ifNotNil: [
		self flag: 'TODO: Support the correct linkage/visibility.'.
		ssaFunction makePublic.
		
		self createFunctionCodeGenerator
			buildSSAFunction: ssaFunction definitionWithConcreteMethod: functionMethod
	].
	
	^ ssaFunction
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitConcreteMessageMethod: functionMethod [
	self halt
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitGCClassType: type [
	^ self visitAggregateTypeWithFields: type
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitIntrinsicArithmeticBinaryOperationMethod: intrinsicMethod [
	^ self setProgramEntity: intrinsicMethod translation: (MbndSlovimTranslatedIntrinsicArithmeticBinaryOperation new programEntity: intrinsicMethod)
	
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitIntrinsicArithmeticComparisonMethod: intrinsicMethod [
	^ self setProgramEntity: intrinsicMethod translation: (MbndSlovimTranslatedIntrinsicArithmeticComparisonOperation new programEntity: intrinsicMethod)
	
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitIntrinsicArithmeticUnaryOperationMethod: intrinsicMethod [
	^ self setProgramEntity: intrinsicMethod translation: (MbndSlovimTranslatedIntrinsicArithmeticUnaryOperation new programEntity: intrinsicMethod)
	
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitModule: module [
	^ self translateProgramEntity: module globalNamespace
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitNamespace: namespace [
	namespace localSymbolTable valuesDo: [ :localSymbol |
		self translateProgramEntity: localSymbol
	].

	namespace overloadedMethodDict valuesDo: [ :method |
		self translateProgramEntity: method
	].


]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitStructureType: type [
	^ self visitAggregateTypeWithFields: type
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitUnionType: type [
	^ self visitAggregateTypeWithFields: type
]
