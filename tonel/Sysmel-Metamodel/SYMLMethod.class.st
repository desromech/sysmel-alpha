Class {
	#name : #SYMLMethod,
	#superclass : #SYMLFunction,
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #testing }
SYMLMethod >> isMethod [
	^ true
]

{ #category : #'as yet unclassified' }
SYMLMethod >> mangledName [
	self isExternC ifTrue: [ ^ name ].
	^ ByteString streamContents: [ :out |
		out
			nextPutAll: self parentMangledName;
			nextPut: $M;
			print: name size;
			nextPutAll: name.
	]
]
