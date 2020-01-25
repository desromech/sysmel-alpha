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

{ #category : #adding }
MbndGCClassType >> addMainVTableFieldNamed: fieldName [
	<compileTime>
	| fieldType vtableField |
	fieldType := self vtableFieldType.
	vtableField := MbndVTablePointerFieldVariable new
		name: fieldName;
		valueType: fieldType;
		type: fieldType ref.
	self addField: vtableField.
	^ vtableField
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
MbndGCClassType >> asImmutableValueType [
	^ self
]

{ #category : #converting }
MbndGCClassType >> asInstanceObjectForTypeInfoGeneration [
	| result variableDataType |
	result := self type makeInstance: 0 identityHash: self identityHash at: MbndSourcePosition empty.
	self flag: 'TODO: Set the GC layout.'.
	
	variableDataType := nil.
	(fields isNotEmpty and: [ fields last valueType isGCClassVariableDataArrayType ]) ifTrue: [ 
		variableDataType := fields last valueType elementType.
	].

	^ result
		setField: #superclass value: self superclass;
		setField: #methodDict value: self methodDictionaryInstanceObject;
		setField: #basicInitializeFunctionPointer value: self basicInitializeMethod;
		setField: #instanceDataSize value: self instanceDataSize;
		setField: #instanceDataAlignment value: self instanceDataAlignment;
		setField: #variableInstanceElementSize value: (variableDataType ifNil: [ 0 ] ifNotNil: [variableDataType instanceSize]);
		setField: #variableInstanceElementAlignment value: (variableDataType ifNil: [ 1 ] ifNotNil: [variableDataType instanceAlignment]);
		setField: #name ifExistsWith: [ name ];
		setField: #subclasses ifExistsWith: [ (self subtypes select: [:each | each isGCClassType]) asArray ];
		yourself
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
MbndGCClassType >> hasTrivialInitializationFromCopy [
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
	self addMetaTypeMacrosTo: type
]

{ #category : #'type composition' }
MbndGCClassType >> ref [
	<compileTime>
	^ self refFor: #gc
]

{ #category : #converting }
MbndGCClassType >> superclass [
	^ supertype isTrait
		ifTrue: [ nil ]
		ifFalse: [ self supertype ].
]

{ #category : #'as yet unclassified' }
MbndGCClassType >> unmangledStructureTypePrefix [
	^ 'gcclass.'
]

{ #category : #'as yet unclassified' }
MbndGCClassType >> variableDataSizeField [
	^ self slotLayout variableDataSizeField
]
