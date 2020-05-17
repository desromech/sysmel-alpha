Class {
	#name : #MbndSlovimSymbolNameMangler,
	#superclass : #MbndAbstractModuleVisitor,
	#instVars : [
		'compilationTarget',
		'codeModuleGenerator',
		'builtInManglingTable',
		'substitutionDictionary',
		'output',
		'substitutionNameCount',
		'nestedNamedComponentsSuffixes',
		'ommitModuleName'
	],
	#classVars : [
		'CharacterSubstitutionTable',
		'DecorationPrefixMap'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Mangling'
}

{ #category : #'class initialization' }
MbndSlovimSymbolNameMangler class >> initialize [
	DecorationPrefixMap := Dictionary newFromPairs: #(
		const K
		volatile V
		restrict r
	).
	
	CharacterSubstitutionTable := Dictionary newFromPairs: #(
		$: '.'
		$$ '$$'
		$. '$.'
		$< '$LT'
		$> '$GT'
		$+ '$PL'
		$- '$MN'
		$* '$ML'
		$/ '$DV'
		$% '$MD'
		$" '$QU'
		$' '$SQ'
		$( '$LP'
		$) '$RP'
		$# '$SH'
		$? '$QS'
		$! '$BN'
		$| '$OR'
		$& '$AN'
		$^ '$XR'
		$~ '$NT'
		$= '$EQ'
	).
]

{ #category : #accessing }
MbndSlovimSymbolNameMangler >> buildBuiltInTypeManglingTable [
	builtInManglingTable := Dictionary new.
	"This is based in the C++ itanium mangling scheme https://itanium-cxx-abi.github.io/cxx-abi/abi.html#demangler"
	#(
		voidType v
		booleanType b
		uint8Type h
		int8Type a
		uint16Type t
		int16Type s
		uint32Type j
		int32Type i
		uint64Type m
		int64Type l
		float16Type DF16_
		float32Type f
		float64Type d

		char8Type c
		char16Type Ds
		char32Type Di
		
		undefinedType Dn

	) pairsDo: [ :typeName :mangledName |
		builtInManglingTable at: (compilationTarget perform: typeName) put: mangledName
	].
]

