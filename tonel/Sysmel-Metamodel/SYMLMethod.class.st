Class {
	#name : #SYMLMethod,
	#superclass : #SYMLFunction,
	#instVars : [
		'isVirtual',
		'virtualSlot'
	],
	#category : #Sysmel-Metamodel-Program
}

{ #category : #initialization }
SYMLMethod >> initialize [
	super initialize.
	isVirtual := false.
	
]

{ #category : #testing }
SYMLMethod >> isMethod [
	^ true
]

{ #category : #accessing }
SYMLMethod >> isVirtual [
	^ isVirtual
]

{ #category : #accessing }
SYMLMethod >> isVirtual: anObject [
	isVirtual := anObject
]

{ #category : #'semantic analysis' }
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

{ #category : #accessing }
SYMLMethod >> virtualSlot [
	^ virtualSlot
]

{ #category : #accessing }
SYMLMethod >> virtualSlot: anObject [
	virtualSlot := anObject
]
