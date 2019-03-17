Class {
	#name : #MbndAbstractCompilationTarget,
	#superclass : #Object,
	#instVars : [
		'coreDefinitionsModule',
		'basicTypes'
	],
	#category : #'MoebiusBandMetamodel-Core-CompilationTarget'
}

{ #category : #initialization }
MbndAbstractCompilationTarget >> addBasicFloatTypeWithSize: size alignment: alignment name: name [
	^ self addBasicType: (MbndPrimitiveFloatType new
		name: name;
		instanceSize: size;
		instanceAlignment: alignment;
		yourself)
]

{ #category : #initialization }
MbndAbstractCompilationTarget >> addBasicFloatTypeWithSize: size name: name [
	^ self addBasicFloatTypeWithSize: size alignment: size name: name
]

{ #category : #initialization }
MbndAbstractCompilationTarget >> addBasicIntegerTypeWithSize: size alignment: alignment signed: signed name: name [
	^ self addBasicType: (MbndPrimitiveIntegerType new
		name: name;
		instanceSize: size;
		instanceAlignment: alignment;
		signed: signed;
		yourself)
]

{ #category : #initialization }
MbndAbstractCompilationTarget >> addBasicIntegerTypeWithSize: size signed: signed name: name [
	^ self addBasicIntegerTypeWithSize: size alignment: size signed: signed name: name
]

{ #category : #initialization }
MbndAbstractCompilationTarget >> addBasicType: basicType [
	basicTypes at: basicType name put: basicType.
	^ basicType
]

{ #category : #'convenience type accessors' }
MbndAbstractCompilationTarget >> booleanType [
	^ self getBasicTypeNamed: #BooleanBit
]

{ #category : #accessing }
MbndAbstractCompilationTarget >> coreDefinitionsModule [
	^ coreDefinitionsModule
]

{ #category : #accessing }
MbndAbstractCompilationTarget >> coreDefinitionsModule: anObject [
	coreDefinitionsModule := anObject
]

{ #category : #'convenience type accessors' }
MbndAbstractCompilationTarget >> float16Type [
	^ self getBasicTypeNamed: #Float16
]

{ #category : #'convenience type accessors' }
MbndAbstractCompilationTarget >> float32Type [
	^ self getBasicTypeNamed: #Float32
]

{ #category : #accessing }
MbndAbstractCompilationTarget >> float64Alignment [
	^ self subclassResponsibility
]

{ #category : #'convenience type accessors' }
MbndAbstractCompilationTarget >> float64Type [
	^ self getBasicTypeNamed: #Float64
]

{ #category : #accessing }
MbndAbstractCompilationTarget >> getBasicTypeNamed: typeName [
	^ basicTypes at: typeName
]

{ #category : #initialization }
MbndAbstractCompilationTarget >> initializeBasicTypes [
	| basicType |
	basicTypes := Dictionary new.
	MbndBasicType allSubclassesDo: [ :sc |
		sc typeName ifNotNil: [ 
			basicType := sc new compilationTarget: self.
			basicTypes at: basicType name put: basicType
		]
	].

	self
		addBasicType: (MbndPrimitiveBooleanType new name: #BooleanBit; yourself);
		addBasicIntegerTypeWithSize: 1 signed: false name: #UInt8;
		addBasicIntegerTypeWithSize: 2 signed: false name: #UInt16;
		addBasicIntegerTypeWithSize: 4 signed: false name: #UInt32;
		addBasicIntegerTypeWithSize: 8 alignment: self int64Alignment signed: false name: #UInt64;
		
		addBasicIntegerTypeWithSize: 1 signed: true name: #Int8;
		addBasicIntegerTypeWithSize: 2 signed: true name: #Int16;
		addBasicIntegerTypeWithSize: 4 signed: true name: #Int32;
		addBasicIntegerTypeWithSize: 8 alignment: self int64Alignment signed: true name: #Int64;

		addBasicFloatTypeWithSize: 2 name: #Float16;
		addBasicFloatTypeWithSize: 4 name: #Float32;
		addBasicFloatTypeWithSize: 8 alignment: self float64Alignment name: #Float64;
		yourself

]

{ #category : #'convenience type accessors' }
MbndAbstractCompilationTarget >> int16Type [
	^ self getBasicTypeNamed: #Int16
]

{ #category : #'convenience type accessors' }
MbndAbstractCompilationTarget >> int32Type [
	^ self getBasicTypeNamed: #Int32
]

{ #category : #accessing }
MbndAbstractCompilationTarget >> int64Alignment [
	^ self subclassResponsibility
]

{ #category : #'convenience type accessors' }
MbndAbstractCompilationTarget >> int64Type [
	^ self getBasicTypeNamed: #Int64
]

{ #category : #'convenience type accessors' }
MbndAbstractCompilationTarget >> int8Type [
	^ self getBasicTypeNamed: #Int8
]

{ #category : #'builder methods' }
MbndAbstractCompilationTarget >> lookupTypeWithName: typeName [
	^ basicTypes at: typeName ifAbsent: [ nil ]

]

{ #category : #accessing }
MbndAbstractCompilationTarget >> pointerSize [
	self subclassResponsibility
]

{ #category : #'convenience type accessors' }
MbndAbstractCompilationTarget >> uint16Type [
	^ self getBasicTypeNamed: #UInt16
]

{ #category : #'convenience type accessors' }
MbndAbstractCompilationTarget >> uint32Type [
	^ self getBasicTypeNamed: #UInt32
]

{ #category : #'convenience type accessors' }
MbndAbstractCompilationTarget >> uint64Type [
	^ self getBasicTypeNamed: #UInt64
]

{ #category : #'convenience type accessors' }
MbndAbstractCompilationTarget >> uint8Type [
	^ self getBasicTypeNamed: #UInt8
]

{ #category : #'convenience type accessors' }
MbndAbstractCompilationTarget >> voidType [
	^ self getBasicTypeNamed: #Void
]