{ #category : #accessing }
MbndSlovimSymbolNameMangler >> builtInManglingTable [
	builtInManglingTable ifNil: [ self buildBuiltInTypeManglingTable ].
	^ builtInManglingTable
]

{ #category : #accessing }
MbndSlovimSymbolNameMangler >> codeModuleGenerator [
	^ codeModuleGenerator
]

{ #category : #accessing }
MbndSlovimSymbolNameMangler >> codeModuleGenerator: anObject [
	codeModuleGenerator := anObject
]

{ #category : #accessing }
MbndSlovimSymbolNameMangler >> compilationTarget [
	^ compilationTarget
]

{ #category : #accessing }
MbndSlovimSymbolNameMangler >> compilationTarget: anObject [
	compilationTarget := anObject
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> emitSizedName: element [
	output print: element size; nextPutAll: element.

]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> emitSubstitutionElement: element [
	substitutionDictionary at: {element} ifPresent: [ :substitution |
		output nextPutAll: substitution.
	] ifAbsent: [
		self emitSizedName: element.
		self recordSubstitutionElement: element
	].


]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> emitTemplateInstanceArgument: argument [
	| argumentValue argumentType |
	argumentValue := argument unwrapMbndValue.
	argumentType := argument type.

	argumentValue isMbndProgramEntity	ifTrue: [
		argumentType isMetaType ifFalse: [ 
			output nextPutAll: 'L'; nextPutAll: (codeModuleGenerator newSymbolNameMangler mangleProgramEntityName: argumentValue).
			output nextPut: $E.
			^ self
		].
	
		self mangleProgramEntityContentName: argumentValue.
		^ self.
	].

	argumentType isLiteralIntegerType ifTrue: [ 
		argumentType := argumentType bestConcreteTypeForLiteralValueNode: argument asLiteralValueNode inScope: nil
	].

	(argumentType isPrimitiveIntegerType "or: [argumentType isPrimitiveFloatType]") ifTrue: [
		output nextPut: $L.
		self mangleType: argumentType.
		
		argumentValue < 0 ifTrue: [
			output nextPut: $n; print: argumentValue negated
		] ifFalse: [
			output print: argumentValue
		].
		^ self
	].

	(argumentType isLiteralStringType or: [argumentType isLiteralSymbolType]) ifTrue: [
		|escapedString|
		output nextPutAll: 'L_Z'.
		escapedString := self escapeNameForMangling: argumentValue.
		output nextPutAll: escapedString size asString; nextPutAll: escapedString.
		output nextPut: $E.
		^ self
	].

	self error: 'Unsupported template argument in mangling scheme yet'

]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> emitTemplateInstanceArguments: instanceArguments [
	| actualInstanceArguments moduleName |
	output nextPut: $I.
	actualInstanceArguments := instanceArguments.
	(instanceArguments size = 2 and: [ instanceArguments first isMbndProgramEntity and: [ instanceArguments first isStandaloneModule ] ]) ifTrue: [
		moduleName := self escapeNameForMangling: instanceArguments first name.
		output nextPutAll: 'L_Z';
			nextPutAll: moduleName size asString; nextPutAll: moduleName;
			nextPut: $E.
		actualInstanceArguments := instanceArguments second.
	].

	actualInstanceArguments do: [ :arg |
		self emitTemplateInstanceArgument: (arg asMoebiusValueWithTarget: self compilationTarget)
	].
	output nextPut: $E.

]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> escapeCharacterForMangling: c into: out [
	((':.$<>+-*/%"''()#?!|&^~=' includes: c) or: [ c asInteger <= 32 or: [c asInteger >= 126] ]) ifTrue: [
		(CharacterSubstitutionTable at: c ifPresent: [:found | ^ out nextPutAll: found]).
		^ out nextPutAll: '$x' ; nextPutAll: (c asInteger printStringBase: 16 length: 2 padded: true) asLowercase
	].
	^ out nextPut: c

]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> escapeNameForMangling: name [
	(name beginsWith: '..') ifTrue: [ ^ name ].
	name ifNil: [ ^ '_anon' ].
	^ ByteString streamContents: [ :out |
		name do: [ :c |
			self escapeCharacterForMangling: c into: out
		]
	]
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> extractProgramEntityNestedNameComponents: programEntity [
	^ Array streamContents: [ :out |
		self extractProgramEntityNestedNameComponents: programEntity into: out.

		"Add back the global namespace when we are mangling it."
		(programEntity parent isNil and: [ programEntity name = #__global ]) ifTrue: [
			out nextPut: #'..global..'
		].
	
		nestedNamedComponentsSuffixes ifNotNil: [
			out nextPutAll: nestedNamedComponentsSuffixes.
			nestedNamedComponentsSuffixes := nil
		]
	]
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> extractProgramEntityNestedNameComponents: programEntity into: out [
	| validName |

	(programEntity isMbndType and: [ programEntity isSystemProvidedTypeTemplateInstanceMainChild ]) ifTrue: [
		programEntity isVariantUnionType ifTrue: [
			out nextPut: #Variant;
				nextPut: programEntity components.
			^ self
		].		
		programEntity isTupleType ifTrue: [
			out nextPut: #Tuple;
				nextPut: programEntity elements.
			^ self
		].		
	].
	
	"Remove the __global namespace."
	(programEntity parent isNil and: [ programEntity name = #__global ]) ifTrue: [
		ommitModuleName ifFalse: [
			out nextPut: programEntity module name
		].
	
		^ self
	].

	"Put meta types inside their instance type."
	(programEntity isMbndType and: [programEntity isMetaType]) ifTrue: [ 
		programEntity name isMbndAnonymousSymbol ifTrue: [
			self extractProgramEntityNestedNameComponents: programEntity instanceType into: out.
			out nextPut: #'..meta..'.
			^ self
		].
	].
	
	programEntity parent ifNotNil: [ :parent |
		self extractProgramEntityNestedNameComponents: parent into: out
	].

	programEntity isTemplateInstance ifTrue: [
		| instanceArguments |
		programEntity isSystemProvidedTypeTemplateInstance ifTrue: [ 
			instanceArguments := programEntity instanceArguments asArray.
			out nextPut: instanceArguments.
		] ifFalse: [ 
			instanceArguments := programEntity instanceArguments collect: [ :arg | arg evaluatedValue ].
			programEntity parent module == programEntity module ifTrue: [ 
				out nextPut: instanceArguments.
			] ifFalse: [ 
				out nextPut: {programEntity module . instanceArguments}.
			].
		].
		^ self
	].

	validName := programEntity name.
	validName isMbndAnonymousSymbol ifTrue: [
		(programEntity parent isNotNil and: [programEntity parent isTemplateInstance]) ifTrue: [ ^ self ].
		validName := self generatedNameForAnynomousEntity: programEntity
	].
	
	validName ifNotEmpty: [
		programEntity isMessageMethod ifTrue: [ validName := ':' , validName ].
		out nextPut: validName
	].
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> generateSubstitutionName [
	| result |
	substitutionNameCount ifNil: [
		substitutionNameCount := 0.
		^ 'S_'
	].
	result := 'S', (substitutionNameCount printStringBase: 36) , '_'.
	substitutionNameCount := substitutionNameCount + 1.
	^ result
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> generatedNameForAnynomousEntity: anonEntity [
	^ codeModuleGenerator generatedNameForAnynomousEntity: anonEntity
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> initialize [
	super initialize.
	ommitModuleName := false.
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> mangleNestedNameComponents: components [
	^ self mangleNestedNameComponents: components prefix: #_Z
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> mangleNestedNameComponents: components prefix: prefix [
	^ (ByteString streamContents: [ :outStream |
		output := outStream.
		substitutionDictionary := Dictionary new.
		output nextPutAll: prefix.
		
		self mangleProgramEntityNestedNameComponents: components
	]) asSymbol
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> mangleProgramEntityCommonInfo: programEntity [
	ommitModuleName := true.
	^ self mangleProgramEntityInfo: programEntity
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> mangleProgramEntityContentName: programEntity [
	self builtInManglingTable at: programEntity ifPresent: [ :shortName |
		output nextPutAll: shortName.
		^ self.
	].
	self mangleProgramEntityQualifiedContentName: programEntity
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> mangleProgramEntityInfo: programEntity [
	programEntity isMbndType ifTrue: [ ^ self mangleTypeInfo: programEntity ].
	^ self mangleProgramEntityName: programEntity suffixes: #('..info..')
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> mangleProgramEntityName: programEntity [
	^ self mangleProgramEntityName: programEntity prefix: '_Z'
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> mangleProgramEntityName: programEntity descriptorSet: set descriptorBinding: binding [
	^ self mangleProgramEntityName: programEntity suffixes:  { 'set' , set asString , '_binding', binding asString }.
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> mangleProgramEntityName: programEntity prefix: prefix [
	^ (ByteString streamContents: [ :outStream |
		output := outStream.
		substitutionDictionary := Dictionary new.
		output nextPutAll: prefix.
		
		self mangleProgramEntityQualifiedContentName: programEntity
	]) asSymbol
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> mangleProgramEntityName: programEntity suffixes: suffixes [
	nestedNamedComponentsSuffixes := suffixes.
	^ self mangleProgramEntityName: programEntity
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> mangleProgramEntityNestedName: programEntity [
	self mangleProgramEntityNestedNameComponents: (self extractProgramEntityNestedNameComponents: programEntity)
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> mangleProgramEntityNestedNameComponents: components [
	| escapedComponents currentPrefix bestSubstitution hasAppliedSubstitution |
	output nextPut: $N.
	escapedComponents := components collect: [ :comp |
		comp isArray ifTrue: [ comp ] ifFalse: [ self escapeNameForMangling: comp ].
	].

	currentPrefix := #().
	hasAppliedSubstitution := false.

	escapedComponents do: [ :comp |
		currentPrefix := currentPrefix , {comp}.
		hasAppliedSubstitution ifFalse: [ 
			substitutionDictionary at: currentPrefix ifPresent: [ :substitution |
				bestSubstitution := substitution
			] ifAbsent: [
				bestSubstitution ifNotNil: [
					output nextPutAll: bestSubstitution
				].

				hasAppliedSubstitution := true.
			].
		].
		hasAppliedSubstitution ifTrue: [ 
			self recordSubstitutionElement: currentPrefix.
		].
	
		hasAppliedSubstitution ifTrue: [ 
			comp isArray ifTrue: [
				self emitTemplateInstanceArguments: comp
			] ifFalse: [
				self emitSizedName: comp
			].
		].
	].

	hasAppliedSubstitution ifFalse: [
		bestSubstitution ifNotNil: [
			output nextPutAll: bestSubstitution
		]
	].

	output nextPut: $E.
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> mangleProgramEntityQualifiedContentName: programEntity [
	programEntity accept: self.

]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> mangleType: type [
	type isGarbageCollectedType ifTrue: [ output nextPut: $P ].
	self mangleProgramEntityContentName: type.
	type isGarbageCollectedType ifTrue: [ self recordNewSubstitutionElement: { #pointer . type } ].

]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> mangleTypeInfo: programEntity [
	^ self mangleProgramEntityName: programEntity prefix: '_ZTI'
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> recordNewSubstitutionElement: prefix [
	substitutionDictionary at: prefix ifAbsent: [ self recordSubstitutionElement: prefix ]
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> recordSubstitutionElement: prefix [
	| subtitutionPattern |
	subtitutionPattern := self generateSubstitutionName.
	substitutionDictionary at: prefix ifAbsentPut: [subtitutionPattern]
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitAggregateBasicInitializeMethod: method [
	^ self visitGenericFunction: method
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitAggregateCopyAssignmentMethod: method [
	^ self visitGenericFunction: method
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitAggregateFinalizeMethod: method [
	^ self visitGenericFunction: method
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitAggregateInitializeFromCopyMethod: method [
	^ self visitGenericFunction: method
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitAggregateInitializeMethod: method [
	^ self visitGenericFunction: method
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitAggregateInitializeMovingFromMethod: method [
	^ self visitGenericFunction: method
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitAggregateMoveAssignmentMethod: method [
	^ self visitGenericFunction: method
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitArraySliceType: type [
	self emitSubstitutionElement: #ArraySlice.
	output nextPut: $I.
	self mangleType: type elementType.
	output nextPut: $E.	

]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitArrayType: type [
	output nextPut: $A; print: type elements; nextPut: $_.
	self mangleType: type elementType.
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitAssociationType: type [
	self emitSubstitutionElement: #Association.
	output nextPut: $I.
	self mangleType: type keyType.
	self mangleType: type valueType.
	output nextPut: $E.	

]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitBlockClosureMethod: method [
	^ self visitGenericFunction: method
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitClassType: type [
	^ self visitGenericType: type
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitCompilerObjectType: type [
	output nextPut: $u.
	self emitSubstitutionElement: type name
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitConcreteFunctionMethod: method [
	^ self visitGenericFunction: method
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitConcreteMessageMethod: method [
	^ self visitGenericFunction: method
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitCoreBasicType: basicType [
	^ self mangleProgramEntityContentName: basicType
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitDecoratedType: type [
	| currentType |
	type decorations do: [ :decoration |
		DecorationPrefixMap at: decoration ifPresent: [ :prefix |
			output nextPutAll: prefix
		]
	].

	self mangleType: type baseType.
	currentType := type baseType.
	type decorations reverseDo: [ :decoration |
		(DecorationPrefixMap includesKey: decoration) ifTrue: [ 
			self recordNewSubstitutionElement: { #decoration . currentType }.
			currentType := currentType withDecoration: decoration
		]
	].


]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitDynamicMethodWrapper: method [
	^ self visitGenericFunction: method
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitEnumType: type [
	^ self visitGenericType: type
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitFieldVariable: globalVariable [
	self mangleProgramEntityNestedName: globalVariable
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitFunctionType: type [
	output nextPut: $F.
	type argumentTypes do: [ :arg |
		self mangleType: arg
	].
	(type argumentTypes isEmpty and: [type isCVariadic not]) ifTrue: [ 
		output nextPut: $v
	].

	type isCVariadic ifTrue: [ output nextPut: $z ].
	self mangleType: type returnType.
	output nextPut: $E

]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitGCBlockClosureType: type [
	self emitSubstitutionElement: #gcBlockClosure.
	output nextPut: $I.
	self mangleType: type functionType.
	output nextPut: $E.
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitGCClassType: type [
	^ self visitGenericType: type
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitGenericFunction: function [
	| functionType |
	self mangleProgramEntityNestedName: function.
	functionType := function type.
	functionType isBlockClosureType ifTrue: [ functionType := functionType functionType ].
	functionType argumentTypes do: [ :argumentType |
		self mangleType: (argumentType asConcreteTypeForAnalysisOfFunctionType: functionType)
	].

	function shouldMangleReturnType ifTrue: [ 
		self mangleType: (functionType returnType asConcreteTypeForAnalysisOfFunctionType: functionType)
	].

	functionType isCVariadic ifTrue: [ output nextPut: $z ]
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitGenericType: type [
	^ self mangleProgramEntityNestedName: type
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitGlobalVariable: globalVariable [
	self mangleProgramEntityNestedName: globalVariable
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitInputChannelType: type [
	self emitSubstitutionElement: #inputChannel.
	output nextPut: $I.
	self mangleType: type messageType.
	output nextPut: $E.
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitModule: module [
	self mangleProgramEntityNestedName: module
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitNamespace: namespace [
	self mangleProgramEntityNestedName: namespace
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitNativeBlockClosureType: type [
	self emitSubstitutionElement: #nativeBlockClosure.
	output nextPut: $I.
	self mangleType: type functionType.
	output nextPut: $E
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitOutputChannelType: type [
	self emitSubstitutionElement: #outputChannel.
	output nextPut: $I.
	self mangleType: type messageType.
	output nextPut: $E.
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitPointerType: type [
	output nextPut: $P.
	self mangleType: type baseType.
	self recordNewSubstitutionElement: { #pointer . type baseType }.
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitPredicatedTypeConcept: type [
	^ self visitGenericType: type
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitPrimitiveBooleanType: type [
	^ self visitCoreBasicType: type
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitPrimitiveCharacterCodeType: type [
	^ self visitCoreBasicType: type
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitPrimitiveFloatType: type [
	^ self visitCoreBasicType: type
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitPrimitiveIntegerType: type [
	^ self visitCoreBasicType: type
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitPrimitiveMatrixType: type [
	output nextPut: $u.
	self emitSubstitutionElement: type name
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitPrimitiveVectorType: type [
	output nextPut: $u.
	self emitSubstitutionElement: type name
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitReferenceType: type [
	output nextPut: $R.
	self mangleType: type baseType.
	self recordNewSubstitutionElement: { #reference . type baseType }.
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitSamplerType: type [
	output nextPut: $u.
	self emitSubstitutionElement: type name
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitSimpleMetaType: type [
	^ self visitGenericType: type
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitStructureType: type [
	^ self visitGenericType: type
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitTemporaryReferenceType: type [
	output nextPut: $O.
	self mangleType: type baseType.
	self recordNewSubstitutionElement: { #temporaryReference . type baseType }.
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitTextureType: type [
	output nextPut: $u.
	self emitSubstitutionElement: type name
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitTupleType: type [
	self emitSubstitutionElement: #Tuple.
	output nextPut: $I.
	type elements do: [ :each |
		self mangleType: each.
	].
	output nextPut: $E.	

]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitUnionType: type [
	^ self visitGenericType: type
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitVTablePointerFieldVariable: fieldVariable [
	output nextPutAll: 'TV'.
	self mangleProgramEntityContentName: fieldVariable parent.
	fieldVariable slotIndex > 0 ifTrue: [ 
		output print: fieldVariable slotIndex
	]
]

{ #category : #visiting }
MbndSlovimSymbolNameMangler >> visitVariantUnionType: type [
	self emitSubstitutionElement: #Variant.
	output nextPut: $I.
	type components do: [ :each |
		self mangleType: each.
	].
	output nextPut: $E.	

]
