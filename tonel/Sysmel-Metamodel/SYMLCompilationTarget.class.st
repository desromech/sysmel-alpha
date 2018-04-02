Class {
	#name : #SYMLCompilationTarget,
	#superclass : #SYMLObject,
	#instVars : [
		'apsgNodeType',
		'compilerObjectType',
		'literalSymbolType',
		'booleanType',
		'voidType',
		'functionTypeTrait',
		'tupleTypeTrait',
		'functionTypeCache',
		'tupleTypeCache'
	],
	#category : #'Sysmel-Metamodel-CompilationTarget'
}

{ #category : #construction }
SYMLCompilationTarget class >> x86 [
	^ SYMLSLVMCompilationTarget  target: SLVMCompilationTarget x86
]

{ #category : #construction }
SYMLCompilationTarget class >> x86_64 [
	^ SYMLSLVMCompilationTarget  target: SLVMCompilationTarget x86_64
]

{ #category : #accessing }
SYMLCompilationTarget >> apsgNodeType [
	<compileTime>
	^ apsgNodeType
]

{ #category : #accessing }
SYMLCompilationTarget >> apsgNodeType: anObject [
	<compileTime>
	apsgNodeType := anObject
]

{ #category : #accessing }
SYMLCompilationTarget >> booleanType [
	<compileTime>
	^ booleanType
]

{ #category : #accessing }
SYMLCompilationTarget >> booleanType: anObject [
	<compileTime>
	booleanType := anObject
]

{ #category : #accessing }
SYMLCompilationTarget >> compilerObjectType [
	<compileTime>
	^ compilerObjectType
]

{ #category : #accessing }
SYMLCompilationTarget >> compilerObjectType: anObject [
	<compileTime>
	compilerObjectType := anObject
]

{ #category : #'builder methods' }
SYMLCompilationTarget >> functionArguments: argumentTypes returnType: returnType callingConvention: callingConvention variadic: variadic [
	| functionType |
	functionType := SYMLFunctionType new
		compilationTarget: self;
		addTrait: functionTypeTrait;
		arguments: argumentTypes;
		returnType: returnType;
		callingConvention: callingConvention;
		variadic: variadic;
		yourself.
	^ functionTypeCache at: functionType ifAbsentPut: [ functionType ]
	

]

{ #category : #accessing }
SYMLCompilationTarget >> functionTypeTrait [
	<compileTime>
	^ functionTypeTrait
]

{ #category : #accessing }
SYMLCompilationTarget >> functionTypeTrait: anObject [
	<compileTime>
	functionTypeTrait := anObject
]

{ #category : #initialization }
SYMLCompilationTarget >> initialize [
	super initialize.
	functionTypeCache := Dictionary new.
	tupleTypeCache := Dictionary new.
]

{ #category : #accessing }
SYMLCompilationTarget >> literalSymbolType [
	<compileTime>
	^ literalSymbolType
]

{ #category : #accessing }
SYMLCompilationTarget >> literalSymbolType: anObject [
	<compileTime>
	literalSymbolType := anObject
]

{ #category : #'builder methods' }
SYMLCompilationTarget >> tuple: aCollectionOfTypes [
	| tuple |
	tuple := SYMLTupleType new
		compilationTarget: self;
		addTrait: tupleTypeTrait;
		types: aCollectionOfTypes asArray;
		yourself.
	^ tupleTypeCache at: tuple ifAbsentPut: [ tuple ]
]

{ #category : #accessing }
SYMLCompilationTarget >> tupleTypeTrait [
	<compileTime>
	^ tupleTypeTrait
]

{ #category : #accessing }
SYMLCompilationTarget >> tupleTypeTrait: anObject [
	<compileTime>
	tupleTypeTrait := anObject
]

{ #category : #accessing }
SYMLCompilationTarget >> voidType [
	<compileTime>
	^ voidType
]

{ #category : #accessing }
SYMLCompilationTarget >> voidType: anObject [
	<compileTime>
	voidType := anObject
]
