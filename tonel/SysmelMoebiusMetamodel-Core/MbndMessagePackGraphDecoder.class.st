Class {
	#name : #MbndMessagePackGraphDecoder,
	#superclass : #SLVMMessagePackGraphDecoder,
	#instVars : [
		'compilationTarget',
		'compilationEnvironment',
		'targetModule',
		'moduleLocation'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Serialization'
}

{ #category : #accessing }
MbndMessagePackGraphDecoder >> compilationEnvironment [
	^ compilationEnvironment
]

{ #category : #accessing }
MbndMessagePackGraphDecoder >> compilationEnvironment: anObject [
	compilationEnvironment := anObject
]

{ #category : #accessing }
MbndMessagePackGraphDecoder >> compilationTarget [
	^ compilationTarget
]

{ #category : #accessing }
MbndMessagePackGraphDecoder >> compilationTarget: anObject [
	compilationTarget := anObject
]

{ #category : #accessing }
MbndMessagePackGraphDecoder >> moduleLocation [
	^ moduleLocation ifNil: [moduleLocation := MbndImportedModulePosition new module: targetModule]
]

{ #category : #accessing }
MbndMessagePackGraphDecoder >> targetModule [
	^ targetModule
]

{ #category : #accessing }
MbndMessagePackGraphDecoder >> targetModule: anObject [
	targetModule := anObject
]
