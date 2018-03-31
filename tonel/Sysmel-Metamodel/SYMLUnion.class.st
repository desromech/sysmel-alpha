Class {
	#name : #SYMLUnion,
	#superclass : #SYMLStructure,
	#category : #Sysmel-Metamodel-Program
}

{ #category : #private }
SYMLUnion >> buildPartialSSAType [
	^ SLVMUnionType new name: self mangledName; kind: SLVMUnionType genericKind.
]

{ #category : #accessing }
SYMLUnion >> mangledName [
	^ ByteString streamContents: [ :out |
		out
			nextPutAll: self parentMangledName;
			nextPut: $U;
			print: name size;
			nextPutAll: name.
	]
]
