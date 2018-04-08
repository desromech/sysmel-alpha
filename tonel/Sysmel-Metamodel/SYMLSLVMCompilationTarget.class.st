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

{ #category : #accessing }
SYMLSLVMCompilationTarget >> target [
	^ target
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> target: anObject [
	target := anObject
]
