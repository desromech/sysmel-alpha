Class {
	#name : #SYMLMethod,
	#superclass : #SYMLFunction,
	#category : #'Sysmel-Metamodel-Program'
}

{ #category : #testing }
SYMLMethod >> isExternC [
	<compileTime>
	^ false
]

{ #category : #testing }
SYMLMethod >> isMethod [
	^ true
]

{ #category : #accessing }
SYMLMethod >> mangledName [
	| escapedName |
	self isExternC ifTrue: [ ^ name ].
	^ ByteString streamContents: [ :out |
		escapedName := name sysmelEscapeForMangling.
		out
			nextPutAll: self parentMangledName;
			nextPut: $M;
			print: escapedName size;
			nextPutAll: escapedName.
	]
]
