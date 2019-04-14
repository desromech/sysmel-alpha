Class {
	#name : #SYMLImageSymbol,
	#superclass : #SYMLImageObject,
	#instVars : [
		'value'
	],
	#category : #'SysmelImage-Format'
}

{ #category : #writing }
SYMLImageSymbol >> pointerMemberNames [
	^ #()
]

{ #category : #accessing }
SYMLImageSymbol >> value [
	^ value
]

{ #category : #accessing }
SYMLImageSymbol >> value: anObject [
	value := anObject
]

{ #category : #writing }
SYMLImageSymbol >> variableDataByteSize [
	^ value size
]

{ #category : #writing }
SYMLImageSymbol >> variableDataSize [
	^ value size
]

{ #category : #writing }
SYMLImageSymbol >> vtableValue [
	^ VTable_Symbol
]

{ #category : #writing }
SYMLImageSymbol >> writeVariableDataOn: aStream [
	aStream nextPutAll: value asByteArray
]
