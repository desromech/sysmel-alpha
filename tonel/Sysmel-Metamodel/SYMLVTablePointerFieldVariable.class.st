Class {
	#name : #SYMLVTablePointerFieldVariable,
	#superclass : #SYMLFieldVariable,
	#instVars : [
		'classDefinition',
		'originalClassDefinition',
		'virtualMethods',
		'vtableSSAValue',
		'hasConcretedVTableSSAType',
		'vtableSSAGlobalVariable',
		'vtableSSAType'
	],
	#category : #'Sysmel-Metamodel-Variable'
}

{ #category : #adding }
SYMLVTablePointerFieldVariable >> addToStructureLayoutBuilder: layoutBuilder [
	layoutBuilder addVTablePointerField: self
]

{ #category : #accessing }
SYMLVTablePointerFieldVariable >> at: index [
	<compileTime>
	index >= 1 ifTrue: [ 
		self assert: offset isNotNil.
		virtualMethods at: index.
	].

	"Type info"
	index = 0 ifTrue: [
		^ self parent
	].

	"Base offset"
	index = -1 ifTrue: [
		self assert: offset isNotNil.
		^ offset negated
	].

]

{ #category : #'code generation' }
SYMLVTablePointerFieldVariable >> basicInitializeSSAVariable: ssaVariable with: builder [
	| fieldPointer |
	fieldPointer := builder getReference: ssaVariable element: (builder constInt: slotIndex).
	builder store: self vtableSSAValue in: fieldPointer
]

{ #category : #'code generation' }
SYMLVTablePointerFieldVariable >> buildConcreteVTableSSAType [
	self vtableSSAType
		types: {self compilationTarget uintPointerType ssaType . self compilationTarget voidType pointer ssaType } , (virtualMethods collect: [ :vm | vm functionType pointer ssaType ]);
		names: #(offset typeinfo) , (virtualMethods collectWithIndex: [ :vm :i | (#vmethod , i asString) asSymbol]).

]

{ #category : #accessing }
SYMLVTablePointerFieldVariable >> classDefinition [
	^ classDefinition
]

{ #category : #accessing }
SYMLVTablePointerFieldVariable >> classDefinition: anObject [
	classDefinition := anObject
]

{ #category : #accessing }
SYMLVTablePointerFieldVariable >> defaultValue [
	^ self
]

{ #category : #'code generation' }
SYMLVTablePointerFieldVariable >> ensureConcreteVTableSSAType [
	hasConcretedVTableSSAType ifTrue: [ ^ self ].
	hasConcretedVTableSSAType := true.

	self buildConcreteVTableSSAType
]

{ #category : #'code generation' }
SYMLVTablePointerFieldVariable >> ensureVTableSSAGlobalVariable [
	vtableSSAGlobalVariable := SLVMGlobalVariable module: self module ssaModule
		name: self mangledName
		valueType: self vtableSSAType
		storage: SLVMType genericStorage.
	vtableSSAGlobalVariable makePublic.

	self ensureConcreteVTableSSAType.
	parent computeInstanceSizes. "For offset"
	vtableSSAGlobalVariable initialValue: (SLVMConstant structure: self vtableSSAType slots: {
		"Offset"
		SLVMConstant type: self compilationTarget uintPointerType ssaType value: offset negated.
		
		"Typeinfo"
		SLVMConstant pointer: parent ssaTypeInfo castTo: self compilationTarget voidType pointer ssaType.
	} ,
		(virtualMethods collect: #ssaValue)
	)
]

{ #category : #'code generation' }
SYMLVTablePointerFieldVariable >> ensureVTableSSAValue [
	| global |
	vtableSSAValue ifNotNil: [ ^ self ].
	global := self vtableSSAGlobalVariable.

	"This could be nil because of recursion."
	vtableSSAValue ifNil: [
		virtualMethods ifEmpty: [ 
			vtableSSAValue := SLVMConstant
				pointer: (SLVMConstant getPointer: global element: {SLVMConstant int: 1})
				castTo: self type ssaType
		] ifNotEmpty: [ 
			vtableSSAValue := SLVMConstant
				pointer: (SLVMConstant getReference: global element: 2)
				castTo: self type ssaType
		].
	].
	

]

{ #category : #'as yet unclassified' }
SYMLVTablePointerFieldVariable >> finishBuilding [
]

{ #category : #'code generation' }
SYMLVTablePointerFieldVariable >> generateSSAReferenceWith: builder [
	self halt.
]

{ #category : #'code generation' }
SYMLVTablePointerFieldVariable >> generateSysmelSSAPointerConstantOfType: pointerType forModule: aModule [
	^ self vtableSSAValue
]

{ #category : #testing }
SYMLVTablePointerFieldVariable >> hasNonTrivialGCBasicInitialization [
	^ true
]

{ #category : #initialization }
SYMLVTablePointerFieldVariable >> initialize [
	super initialize.
	virtualMethods := #().
	hasConcretedVTableSSAType := false.
]

{ #category : #testing }
SYMLVTablePointerFieldVariable >> isVTablePointerField [
	^ true
]

{ #category : #accessing }
SYMLVTablePointerFieldVariable >> mangledName [
	| escapedName |
	^ mangledName ifNil: [mangledName := ByteString streamContents: [ :out |
			escapedName := self validName sysmelEscapeForMangling.
			out
				nextPutAll: self parentMangledName;
				nextPutAll: '_vtable_';
				print: slotIndex
		]
	]
]

{ #category : #accessing }
SYMLVTablePointerFieldVariable >> originalClassDefinition [
	^ originalClassDefinition
]

{ #category : #accessing }
SYMLVTablePointerFieldVariable >> originalClassDefinition: anObject [
	originalClassDefinition := anObject
]

{ #category : #accessing }
SYMLVTablePointerFieldVariable >> subscriptAt: index [
	<compileTime>
	^ self at: index + 1
]

{ #category : #accessing }
SYMLVTablePointerFieldVariable >> virtualMethods [
	^ virtualMethods
]

{ #category : #accessing }
SYMLVTablePointerFieldVariable >> virtualMethods: anObject [
	virtualMethods := anObject
]

{ #category : #'code generation' }
SYMLVTablePointerFieldVariable >> vtableSSAGlobalVariable [
	vtableSSAGlobalVariable ifNil: [self ensureVTableSSAGlobalVariable].
	^ vtableSSAGlobalVariable
]

{ #category : #'code generation' }
SYMLVTablePointerFieldVariable >> vtableSSAType [
	vtableSSAType ifNil: [
		vtableSSAType := SLVMStructureType new
			name: self mangledName;
			kind: SLVMStructureType genericKind;
			yourself.
		self parent module ssaModule addStructure: vtableSSAType
	].

	^ vtableSSAType
]

{ #category : #'code generation' }
SYMLVTablePointerFieldVariable >> vtableSSAValue [
	vtableSSAValue ifNil: [self ensureVTableSSAValue].
	^ vtableSSAValue
]
