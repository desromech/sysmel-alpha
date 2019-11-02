Class {
	#name : #MbndSlovimCodeModuleGenerator,
	#superclass : #MbndAbstractCodeModuleGenerator,
	#instVars : [
		'sourceModule',
		'ssaModule',
		'translatedProgramEntities',
		'typeTranslator',
		'typeNameMangler',
		'programEntityTypeNameMangler'
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

		(booleanType bool)
		(undefinedType voidPointerType)
	) do: [ :pair |
		sourceType := sourceTarget perform: pair first.
		destType := destTarget perform: pair second.
		self typeTranslator setType: sourceType ssaType: destType
	].

]

{ #category : #accessing }
MbndSlovimCodeModuleGenerator >> compilationTarget [
	^ sourceModule compilationTarget
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

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> escapeCharacterForMangling: c into: out [
	c = $_ ifTrue: [ 
		^ out nextPutAll: '__'
	].
	c = $: ifTrue: [ 
		^ out nextPutAll: '_c'
	].
	^ out nextPut: c

]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> escapeNameForMangling: name [
	name ifNil: [ ^ '_anon' ].
	^ ByteString streamContents: [ :out |
		name do: [ :c |
			self escapeCharacterForMangling: c into: out
		]
	]
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
	| escapedNamed mangledType |
	programEntity ifNil: [ ^ #_S ].
	(programEntity parent isNil and: [ programEntity isNamespace ]) ifTrue: [ ^ #_S ].
	escapedNamed := self escapeNameForMangling: programEntity name.
	mangledType := self mangleProgramEntityType: programEntity.
	^ ((self mangleProgramEntityName: programEntity parent) , escapedNamed size asString , escapedNamed , mangledType) asSymbol
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> mangleProgramEntityType: programEntity [
	^ self programEntityTypeNameMangler visitNode: programEntity
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> programEntityTypeNameMangler [
	^ programEntityTypeNameMangler ifNil: [ programEntityTypeNameMangler := MbndSlovimProgramEntityTypeNameMangler new codeModuleGenerator: self ]
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

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> translateProgramEntityChildren: programEntity [
	programEntity children do: [ :child |
		self translateProgramEntity: child
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

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> typeNameMangler [
	^ typeNameMangler ifNil: [ typeNameMangler := MbndSlovimTypeNameMangler new codeModuleGenerator: self ]
]

{ #category : #accessing }
MbndSlovimCodeModuleGenerator >> typeTranslator [
	^ typeTranslator ifNil: [ typeTranslator := MbndSlovimTypeTranslator new codeModuleGenerator: self ]
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitAggregateTypeWithFields: type [
	| ssaType |
	ssaType := self translateType: type.
	self setProgramEntity: type ssaValue: (SLVMConstant nullPointer: self slvmCompilationTarget voidPointerType).
	(ssaType isStructureType and: [ ssaType name isNotNil ]) ifTrue: [ 
		ssaModule addStructure: ssaType
	].

	self translateProgramEntityChildren: type.
	
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
MbndSlovimCodeModuleGenerator >> visitFieldVariable: field [
	^ nil
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitFunctionGroup: functionGroup [
	^ nil
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitGCClassType: type [
	^ self visitAggregateTypeWithFields: type
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitGlobalVariable: globalVariable [
	| ssaValueType csymbol ssaGlobalVariable initialValue |
	ssaValueType := self translateType: globalVariable valueType.
	
	csymbol := self csymbolForProgramEntity: globalVariable.
	ssaGlobalVariable := SLVMGlobalVariable module: ssaModule name: csymbol valueType: ssaValueType storage: SLVMType genericStorage.
	self setProgramEntity: globalVariable ssaValue: ssaGlobalVariable.

	ssaGlobalVariable readOnly: (globalVariable type withoutReferences isConstantType).
	
	globalVariable isExternal ifTrue: [
		globalVariable makeExternal.
	] ifFalse: [ 
		initialValue := globalVariable currentValue.
		self assert: initialValue isNotNil.
		ssaGlobalVariable initialValue: (self translateLiteralValue: initialValue value ofType: initialValue type).
		globalVariable isStatic ifTrue: [ 
			ssaGlobalVariable makePrivate
		].
	].
		
	^ ssaGlobalVariable
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
MbndSlovimCodeModuleGenerator >> visitIntrinsicPointerComparisonMethod: intrinsicMethod [
	^ self setProgramEntity: intrinsicMethod translation: (MbndSlovimTranslatedIntrinsicPointerComparisonOperation new programEntity: intrinsicMethod)
	
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitMacroMessageMethod: macro [
	^ nil
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitMessageGroup: functionGroup [
	^ nil
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitModule: module [
	^ self translateProgramEntity: module globalNamespace
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitNamespace: namespace [
	self translateProgramEntityChildren: namespace.
	^ nil
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitStructureType: type [
	^ self visitAggregateTypeWithFields: type
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitTemplate: template [
	self translateProgramEntityChildren: template.
	^ nil
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitTemplateInstance: templateInstance [
	self translateProgramEntityChildren: templateInstance
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitUnionType: type [
	^ self visitAggregateTypeWithFields: type
]

{ #category : #visiting }
MbndSlovimCodeModuleGenerator >> visitVTablePointerFieldVariable: vtableField [
	| ssaValueType csymbol ssaVTableDefinition vtableEntryType additionalFields methodFields |
	
	vtableEntryType := self slvmCompilationTarget voidPointerType.
	additionalFields := {
		"Offset" SLVMConstant type: vtableEntryType value: 0.
		"Type info" . SLVMConstant pointer: (self translateProgramEntity: vtableField parent) ssaValue castTo: vtableEntryType.
	}.
	
	methodFields := vtableField vtableSlots collect: [ :vtableMethod |
		SLVMConstant pointer: (self translateProgramEntity: vtableMethod) ssaValue
			castTo: vtableEntryType
	].
	
	ssaValueType := (SLVMArrayType baseType: vtableEntryType elements: additionalFields size + methodFields size ).
	csymbol := self mangleProgramEntityName: vtableField.
	
	ssaVTableDefinition := SLVMGlobalVariable module: ssaModule name: csymbol valueType: ssaValueType storage: SLVMType genericStorage.
	self setProgramEntity: vtableField ssaValue: ssaVTableDefinition.
	ssaVTableDefinition
		readOnly: true;
		initialValue: (SLVMConstant array: ssaValueType slots: additionalFields , methodFields).

	vtableField parent hasPrivateVisibility ifTrue: [ 
		ssaVTableDefinition makePrivate
	].

	^ ssaVTableDefinition
]
