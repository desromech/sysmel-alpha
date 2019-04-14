Class {
	#name : #SYMLImageRelocationWithAddend64,
	#superclass : #SYMLImageRelocationWithAddend,
	#category : #'SysmelImage-Format'
}

{ #category : #writing }
SYMLImageRelocationWithAddend64 >> pointerSize [
	^ 8
]
