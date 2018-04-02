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

{ #category : #accessing }
SYMLSLVMCompilationTarget >> target [
	^ target
]

{ #category : #accessing }
SYMLSLVMCompilationTarget >> target: anObject [
	target := anObject
]
