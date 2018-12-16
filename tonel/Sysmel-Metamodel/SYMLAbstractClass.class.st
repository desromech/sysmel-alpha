Class {
	#name : #SYMLAbstractClass,
	#superclass : #SYMLStructure,
	#instVars : [
		'superclass',
		'class',
		'virtualMethods',
		'allFieldsLayout',
		'virtualTables',
		'overridenMethods'
	],
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #'virtual table' }
SYMLAbstractClass >> addMainVTableFieldNamed: vtableFieldName [
	<compileTime>
	"This is a special method used by proto-object."
	| field |
	field := SYMLVTablePointerFieldVariable new 
		name: vtableFieldName;
		module: self module;
		definitionEnvironment: definitionEnvironment;
		definitionNode: self definitionNode;
		parent: self;
		originalClassDefinition: self;
		classDefinition: self;
		yourself.
	symbols at: field name ifPresent: [ :existent |
		self error: 'VTable field {1} overrides an existent field.' format: { field name } at: self definitionNode
	] ifAbsentPut: [ field ].

	fields add: field.
	^ field
]

{ #category : #'virtual table' }
SYMLAbstractClass >> addVirtualTableEntry: anAbstractFunction [
	virtualMethods add: anAbstractFunction
]

{ #category : #'semantic analysis' }
SYMLAbstractClass >> allFields [
	^ allFieldsLayout ifNil: [ allFieldsLayout := self buildAllFieldsLayout ]
]

{ #category : #'semantic analysis' }
SYMLAbstractClass >> buildAllFieldsLayout [
	| layout |
	layout := (superclass ifNil: [ #() ] ifNotNil: [ superclass allFields collect: #copy]) , fields.
	layout do: [ :field | field parent: self ].
	
	(self isSysmelGCClass or: [virtualMethods isNotEmpty]) ifTrue: [ 
		(layout isEmpty or: [ layout first isVTablePointerField not]) ifTrue: [ 
			layout := {SYMLVTablePointerFieldVariable new 
				module: self module;
				definitionEnvironment: definitionEnvironment;
				definitionNode: self definitionNode;
				parent: self;
				originalClassDefinition: self;
				classDefinition: self;
				yourself} , layout
		] ifFalse: [ 
			self assert: layout first isVTablePointerField.
			layout first classDefinition: self
		]
	].

	^ layout
]

{ #category : #'semantic analysis' }
SYMLAbstractClass >> buildConcreteStructureSSAType [
	superclass ifNotNil: [ superclass ensureConcreteStructureSSAType ].
	^ super buildConcreteStructureSSAType
]

{ #category : #'semantic analysis' }
SYMLAbstractClass >> buildLayout [
	self supertype ifNotNil: [ :st | st semanticAnalysis ].
	
	self findOverridenMethods.
	super buildLayout.
	virtualTables := self allFields select: #isVTablePointerField.

]

{ #category : #'virtual table' }
SYMLAbstractClass >> buildVTableFieldLayout: vtableField [
	"Apply the existent methods."
	| vtableMethods vtableUsedMethods derivedMethod |
	vtableMethods := OrderedCollection new.
	vtableUsedMethods := IdentitySet new.
	vtableField virtualMethods do: [ :method |
		derivedMethod := overridenMethods at: method ifAbsent: [method].
		vtableMethods add: derivedMethod.
		vtableUsedMethods add: derivedMethod.
	].

	"Apply the new methods"
	vtableField classDefinition == self ifTrue: [
		virtualMethods do: [ :newVirtualMethod |
			(vtableUsedMethods includes: newVirtualMethod) ifFalse: [
				vtableMethods add: newVirtualMethod.
				vtableUsedMethods add: newVirtualMethod.
			]
		]
	].
	
	vtableField virtualMethods: vtableMethods asArray.
	vtableField type: self compilationTarget voidType pointer pointer.
	
	"Set the virtual table index, and the virtual table slot index of the methods."
	self assert: vtableField slotIndex isNotNil.
	vtableField virtualMethods doWithIndex: [ :vmethod :index |
		vmethod virtualTableIndex ifNil: [
			self assert: vmethod virtualTableSlotIndex isNil.
			vmethod
				virtualTableIndex: vtableField slotIndex;
				virtualTableSlotIndex: index - 1
		].
	]
]

{ #category : #'semantic analysis' }
SYMLAbstractClass >> checkNonTrivialBasicInitialization [
	super checkNonTrivialBasicInitialization ifTrue: [ ^ true ].
	virtualMethods ifNotEmpty: [ ^ true ].
	^ false
]

{ #category : #'virtual table' }
SYMLAbstractClass >> checkOverridenMethodBy: derivedMethod [
	| baseMethods |
	baseMethods := OrderedCollection new.
	
	self supertype ifNotNil: [ :st |
		st findOverridedMethodsMatching: derivedMethod into: baseMethods.
	].

	baseMethods ifNotEmpty: [ 
		derivedMethod isOverride ifFalse: [ 
			self error: 'Virtual overriding method {1} requires the override qualifier. ' format: { derivedMethod printString } at: derivedMethod definitionPosition
		].

		"Store who overrides the methods."
		baseMethods do: [ :baseMethod |
			overridenMethods at: baseMethod put: derivedMethod
		].
	
		"Store the list the of methods in the derived method."
		derivedMethod overridenMethods: overridenMethods 	asArray.
	] ifEmpty: [
		derivedMethod isOverride ifTrue: [ 
			self error: 'Cannot find the methods overriden by {1}. ' format: { derivedMethod printString } at: derivedMethod definitionPosition
		]
	]
]

{ #category : #accessing }
SYMLAbstractClass >> fetchVTablePointer: virtualTableIndex of: receiverValue withBuilder: builder [
	^ builder load: (builder getReference: receiverValue element: (builder constInt: virtualTableIndex))
]

{ #category : #'virtual table' }
SYMLAbstractClass >> findOverridedMethodsMatching: derivedMethod into: baseMethods [
	| group matchedAlternative |
	group := derivedMethod isMessageMethod
		ifTrue: [ methodDictionary at: derivedMethod name ifAbsent: [ nil ] ]
		ifFalse: [ symbols at: derivedMethod name ifAbsent: [ nil ] ].
	group ifNotNil: [ 
		matchedAlternative := group findAlternativeMatchedByOverridingMethod: derivedMethod.
		matchedAlternative ifNotNil: [ baseMethods add: matchedAlternative macroFunction ].
	].
	
	self supertype ifNotNil: [ :st | st findOverridedMethodsMatching: derivedMethod into: baseMethods ].
]

{ #category : #'virtual table' }
SYMLAbstractClass >> findOverridenMethods [
	overridenMethods := IdentityDictionary new.
	virtualMethods do: [ :method |
		self checkOverridenMethodBy: method
	].
]

{ #category : #'semantic analysis' }
SYMLAbstractClass >> generateSSARTTI [
	virtualTables do: #vtableSSAValue.
]

{ #category : #testing }
SYMLAbstractClass >> initialize [
	super initialize.
	virtualMethods := OrderedCollection new.
]

{ #category : #testing }
SYMLAbstractClass >> instanceType [
	self assert: self isMetaType.
	
]

{ #category : #testing }
SYMLAbstractClass >> isMetaType [
	^ self cachedNullary: #isMetaType fallbackWith: [ false ]
]

{ #category : #testing }
SYMLAbstractClass >> isSameOrSuperclassOf: anotherClass [
	^ self == anotherClass or: [ self isSuperclassOf: anotherClass ]
]

{ #category : #testing }
SYMLAbstractClass >> isSubclassOf: anotherClass [
	superclass == anotherClass ifTrue: [ ^ true ].
	superclass ifNil: [ ^ false ].
	^ superclass isSubclassOf: anotherClass
]

{ #category : #testing }
SYMLAbstractClass >> isSuperclassOf: anotherClass [
	^ anotherClass isSubclassOf: self
]

{ #category : #testing }
SYMLAbstractClass >> isSysmelClass [
	^ true
]

{ #category : #'symbol lookup' }
SYMLAbstractClass >> lookReceiver: receiver symbol: symbol ifPresent: ifPresentBlock [
	<compileTime>
	super lookReceiver: receiver symbol: symbol ifPresent: [:binding | ^ ifPresentBlock value: binding].
	superclass ifNotNil: [ ^ superclass lookReceiver: receiver symbol: symbol ifPresent: ifPresentBlock ].
	^ nil
]

{ #category : #'symbol lookup' }
SYMLAbstractClass >> lookSymbol: symbol ifPresent: ifPresentBlock [
	super lookSymbol: symbol ifPresent: [:found | ^ ifPresentBlock value: found].
	^ superclass ifNotNil: [ superclass lookSymbol: symbol ifPresent: ifPresentBlock ]
]

{ #category : #accessing }
SYMLAbstractClass >> mangledName [
	| escapedName |
	^ ByteString streamContents: [ :out |
		escapedName := self validName sysmelEscapeForMangling.
		out
			nextPutAll: self parentMangledName;
			nextPut: $C;
			print: escapedName size;
			nextPutAll: escapedName.
	]
]

{ #category : #printing }
SYMLAbstractClass >> printOn: aStream [
	aStream nextPutAll: 'class '; nextPutAll: self printingName
]

{ #category : #accessing }
SYMLAbstractClass >> superclass [
	<compileTime>
	^ superclass
]

{ #category : #accessing }
SYMLAbstractClass >> superclass: newSuperclass [
	<compileTime>
	superclass == newSuperclass ifTrue: [ ^ self ].
	newSuperclass isSysmelClass ifFalse: [ self error: 'Expected a class' ].
	(self isSameOrSuperclassOf: newSuperclass) ifTrue: [ self error: 'Creating circular hierarchy' ].
	superclass := newSuperclass.
	
	self isMetaType ifFalse: [ 
		self invalidateFlattenedTraits.
		newSuperclass ifNotNil: [ 
			metaClassClass ifNil: [
				self metaClassClass: newSuperclass metaClassClass
			].

			metaType ifNotNil: [
				metaType superclass: newSuperclass type
			].
		].
	].


]

{ #category : #accessing }
SYMLAbstractClass >> supertype [
	^ superclass
]
