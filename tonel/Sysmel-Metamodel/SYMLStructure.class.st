Class {
	#name : #SYMLStructure,
	#superclass : #SYMLAbstractType,
	#instVars : [
		'fields',
		'hasConcretedSSAType',
		'analyzed'
	],
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #adding }
SYMLStructure >> addFieldVariable: field at: aPosition [
	symbols at: field name ifPresent: [ :existent |
		self error: 'Field {1} overrides an existent field.' format: { field name } at: aPosition
	] ifAbsentPut: [ field ].
	fields add: field
]

{ #category : #'semantic analysis' }
SYMLStructure >> buildLayout [
	fields doWithIndex: [ :field :index|
		field slotIndex: index - 1
	]
]

{ #category : #'code generation' }
SYMLStructure >> buildSSAType [
	^ SLVMStructureType new name: self mangledName; kind: SLVMStructureType genericKind.
]

{ #category : #definition }
SYMLStructure >> definitionScopeClass [
	^ SYMLStructureScope
]

{ #category : #'semantic analysis' }
SYMLStructure >> ensureConcreteSSAType [
	hasConcretedSSAType ifTrue: [ ^ self ].
	hasConcretedSSAType := true.
	self module ssaModule addStructure: self ssaType.
	self ssaType
		names: (fields collect: [ :field | field name ]);
		types: (fields collect: [ :field | field type ssaType ]).

]

{ #category : #accessing }
SYMLStructure >> fields [
	^ fields
]

{ #category : #'semantic analysis' }
SYMLStructure >> generateSSACode [
	self ensureConcreteSSAType.
	children do: #generateSSACode
]

{ #category : #'code generation' }
SYMLStructure >> generateSSAValue: value withBuilder: aBuilder [
	^ value generateSSAReferenceWith: aBuilder
]

{ #category : #initialization }
SYMLStructure >> initialize [
	super initialize.
	fields := OrderedCollection new.
	hasConcretedSSAType := false.
	analyzed := false.
]

{ #category : #initialization }
SYMLStructure >> initializeSSAVariable: ssaVariable builder: builder [
	fields do: [ :field |
		field initializeSSAVariable: ssaVariable builder: builder
	]
]

{ #category : #'symbol lookup' }
SYMLStructure >> lookReceiver: receiver symbol: symbol ifPresent: ifPresentBlock [
	<compileTime>
	symbols at: symbol ifPresent: [ :binding |
		binding isFieldVariable ifTrue: [
			^ ifPresentBlock value: (binding bindingForReceiver: receiver symbol: symbol)
		].
	].
	^ super lookReceiver: receiver symbol: symbol ifPresent: ifPresentBlock
]

{ #category : #'as yet unclassified' }
SYMLStructure >> makeInstance [
	self semanticAnalysis.
	^ SYMLStructureInstance new type: self;
		slots: (fields collect: [:field | field defaultValue unwrapSysmelValue ]);
		yourself
]

{ #category : #'semantic analysis' }
SYMLStructure >> mangledName [
	| escapedName |
	^ ByteString streamContents: [ :out |
		escapedName := self validName sysmelEscapeForMangling.
		out
			nextPutAll: self parentMangledName;
			nextPut: $S;
			print: escapedName size;
			nextPutAll: escapedName.
	]
]

{ #category : #printing }
SYMLStructure >> printOn: aStream [
	aStream nextPutAll: 'structure '; nextPutAll: self printingName
]

{ #category : #'semantic analysis' }
SYMLStructure >> semanticAnalysis [
	analyzed ifTrue: [ ^ self ].
	analyzed := true.
	
	self buildLayout.
	children do: #semanticAnalysis
]

{ #category : #'as yet unclassified' }
SYMLStructure >> typeKindBaseTrait [
	^ self compilationTarget structureTypeTrait
]
