Class {
	#name : #MbndSlovimProgramEntityTypeNameMangler,
	#superclass : #MbndAbstractModuleVisitor,
	#traits : 'TMbndSlovimModulePartTranslator',
	#classTraits : 'TMbndSlovimModulePartTranslator classTrait',
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #visiting }
MbndSlovimProgramEntityTypeNameMangler >> emitMangledType: type [
	^ codeModuleGenerator typeNameMangler visitNode: type
]

{ #category : #visiting }
MbndSlovimProgramEntityTypeNameMangler >> emitTemplateArgumentValue: argumentValue [
	argumentValue isMbndType ifTrue: [
		^ self emitMangledType: argumentValue
	].

	argumentValue isMbndProgramEntity ifTrue: [
		^ self codeModuleGenerator mangleProgramEntityName: argumentValue
	].

	^ 'V' , (self codeModuleGenerator escapeNameForMangling: argumentValue asString).
]

{ #category : #visiting }
MbndSlovimProgramEntityTypeNameMangler >> visitAggregateBasicInitializeMethod: node [
	^ self emitMangledType: node type
]

{ #category : #visiting }
MbndSlovimProgramEntityTypeNameMangler >> visitAggregateType: node [
	^ ''
]

{ #category : #visiting }
MbndSlovimProgramEntityTypeNameMangler >> visitClassType: node [
	^ self visitAggregateType: node
]

{ #category : #visiting }
MbndSlovimProgramEntityTypeNameMangler >> visitConcreteFunctionMethod: node [
	^ self emitMangledType: node type
]

{ #category : #visiting }
MbndSlovimProgramEntityTypeNameMangler >> visitConcreteMessageMethod: node [
	^ self emitMangledType: node type
]

{ #category : #visiting }
MbndSlovimProgramEntityTypeNameMangler >> visitEnumType: node [
	^ ''
]

{ #category : #visiting }
MbndSlovimProgramEntityTypeNameMangler >> visitFieldVariable: node [
	^ (self emitMangledType: node valueType)
]

{ #category : #visiting }
MbndSlovimProgramEntityTypeNameMangler >> visitGCClassType: node [
	^ self visitAggregateType: node
]

{ #category : #visiting }
MbndSlovimProgramEntityTypeNameMangler >> visitGlobalVariable: node [
	^ (self emitMangledType: node valueType)
]

{ #category : #visiting }
MbndSlovimProgramEntityTypeNameMangler >> visitNamespace: node [
	^ ''
]

{ #category : #visiting }
MbndSlovimProgramEntityTypeNameMangler >> visitNode: node [
	^ node accept: self
]

{ #category : #visiting }
MbndSlovimProgramEntityTypeNameMangler >> visitStructureType: node [
	^ self visitAggregateType: node
]

{ #category : #visiting }
MbndSlovimProgramEntityTypeNameMangler >> visitTemplate: node [
	^ ''
]

{ #category : #visiting }
MbndSlovimProgramEntityTypeNameMangler >> visitTemplateInstance: node [
	^ ByteString streamContents: [ :out |
		out nextPutAll: 'TI'; print: node instanceArguments size.
		node instanceArguments do: [ :arg |
			| argumentValue mangledArgument |
			argumentValue := arg evaluatedValue unwrapMbndValue.
			mangledArgument := self emitTemplateArgumentValue: argumentValue.
			out nextPut: $_; print: mangledArgument size.
			mangledArgument first isDigit ifTrue: [ 
				out nextPut: $_
			].
			out nextPutAll: mangledArgument
		]
	]
]

{ #category : #visiting }
MbndSlovimProgramEntityTypeNameMangler >> visitTextureType: node [
	^ self visitAggregateType: node
]

{ #category : #visiting }
MbndSlovimProgramEntityTypeNameMangler >> visitUnionType: node [
	^ self visitAggregateType: node
]

{ #category : #visiting }
MbndSlovimProgramEntityTypeNameMangler >> visitVTablePointerFieldVariable: vtableFieldVariable [
	 ^ (self emitMangledType: vtableFieldVariable parent) , 'VT' , vtableFieldVariable slotIndex asString
]
