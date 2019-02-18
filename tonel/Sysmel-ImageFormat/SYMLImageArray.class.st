Class {
	#name : #SYMLImageArray,
	#superclass : #SYMLImageObject,
	#instVars : [
		'value'
	],
	#category : #'Sysmel-ImageFormat'
}

{ #category : #writing }
SYMLImageArray >> pointerMemberNames [
	^ #()
]

{ #category : #accessing }
SYMLImageArray >> value [
	^ value
]

{ #category : #accessing }
SYMLImageArray >> value: anObject [
	value := anObject
]

{ #category : #writing }
SYMLImageArray >> variableDataByteSize [
	^ value size * self pointerSize
]

{ #category : #writing }
SYMLImageArray >> variableDataSize [
	^ value size
]

{ #category : #writing }
SYMLImageArray >> vtableValue [
	^ VTable_Array
]
