Class {
	#name : #SYMLImageString,
	#superclass : #SYMLImageObject,
	#instVars : [
		'value'
	],
	#category : #'Sysmel-ImageFormat'
}

{ #category : #writing }
SYMLImageString >> pointerMemberNames [
	^ #()
]

{ #category : #accessing }
SYMLImageString >> value [
	^ value
]

{ #category : #accessing }
SYMLImageString >> value: anObject [
	value := anObject
]

{ #category : #writing }
SYMLImageString >> variableDataByteSize [
	^ value size
]

{ #category : #writing }
SYMLImageString >> variableDataSize [
	^ value size
]

{ #category : #writing }
SYMLImageString >> vtableValue [
	^ VTable_String
]

{ #category : #writing }
SYMLImageString >> writeVariableDataOn: aStream [
	aStream nextPutAll: value asByteArray
]
