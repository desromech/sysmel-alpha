Class {
	#name : #SysmelPrimitiveMatrixType,
	#superclass : #SysmelPrimitiveType,
	#classInstVars : [
		'columnType',
		'rowType'
	],
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #accessing }
SysmelPrimitiveMatrixType class >> columnType [
	^ columnType ifNil: [ columnType := self elementType primitiveVectorWithElements: self rows ]
]

{ #category : #accessing }
SysmelPrimitiveMatrixType class >> columns [
	self subclassResponsibility
]

{ #category : #accessing }
SysmelPrimitiveMatrixType class >> elementType [
	self subclassResponsibility
]

{ #category : #testing }
SysmelPrimitiveMatrixType class >> isAbstract [
	^ self == SysmelPrimitiveMatrixType
]

{ #category : #accessing }
SysmelPrimitiveMatrixType class >> rowType [
	^ rowType ifNil: [ rowType := self elementType primitiveVectorWithElements: self rows ]
]

{ #category : #accessing }
SysmelPrimitiveMatrixType class >> rows [
	self subclassResponsibility
]

{ #category : #arithmetic }
SysmelPrimitiveMatrixType >> + other [
	^ self with: other collect: [ :a :b | a + b ]
]

{ #category : #arithmetic }
SysmelPrimitiveMatrixType >> - other [
	^ self with: other collect: [ :a :b | a - b ]
]

{ #category : #arithmetic }
SysmelPrimitiveMatrixType >> abs [
	^ self collect: [ :each | each abs ]
]

{ #category : #arithmetic }
SysmelPrimitiveMatrixType >> ceiling [
	^ self collect: [ :each | each ceiling ]
]

{ #category : #enumerating }
SysmelPrimitiveMatrixType >> collect: aBlock [
	self subclassResponsibility
]

{ #category : #arithmetic }
SysmelPrimitiveMatrixType >> floor [
	^ self collect: [ :each | each floor ]
]

{ #category : #arithmetic }
SysmelPrimitiveMatrixType >> negated [
	^ self collect: [ :each | each negated ]
]

{ #category : #arithmetic }
SysmelPrimitiveMatrixType >> sqrt [
	^ self collect: [ :each | each sqrt ]
]

{ #category : #enumerating }
SysmelPrimitiveMatrixType >> with: other collect: aBlock [
	self subclassResponsibility
]
