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

{ #category : #sizes }
SysmelPrimitiveMatrixType class >> instanceAlignment [
	^ self columnType instanceSize
]

{ #category : #sizes }
SysmelPrimitiveMatrixType class >> instanceSize [
	^ self columnType alignedInstanceSize * self columns
]

{ #category : #testing }
SysmelPrimitiveMatrixType class >> isAbstract [
	^ self == SysmelPrimitiveMatrixType
]

{ #category : #testing }
SysmelPrimitiveMatrixType class >> isPrimitiveMatrixType [
	^ true
]

{ #category : #'instance creation' }
SysmelPrimitiveMatrixType class >> new [
	^ self zeros
]

{ #category : #construction }
SysmelPrimitiveMatrixType class >> ones [
	^ self withAll: self elementType one
]

{ #category : #accessing }
SysmelPrimitiveMatrixType class >> rowType [
	^ rowType ifNil: [ rowType := self elementType primitiveVectorWithElements: self rows ]
]

{ #category : #accessing }
SysmelPrimitiveMatrixType class >> rows [
	self subclassResponsibility
]

{ #category : #construction }
SysmelPrimitiveMatrixType class >> zeros [
	^ self withAll: self elementType zero
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

{ #category : #accessing }
SysmelPrimitiveMatrixType >> at: columnIndex [
	self subclassResponsibility
]

{ #category : #arithmetic }
SysmelPrimitiveMatrixType >> ceiling [
	^ self collect: [ :each | each ceiling ]
]

{ #category : #enumerating }
SysmelPrimitiveMatrixType >> collect: aBlock [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrixType >> elementAtRow: row column: column [
	^ (self at: column) at: row
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
