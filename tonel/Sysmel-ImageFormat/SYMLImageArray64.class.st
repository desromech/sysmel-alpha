Class {
	#name : #SYMLImageArray64,
	#superclass : #SYMLImageArray,
	#category : #'Sysmel-ImageFormat'
}

{ #category : #writing }
SYMLImageArray64 >> pointerSize [
	^ 8
]

{ #category : #writing }
SYMLImageArray64 >> writeVariableDataOn: aStream [
	value do: [ :element |
		element ifNil: [
			aStream nextPutInt64: 0
		] ifNotNil: [
			aStream nextPutInt64: element fileOffset
		]
	]
]
