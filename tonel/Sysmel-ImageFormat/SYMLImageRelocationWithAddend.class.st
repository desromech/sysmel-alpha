Class {
	#name : #SYMLImageRelocationWithAddend,
	#superclass : #SYMLImageObject,
	#instVars : [
		'vtable',
		'section',
		'sectionFileOffset',
		'symbol',
		'symbolFileOffset',
		'sectionOffset',
		'addend'
	],
	#category : #'Sysmel-ImageFormat'
}

{ #category : #accessing }
SYMLImageRelocationWithAddend >> addend [
	^ addend
]

{ #category : #accessing }
SYMLImageRelocationWithAddend >> addend: anObject [
	addend := anObject
]

{ #category : #initialization }
SYMLImageRelocationWithAddend >> initialize [
	super initialize.
	sectionFileOffset := 0.
	symbolFileOffset := 0.
	sectionOffset := 0.
	addend := 0.
]

{ #category : #writing }
SYMLImageRelocationWithAddend >> pointerMemberNames [
	^ #(sectionFileOffset symbolFileOffset sectionOffset addend)
]

{ #category : #writing }
SYMLImageRelocationWithAddend >> prepareForWritingToFile [
	sectionFileOffset := section ifNil: [ 0 ] ifNotNil: #fileOffset.
	symbolFileOffset := symbol ifNil: [ 0 ] ifNotNil: #fileOffset.
]

{ #category : #accessing }
SYMLImageRelocationWithAddend >> section [
	^ section
]

{ #category : #accessing }
SYMLImageRelocationWithAddend >> section: anObject [
	section := anObject
]

{ #category : #accessing }
SYMLImageRelocationWithAddend >> sectionFileOffset [
	^ sectionFileOffset
]

{ #category : #accessing }
SYMLImageRelocationWithAddend >> sectionOffset [
	^ sectionOffset
]

{ #category : #accessing }
SYMLImageRelocationWithAddend >> sectionOffset: anObject [
	sectionOffset := anObject
]

{ #category : #accessing }
SYMLImageRelocationWithAddend >> symbol [
	^ symbol
]

{ #category : #accessing }
SYMLImageRelocationWithAddend >> symbol: anObject [
	symbol := anObject
]

{ #category : #accessing }
SYMLImageRelocationWithAddend >> symbolFileOffset [
	^ symbolFileOffset
]

{ #category : #accessing }
SYMLImageRelocationWithAddend >> vtable [
	^ vtable
]

{ #category : #accessing }
SYMLImageRelocationWithAddend >> vtable: anObject [
	vtable := anObject
]

{ #category : #accessing }
SYMLImageRelocationWithAddend >> vtableValue [
	^ vtable
]
