Class {
	#name : #SYMLSLVMCompilationTarget,
	#superclass : #SYMLCompilationTarget,
	#instVars : [
		'target'
	],
	#category : #'Sysmel-Metamodel-CompilationTarget'
}

{ #category : #accessing }
SYMLSLVMCompilationTarget class >> target: target [
	^ self new target: target
]

{ #category : #'target platform querying' }
SYMLSLVMCompilationTarget >> doubleAlignment [
	<compileTime>
	^ target double alignment
]

{ #category : #options }
SYMLSLVMCompilationTarget >> emittingDebugInformation [
	^ target emittingDebugInformation
]

{ #category : #testing }
SYMLSLVMCompilationTarget >> isSpirV [
	^ target isSpirV
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> objectModel [
	<compileTime>
	^ target objectModel
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> operatingSystemName [
	<compileTime>
	^ target operatingSystemName
]

{ #category : #'position indepence code' }
SYMLSLVMCompilationTarget >> pic [
	<compileTime>
	target pic
]

{ #category : #'target platform querying' }
SYMLSLVMCompilationTarget >> pointerAlignment [
	<compileTime>
	^ target pointerAlignment
]

{ #category : #'target platform querying' }
SYMLSLVMCompilationTarget >> pointerSize [
	<compileTime>
	^ target pointerSize
]

{ #category : #'accesing ssa types' }
SYMLSLVMCompilationTarget >> ssaArrayOf: elementType size: size [
	<compileTime>
	^ target arrayOf: elementType size: size
]

{ #category : #'target platform querying' }
SYMLSLVMCompilationTarget >> ssaBoolType [
	<compileTime>
	^ target bool
]

{ #category : #'target platform querying' }
SYMLSLVMCompilationTarget >> ssaFloat32 [
	<compileTime>
	^ target float32
]

{ #category : #'target platform querying' }
SYMLSLVMCompilationTarget >> ssaFloat64 [
	<compileTime>
	^ target float64
]

{ #category : #'target platform querying' }
SYMLSLVMCompilationTarget >> ssaInt16 [
	<compileTime>
	^ target int16
]

{ #category : #'target platform querying' }
SYMLSLVMCompilationTarget >> ssaInt32 [
	<compileTime>
	^ target int32
]

{ #category : #'target platform querying' }
SYMLSLVMCompilationTarget >> ssaInt64 [
	<compileTime>
	^ target int64
]

{ #category : #'target platform querying' }
SYMLSLVMCompilationTarget >> ssaInt8 [
	<compileTime>
	^ target int8
]

{ #category : #'accesing ssa types' }
SYMLSLVMCompilationTarget >> ssaMatrix: baseType rows: rows columns: columns [
	<compileTime>
	^ target matrix: baseType rows: rows columns: columns
]

{ #category : #'accesing ssa types' }
SYMLSLVMCompilationTarget >> ssaPointerTo: targetType forAddressSpace: addressSpaceName [
	<compileTime>
	^ target pointerTo: targetType storage: addressSpaceName
]

{ #category : #'target platform querying' }
SYMLSLVMCompilationTarget >> ssaUInt16 [
	<compileTime>
	^ target uint16
]

{ #category : #'target platform querying' }
SYMLSLVMCompilationTarget >> ssaUInt32 [
	<compileTime>
	^ target uint32
]

{ #category : #'target platform querying' }
SYMLSLVMCompilationTarget >> ssaUInt64 [
	<compileTime>
	^ target uint64
]

{ #category : #'target platform querying' }
SYMLSLVMCompilationTarget >> ssaUInt8 [
	<compileTime>
	^ target uint8
]

{ #category : #'accesing ssa types' }
SYMLSLVMCompilationTarget >> ssaVector: baseType elements: elements [
	<compileTime>
	^ target vector: baseType elements: elements
]

{ #category : #'target platform querying' }
SYMLSLVMCompilationTarget >> ssaVoidType [
	<compileTime>
	^ target void
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> target [
	<compileTime>
	^ target
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> target: anObject [
	<compileTime>
	target := anObject.
	target objectModel: (SYMLSLVMObjectModel new target: target)
]

{ #category : #options }
SYMLSLVMCompilationTarget >> withDebugInformation [
	target withDebugInformation
]
