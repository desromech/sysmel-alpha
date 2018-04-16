Class {
	#name : #SYMLUnion,
	#superclass : #SYMLStructure,
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #'code generation' }
SYMLUnion >> buildSSAType [
	^ SLVMUnionType new name: self mangledName; kind: SLVMStructureType genericKind.
]

{ #category : #printing }
SYMLUnion >> printOn: aStream [
	aStream nextPutAll: 'union '; nextPutAll: self validName
]

{ #category : #'as yet unclassified' }
SYMLUnion >> typeKindBaseTrait [
	^ self compilationTarget unionTypeTrait
]
