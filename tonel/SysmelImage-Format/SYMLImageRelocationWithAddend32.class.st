Class {
	#name : #SYMLImageRelocationWithAddend32,
	#superclass : #SYMLImageRelocationWithAddend,
	#category : #'SysmelImage-Format'
}

{ #category : #writing }
SYMLImageRelocationWithAddend32 >> pointerSize [
	^ 4
]
