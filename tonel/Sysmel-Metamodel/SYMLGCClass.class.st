Class {
	#name : #SYMLGCClass,
	#superclass : #SYMLClass,
	#instVars : [
		'instanceType'
	],
	#classVars : [
		'MetaclassInstanceSlotMap'
	],
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #initialization }
SYMLGCClass class >> initialize [
	super initialize.
	MetaclassInstanceSlotMap := Dictionary newFromPairs: #(
		__class type
		superclass superclass
	)
]

{ #category : #conversions }
SYMLGCClass >> addDefaultConversionRules [
	self
		addConversionRule: (SYMLIdentityTypeConversionRule when: [:source :target |
			(source isMetaType or: [ source isMetaTypeClass ]) and: [ target == self compilationTarget compilerObjectType ]
		]);
		addExplicitConversionRule: (SYMLReinterpretPointerTypeConversionRule when: [:source :target |
			source isSysmelGCClass and: [target isSysmelGCClass ]]);
		addConversionRule: (SYMLReinterpretPointerTypeConversionRule when: [:source :target |
			source isSysmelGCClass and: [target isSysmelGCClass and: [ source isSubclassOf: target] ]]);
		addConversionRule: (SYMLIdentityTypeConversionRule when: [:source :target |
			source isSysmelKindOf: target])
]

{ #category : #'code generation' }
SYMLGCClass >> buildSSAType [
	^ self compilationTarget ssaPointerTo: self structureSSAType forAddressSpace: #gc
]

{ #category : #'as yet unclassified' }
SYMLGCClass >> createMetaTypeFor: newInstanceType basingOf: oldMetaType [
	| newMetaType |
	newMetaType := SYMLGCClass new
			module: module;
			parent: newInstanceType;
			definitionEnvironment: definitionEnvironment;
			instanceType: newInstanceType;
			metaClassClass: newInstanceType metaClassClass;
			metaType: self;
			superclass: (self superclass ifNotNil: [:st | st type]);
			yourself.
			
	oldMetaType ifNotNil: [
		newMetaType addTraits: oldMetaType usedTraits
	].
	
	^ newMetaType
]

{ #category : #'as yet unclassified' }
SYMLGCClass >> createTypeInstanceSlotsFor: typeInstance [
	^ self allFields collect: [ :field |
		MetaclassInstanceSlotMap at: field name ifPresent: [ :selector |
			typeInstance perform: selector
		] ifAbsent: [ field defaultValue unwrapSysmelValue ]
	]
]

{ #category : #defaults }
SYMLGCClass >> defaultValue [
	^ nil sysmelValueWithType: self inEnvironment: definitionEnvironment
]

{ #category : #'code generation' }
SYMLGCClass >> generateSSAConstant: value [
	value ifNil: [ ^ SLVMConstant type: self ssaType value: 0   ].
	^ value generateSSAValue
]

{ #category : #'code generation' }
SYMLGCClass >> generateSSAConstant: value forModule: aModule [
	| ssaValue |
	value ifNil: [ ^ SLVMConstant type: self ssaType value: 0 ].
	ssaValue := value generateSSAValueForModule: aModule.
	^ value type == self
		ifTrue: [ ssaValue ]
		ifFalse: [ SLVMConstant value: ssaValue bitcast: self ssaType ]
	
]

{ #category : #'code generation' }
SYMLGCClass >> generateSSATypeInfoForInstance: anInstanceType [
	| variable instanceSlots ssaSlots |
	self module hasNoRuntimeTypeInformation ifTrue: [ ^ SLVMConstant type: self ssaType value: 0 ].
	
	variable := SLVMGlobalVariable module: self module ssaModule
		name: (anInstanceType mangledName , '_typeinfo' asSymbol)
		valueType: self structureSSAType
		storage: SLVMType genericStorage.
	variable makePublic.
	"Store the variable to prevent an infinite loop."
	anInstanceType ssaTypeInfo: variable.
	
	instanceSlots := anInstanceType slots.
	ssaSlots := self allFields collectWithIndex: [ :field :index |
		field type generateSSAConstant: (instanceSlots at: index) forModule: self module
	].

	variable initialValue: (SLVMConstantStructureValue new
		type: self structureSSAType;
		slots: ssaSlots;
		yourself).
	
	^ variable
]

{ #category : #'code generation' }
SYMLGCClass >> generateSSAValue: value withBuilder: aBuilder [
	value ifNil: [ ^ SLVMConstant type: self type ssaType value: 0 ].
	^ value generateSSAReferenceWith: aBuilder
]

{ #category : #accessing }
SYMLGCClass >> instanceType [
	^ instanceType
]

{ #category : #accessing }
SYMLGCClass >> instanceType: anObject [
	instanceType := anObject
]

{ #category : #testing }
SYMLGCClass >> isMetaType [
	^ instanceType isNotNil
]

{ #category : #testing }
SYMLGCClass >> isMetaTypeClass [
	^ self == metaClassClass 
]

{ #category : #testing }
SYMLGCClass >> isSysmelGCClass [
	^ true
]

{ #category : #accessing }
SYMLGCClass >> mangledName [
	| escapedName |
	^ ByteString streamContents: [ :out |
		self isMetaType ifTrue: [ 
			out
				nextPutAll: self parentMangledName;
				nextPutAll: '_meta'

		] ifFalse: [ 
			escapedName := self validName sysmelEscapeForMangling.
			out
				nextPutAll: self parentMangledName;
				nextPut: (self isMetaType ifTrue: [$M] ifFalse: [$G]);
				print: escapedName size;
				nextPutAll: escapedName.
		]
	]
]

{ #category : #accessing }
SYMLGCClass >> metaType: aType [
	metaType := aType
]

{ #category : #printing }
SYMLGCClass >> printOn: aStream [
	self isMetaType ifTrue: [ 
		instanceType printOn: aStream.
		aStream nextPutAll: ' class'.
	] ifFalse: [ 
		aStream nextPutAll: 'gcclass '; nextPutAll: self printingName
	]
	
]

{ #category : #'as yet unclassified' }
SYMLGCClass >> typeKindBaseTrait [
	^ self compilationTarget managedClassTypeTrait
]
