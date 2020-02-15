Class {
	#name : #MbndGCClassType,
	#superclass : #MbndAbstractClassType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndGCClassType class >> typeName [
	^ #_GCClassType
]

{ #category : #visiting }
MbndGCClassType >> accept: aVisitor [
	^ aVisitor visitGCClassType: self
]

{ #category : #adding }
MbndGCClassType >> addDefaultConversionRules [
	super addDefaultConversionRules.
	self
		addExplicitConversionRule: MbndClassPointerTypeConversionRule new;
		addImplicitConversionRule: MbndClassImplicitUpcastTypeConversionRule new
]

{ #category : #'as yet unclassified' }
MbndGCClassType >> addMetaTypeMacrosTo: metaType [
	metaType
		onMacroSelectors: #( definition: extend: )do: [ :node :builder |
			builder programEntity: node receiver extension: node arguments first
		]
]

{ #category : #'semantic analysis' }
MbndGCClassType >> analyzeMessageSendNodeWithDynamicSelector: node with: analyzer [
	^ analyzer visitNode: node asExpandedDynamicMessageSend
]

{ #category : #converting }
MbndGCClassType >> analyzeReinterpretCastNode: node to: targetType with: analyzer [
	| undecoratedTargetType |
	undecoratedTargetType := targetType withoutTopDecorations.
	
	undecoratedTargetType isPointerLikeValueType ifTrue: [
		^ analyzer visitNode: (MbndAstPointerReinterpretCastNode new
			position: node;
			expression: node expression;
			targetType: targetType;
			yourself)
	].

	(undecoratedTargetType isPrimitiveIntegerType and: [ undecoratedTargetType instanceSize = self instanceSize ]) ifTrue: [
		^ analyzer visitNode: (MbndAstPointerToIntegerCastNode new
			position: node;
			expression: node expression;
			targetType: targetType;
			yourself)
	].

	^ super analyzeReinterpretCastNode: node to: targetType with: analyzer
]

{ #category : #'semantic analysis' }
MbndGCClassType >> analyzeUnhandledUnboundExpandedMessageSendNode: node with: analyzer [
	^ analyzer visitNode: node asExpandedDynamicMessageSend
]

{ #category : #'type composition' }
MbndGCClassType >> array [
	<compileTime>
	^ self gcclassVariableDataArray
]

{ #category : #'as yet unclassified' }
MbndGCClassType >> asCVariadicTypeRequiredAt: position [
	^ self
]

{ #category : #converting }
MbndGCClassType >> asCanonicalMessageSendValueType [
	^ self compilationTarget dynamicObjectType
]

{ #category : #'as yet unclassified' }
MbndGCClassType >> asConstReceiverType [
	^ self const
]

{ #category : #converting }
MbndGCClassType >> asCopyConstructorParameter [
	^ self
]

{ #category : #converting }
MbndGCClassType >> asDefaultInstanceType [
	^ self compilationTarget dynamicObjectType ifNil: [ self error: 'Dynamic object type is required at this context.' ]
]

{ #category : #converting }
MbndGCClassType >> asDynamicMethodWrapperReceiverType [
	^ self
]

{ #category : #converting }
MbndGCClassType >> asImmutableValueType [
	^ self
]

{ #category : #converting }
MbndGCClassType >> asInstanceObjectForTypeInfoGeneration [
	| result |
	result := self type makeInstance: 0 identityHash: self identityHash at: MbndSourcePosition empty.
	self fillTypeInfoInstance: result.
	^ result
]

{ #category : #converting }
MbndGCClassType >> asMovementConstructorParameter [
	^ self
]

{ #category : #'as yet unclassified' }
MbndGCClassType >> asReceiverType [
	"My scheme is to be always a gc pointer."
	^ self
]

{ #category : #'as yet unclassified' }
MbndGCClassType >> createMetaTypeBasicInstance [
	^ MbndGCClassMetaType basicNew markAsDefined
]

{ #category : #'as yet unclassified' }
MbndGCClassType >> defaultArgumentType [
	^ self compilationTarget dynamicObjectType
]

{ #category : #'as yet unclassified' }
MbndGCClassType >> defaultReturnType [
	^ self compilationTarget dynamicObjectType
]

{ #category : #'default values' }
MbndGCClassType >> defaultValueAt: position [
	^ MbndValue value: nil type: self
]

{ #category : #'as yet unclassified' }
MbndGCClassType >> defaultVariableType [
	^ self compilationTarget dynamicObjectType
]

{ #category : #converting }
MbndGCClassType >> fillTypeInfoInstance: typeInfoInstance [
	| variableDataType |
	variableDataType := nil.
	self slotLayout slots last type isGCClassVariableDataArrayType ifTrue: [ 
		variableDataType := self slotLayout slots last type elementType.
	].

	self compilationTarget managedObjectModel gcLayoutClass ifNotNil: [ :gcLayoutClass |
		| wordSize bitsPerWord wordCount gcLayout bitmap |
		wordSize := self compilationTarget pointerSize.
		wordCount := (self instanceDataSize alignedTo: self instanceDataAlignment) / wordSize.
		bitsPerWord := wordSize * 8.
		gcLayout := gcLayoutClass makeInstance: wordCount identityHash: 0.
		bitmap := gcLayout slots last slots.
		variableDataType ifNotNil: [
			variableDataType hasGarbageCollectedAddressSpace ifTrue: [
				gcLayout setField: #variableDataIsGCPointers value: true.
			].
		].
	
		self slotLayout slots do: [ :slot |
			slot type hasGarbageCollectedAddressSpace ifTrue: [ 
				| baseWord |
				baseWord := slot offset // wordSize.
				0 to: slot type instanceSize // wordSize - 1 do: [ :i |
					| wordIndex bitIndex |
					wordIndex := (baseWord + i) // bitsPerWord + 1.
					bitIndex := (baseWord + i) % bitsPerWord.
					bitmap at: wordIndex put: (bitmap at: wordIndex) | (1 << bitIndex).
				].
			].
		].
		typeInfoInstance setField: #gcLayout value: gcLayout.
	].

	typeInfoInstance
		setField: #superclass value: self superclass;
		setField: #methodDict value: self methodDictionaryInstanceObject;
		setField: #basicInitializationFunctionPointer value: self basicInitializeMethod;
		setField: #instanceDataSize value: self instanceDataSize;
		setField: #instanceDataAlignment value: self instanceDataAlignment;
		setField: #variableInstanceElementSize value: (variableDataType ifNil: [ 0 ] ifNotNil: [variableDataType instanceSize]);
		setField: #variableInstanceElementAlignment value: (variableDataType ifNil: [ 1 ] ifNotNil: [variableDataType instanceAlignment]);
		setField: #name ifExistsWith: [ name ];
		setField: #subclasses ifExistsWith: [ (self subtypes select: [:each | each isGCClassType]) asArray ].
]

{ #category : #testing }
MbndGCClassType >> hasDynamicMessageLookup [
	^ true
]

{ #category : #testing }
MbndGCClassType >> hasTrivialBasicInitialization [
	^ true
]

{ #category : #testing }
MbndGCClassType >> hasTrivialFinalization [
	^ true
]

{ #category : #testing }
MbndGCClassType >> hasTrivialInitialization [
	^ true
]

{ #category : #testing }
MbndGCClassType >> hasTrivialInitializationCopyingFrom [
	^ true
]

{ #category : #testing }
MbndGCClassType >> hasTrivialInitializationMovingFrom [
	^ true
]

{ #category : #'as yet unclassified' }
MbndGCClassType >> identityHashField [
	^ self slotLayout identityHashField
]

{ #category : #accessing }
MbndGCClassType >> instanceAlignment [
	<compileTime>
	^ self compilationTarget pointerSize
]

{ #category : #accessing }
MbndGCClassType >> instanceSize [
	<compileTime>
	^ self compilationTarget pointerSize
]

{ #category : #testing }
MbndGCClassType >> isGCClassType [
	^ true
]

{ #category : #testing }
MbndGCClassType >> isGarbageCollectedType [
	^ true
]

{ #category : #testing }
MbndGCClassType >> isMemoryReturnedType [
	^ false
]

{ #category : #'testing methods' }
MbndGCClassType >> isPointerLikeValueType [
	^ true
]

{ #category : #'testing methods' }
MbndGCClassType >> isReferenceLikeValueType [
	^ true
]

{ #category : #testing }
MbndGCClassType >> isTypePassedByReference [
	^ false
]

{ #category : #'default values' }
MbndGCClassType >> makeInstance [
	^ self makeInstance: 0 identityHash: 0
]

{ #category : #'as yet unclassified' }
MbndGCClassType >> makeInstance: variableSize identityHash: identityHash [
	^ self makeInstance: variableSize identityHash: identityHash at: MbndSourcePosition empty
]

{ #category : #'as yet unclassified' }
MbndGCClassType >> makeInstance: variableSize identityHash: identityHash at: aPosition [
	| result variableElementType |
	result := self defaultAggregateValueAt: aPosition.
	variableSize > 0 ifTrue: [ 
		variableElementType := self slotLayout slots last type.
		variableElementType isGCClassVariableDataArrayType ifFalse: [
			self error: 'Cannot make an instance for a variable object without variable slot data.' at: aPosition
		].
		result slots last resizeTo: variableSize at: aPosition.
	].

	^ result
		__identityHashValue: identityHash;
		__variableDataSizeValue: variableSize;
		yourself
]

{ #category : #'as yet unclassified' }
MbndGCClassType >> metaClassClass: theClassForTheMetaClass [
	<compileTime>
	type type: theClassForTheMetaClass.
	self addMetaTypeMacrosTo: type.
	(theClassForTheMetaClass hasFlag: #metaClassClass) ifFalse: [ 
		theClassForTheMetaClass addFlag: #metaClassClass.
		self addMetaTypeMacrosTo: theClassForTheMetaClass
	]
]

{ #category : #'type composition' }
MbndGCClassType >> ref [
	<compileTime>
	^ self refFor: #gc
]

{ #category : #testing }
MbndGCClassType >> requiresDynamicMethodWrappers [
	^ true
]

{ #category : #'as yet unclassified' }
MbndGCClassType >> unmangledStructureTypePrefix [
	^ 'gcclass.'
]

{ #category : #'as yet unclassified' }
MbndGCClassType >> variableDataSizeField [
	^ self slotLayout variableDataSizeField
]
