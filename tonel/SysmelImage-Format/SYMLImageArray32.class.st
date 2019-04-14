Class {
	#name : #SYMLImageArray32,
	#superclass : #SYMLImageArray,
	#category : #'SysmelImage-Format'
}

{ #category : #writing }
SYMLImageArray32 >> pointerSize [
	^ 4
]

{ #category : #writing }
SYMLImageArray32 >> writeVariableDataOn: aStream [
	value do: [ :element |
		element ifNil: [
			aStream nextPutInt32: 0
		] ifNotNil: [
			aStream nextPutInt32: element fileOffset
		]
	]
]
