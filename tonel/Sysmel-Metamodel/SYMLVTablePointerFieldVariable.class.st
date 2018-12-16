Class {
	#name : #SYMLVTablePointerFieldVariable,
	#superclass : #SYMLFieldVariable,
	#instVars : [
		'classDefinition',
		'originalClassDefinition',
		'virtualMethods',
		'vtableSSAValue'
	],
	#category : #'Sysmel-Metamodel-Variable'
}

{ #category : #adding }
SYMLVTablePointerFieldVariable >> addToStructureLayoutBuilder: layoutBuilder [
	layoutBuilder addVTablePointerField: self
]

{ #category : #'code generation' }
SYMLVTablePointerFieldVariable >> basicInitializeSSAVariable: ssaVariable with: builder [
	| fieldPointer vtablePointer |
	fieldPointer := builder getReference: ssaVariable element: (builder constInt: slotIndex).
	vtablePointer := builder getReference: self vtableSSAValue element: (builder constInt: 2).
	builder store: (builder bitCast: vtablePointer target: self type ssaType) in: fieldPointer
]

{ #category : #accessing }
SYMLVTablePointerFieldVariable >> classDefinition [
	^ classDefinition
]

{ #category : #accessing }
SYMLVTablePointerFieldVariable >> classDefinition: anObject [
	classDefinition := anObject
]

{ #category : #'code generation' }
SYMLVTablePointerFieldVariable >> ensureVTableSSAValue [
	vtableSSAValue ifNotNil: [ ^ self ].
	parent computeInstanceSizes. "For offset"
	
	vtableSSAValue := SLVMGlobalVariable module: self module ssaModule
		name: self mangledName
		valueType: self vtableSSAType
		storage: SLVMType genericStorage.
	vtableSSAValue makePublic.
	
	vtableSSAValue initialValue: (SLVMConstant structure: self vtableSSAType slots: {
		"Offset"
		SLVMConstant type: self compilationTarget uintPointerType ssaType value: offset negated.
		
		"Typeinfo"
		parent ssaTypeInfo.
	} ,
		(virtualMethods collect: #ssaValue)
	)
]

{ #category : #initialization }
SYMLVTablePointerFieldVariable >> initialize [
	super initialize.
	virtualMethods := #().
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
SYMLVTablePointerFieldVariable >> virtualMethods [
	^ virtualMethods
]

{ #category : #accessing }
SYMLVTablePointerFieldVariable >> virtualMethods: anObject [
	virtualMethods := anObject
]

{ #category : #'code generation' }
SYMLVTablePointerFieldVariable >> vtableSSAType [
	| vtableSSAType |
	vtableSSAType ifNil: [
		vtableSSAType := SLVMStructureType name: self mangledName
			types: {self compilationTarget uintPointerType ssaType . parent ssaTypeInfo type } , (virtualMethods collect: [ :vm | vm functionType pointer ssaType ])
			kind: SLVMStructureType genericKind
			names: #(offset typeinfo) , (virtualMethods collectWithIndex: [ :vm :i | (#vmethod , i asString) asSymbol]).
		self parent module ssaModule addStructure: vtableSSAType
	].

	^ vtableSSAType
]

{ #category : #'code generation' }
SYMLVTablePointerFieldVariable >> vtableSSAValue [
	vtableSSAValue ifNil: [self ensureVTableSSAValue].
	^ vtableSSAValue
]
