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
SYMLSLVMCompilationTarget >> ssaPointerTo: targetType [
	<compileTime>
	^ target pointerTo: targetType
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
	target := anObject
]
