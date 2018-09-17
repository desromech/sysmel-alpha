Class {
	#name : #SYMLGCClass,
	#superclass : #SYMLAbstractClass,
	#instVars : [
		'instanceType',
		'instanceDataSize',
		'instanceDataAlignment',
		'variableInstanceElementSize',
		'variableInstanceElementAlignment',
		'hasComputeInstanceSizes',
		'specificVariableDataTypes',
		'variableDataSizeField'
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
		__identityHash identityHash
		superclass superclass
		
		methodDict methodDictionaryReflectionProxy
		
		instanceDataSize instanceDataSize
		instanceDataAlignment instanceDataAlignment
		
		variableInstanceElementSize variableInstanceElementSize
		variableInstanceElementAlignment variableInstanceElementAlignment
	)
]

{ #category : #conversions }
SYMLGCClass >> addDefaultConversionRules [
	super addDefaultConversionRules.
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

{ #category : #initialization }
SYMLGCClass >> computeInstanceSizes [
	| slotType slotSize slotAlignment |
	hasComputeInstanceSizes ifTrue: [ ^ self ].

	instanceDataSize := 0.
	instanceDataAlignment := 1.
	variableInstanceElementSize := 0.
	variableInstanceElementAlignment := 1.
	
	self slotsLayout doWithIndex: [ :slot :slotIndex |
		slotType := slot type.
		slotSize := slotType instanceSize.
		slotAlignment := slotType instanceAlignment.

		"Apply the field alignment."
		instanceDataAlignment := instanceDataAlignment max: slotAlignment.
		instanceDataSize := instanceDataSize alignedTo: slotAlignment.
		self assert: (slot offset isNil or: [ slot offset = instanceDataSize]).
		slot offset: instanceDataSize.

		"Apply the field size."		
		instanceDataSize := instanceDataSize + slotType instanceSize.
		slotType isGCClassVariableDataArrayType ifTrue: [ 
			slotIndex ~= self slotsLayout size ifTrue: [
				self error: 'Field with variable has to be the last field.'
			].
		
			variableInstanceElementSize := slotSize.
			variableInstanceElementAlignment := slotAlignment.
		].
	].
	
	hasComputeInstanceSizes := true.
]

{ #category : #accessing }
SYMLGCClass >> concreteSSAType [
	<compileTime>
	^ self ssaType
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
	| result |
	result := self slotsLayout collect: [ :slot | slot defaultValue unwrapSysmelValue ].
	
	self allFields do: [ :field |
		MetaclassInstanceSlotMap at: field name ifPresent: [ :selector |
			field setSlots: result value: (typeInstance perform: selector)
		]
	].

	^ result
]

{ #category : #'code generation' }
SYMLGCClass >> defaultSSAValueWith: builder [
	^ builder const: 0 type: self ssaType
]

{ #category : #defaults }
SYMLGCClass >> defaultValue [
	^ nil sysmelValueWithType: self inEnvironment: definitionEnvironment
]

{ #category : #accessing }
SYMLGCClass >> fieldMetaobjectClass [
	^ SYMLGCClassFieldVariable
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
	ssaSlots := self slotsLayout collectWithIndex: [ :slot :index |
		slot type generateSSAConstant: (instanceSlots at: index) forModule: self module
	].

	variable initialValue: (SLVMConstant structure: self structureSSAType slots: ssaSlots).
	
	^ variable
]

{ #category : #'code generation' }
SYMLGCClass >> generateSSAValue: value withBuilder: aBuilder [
	value ifNil: [ ^ SLVMConstant type: self type ssaType value: 0 ].
	^ value generateSSAReferenceWith: aBuilder
]

{ #category : #testing }
SYMLGCClass >> hasDynamicMessageSends [
	^ true
]

{ #category : #testing }
SYMLGCClass >> hasVariableDataArray [
	^ self slotsLayout isNotEmpty and: [ self slotsLayout last type isGCClassVariableDataArrayType ]
]

{ #category : #initialization }
SYMLGCClass >> initialize [
	super initialize.
	hasComputeInstanceSizes := false.
	specificVariableDataTypes := Dictionary new.
]

{ #category : #accessing }
SYMLGCClass >> instanceAlignment [
	^ self compilationTarget pointerAlignment
]

{ #category : #accessing }
SYMLGCClass >> instanceDataAlignment [
	self computeInstanceSizes.
	^ instanceDataAlignment
]

{ #category : #accessing }
SYMLGCClass >> instanceDataSize [
	self computeInstanceSizes.
	^ instanceDataSize
]

{ #category : #accessing }
SYMLGCClass >> instanceSize [
	^ self compilationTarget pointerSize
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

{ #category : #'as yet unclassified' }
SYMLGCClass >> makeInstance [
	^ self makeInstance: 0
]

{ #category : #'as yet unclassified' }
SYMLGCClass >> makeInstance: variableDataSize [
	| elementType result |
	self semanticAnalysis.
	result := SYMLGCClassInstance new type: self;
		slots: (self slotsLayout collect: [:slot |
			slot type isGCClassVariableDataArrayType ifTrue: [ 
				elementType := slot type elementType.
				(elementType instanceSize = 1
					ifTrue: [ ByteArray new: variableDataSize ]
					ifFalse: [ Array new: variableDataSize ])
					atAllPut: elementType defaultValue unwrapSysmelValue;
					yourself
			] ifFalse: [ 
				slot defaultValue unwrapSysmelValue
			]
		]);
		yourself.
		
	self flag: 'TODO: Set all of the required vtables'.
	^ result
		setSlot: 0 value: self;
		setSlot: 	self variableDataSizeField slotIndex value: variableDataSize;
		yourself

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
SYMLGCClass >> structureSSATypeForVariableDataSize: variableDataSize [
	| genericType types names variableDataType variableDataElementType arrayType |
	(self hasVariableDataArray not or: [variableDataSize = 0]) ifTrue: [ ^ self structureSSAType ].
	^ specificVariableDataTypes at: variableDataSize ifAbsentPut: [
		self ensureConcreteStructureSSAType.
		genericType := self structureSSAType.
	
		variableDataType := self slotsLayout last type.
		self assert: variableDataType isGCClassVariableDataArrayType.
	
		variableDataElementType := variableDataType elementType ssaType.
		arrayType := SLVMArrayType baseType: variableDataElementType elements: variableDataSize.
	
		types := genericType types allButLast , {arrayType}.
		names := genericType names.
		SLVMStructureType name: nil types: types kind: genericType kind names: names.
	]
]

{ #category : #'as yet unclassified' }
SYMLGCClass >> typeKindBaseTrait [
	^ self compilationTarget managedClassTypeTrait
]

{ #category : #accessing }
SYMLGCClass >> variableDataSizeField [
	^ variableDataSizeField ifNil: [variableDataSizeField := symbols at: #__variableDataSize ifAbsent: [ superclass variableDataSizeField ] ]
]

{ #category : #accessing }
SYMLGCClass >> variableInstanceElementAlignment [
	self computeInstanceSizes.
	^ variableInstanceElementAlignment
]

{ #category : #accessing }
SYMLGCClass >> variableInstanceElementSize [
	self computeInstanceSizes.
	^ variableInstanceElementSize
]
