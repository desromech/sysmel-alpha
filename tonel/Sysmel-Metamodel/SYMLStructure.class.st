Class {
	#name : #SYMLStructure,
	#superclass : #SYMLProgramEntity,
	#traits : 'TSYMLType',
	#classTraits : 'TSYMLType classTrait',
	#instVars : [
		'name',
		'module',
		'symbols',
		'fields',
		'virtualMethods',
		'ssaType',
		'isSSATypeConcretized',
		'definition'
	],
	#category : #Sysmel-Metamodel-Program
}

{ #category : #adding }
SYMLStructure >> addField: aField [
	fields add: aField.
	^ aField
]

{ #category : #adding }
SYMLStructure >> addedFunction: aFunction [
	aFunction parent: self.
	(aFunction isMethod and: [ aFunction isVirtual]) ifTrue: [ 
		virtualMethods add: aFunction.
	].

]

{ #category : #'meta methods' }
SYMLStructure >> assignValue: aDefinition [
	<compileTime>
	
	| scope |
	aDefinition type isAPSGNode ifFalse: [
		name ifNotNil: [ 
			self error: 'Expected an APSG/AST node for definition of structure {1}.' format: {name}
		] ifNil: [
			self error: 'Expected an APSG/AST node for definition of structure.'
		]
	].

	scope := (SYMLStructureScope parent: aDefinition environment)
		structure: self;
		yourself.
	definition := aDefinition value.
	definition analyzeAndEvaluateInEnvironment: scope.
	^ self asSysmelValueInEnvironment: aDefinition environment
]

{ #category : #private }
SYMLStructure >> buildPartialSSAType [
	^ SLVMStructureType new name: self mangledName; kind: SLVMStructureType genericKind.
]

{ #category : #accessing }
SYMLStructure >> concreteSSAType [
	self ensureConcreteSSAType.
	^ ssaType
]

{ #category : #'object building' }
SYMLStructure >> createFieldVariableBinding: fieldBuilder [
	^self addField: (SYMLStructureField new
		name: fieldBuilder name;
		valueType: fieldBuilder type;
		structure: self;
		yourself)
]

{ #category : #private }
SYMLStructure >> ensureConcreteSSAType [
	isSSATypeConcretized == #black ifTrue: [ ^ self ].
	isSSATypeConcretized == #gray ifTrue: [
		self error: 'Circular definition of aggregate {1} found.' format: { self name } at: definition
	].
	
	self assert: isSSATypeConcretized == #white.
	isSSATypeConcretized := #gray.
	
	self ssaType
		names: (fields collect: [ :field | field name ]);
		types: (fields collect: [ :field | field valueType concreteSSAType ]).
	isSSATypeConcretized := #black
]

{ #category : #'semantic analysis' }
SYMLStructure >> generateSSACode [
	self ensureConcreteSSAType.
	symbols valuesDo: #generateSSACode
]

{ #category : #initialization }
SYMLStructure >> initialize [
	super initialize.
	symbols := SYMLOrderedDictionary new.
	fields := OrderedCollection new.
	virtualMethods := OrderedCollection new.
	isSSATypeConcretized := #white.
]

{ #category : #'symbol lookup' }
SYMLStructure >> lookSymbol: identifier [
	^ symbols at: identifier
]

{ #category : #variables }
SYMLStructure >> lookSymbol: identifier ifPresent: aBlock [
	^ symbols at: identifier ifPresent: aBlock
]

{ #category : #variables }
SYMLStructure >> lookSymbol: identifier ifPresent: ifPresentBlock ifAbsentPut: ifAbsentBlock [
	^ symbols at: identifier ifPresent: ifPresentBlock ifAbsentPut: ifAbsentBlock
]

{ #category : #accessing }
SYMLStructure >> mangledName [
	^ ByteString streamContents: [ :out |
		out
			nextPutAll: self parentMangledName;
			nextPut: $S;
			print: name size;
			nextPutAll: name.
	]
]

{ #category : #accessing }
SYMLStructure >> module [
	^ module
]

{ #category : #accessing }
SYMLStructure >> module: anObject [
	module := anObject
]

{ #category : #accessing }
SYMLStructure >> name [
	^ name
]

{ #category : #accessing }
SYMLStructure >> name: anObject [
	name := anObject
]

{ #category : #printing }
SYMLStructure >> printOn: aStream [
	aStream nextPutAll: name
]

{ #category : #'semantic analysis' }
SYMLStructure >> semanticAnalysis [
	symbols valuesDo: #semanticAnalysis
]

{ #category : #accessing }
SYMLStructure >> ssaType [
	ssaType ifNil: [ ssaType := self buildPartialSSAType ].
	^ ssaType
]

{ #category : #accessing }
SYMLStructure >> target [
	^ module compilationTarget
]
