Class {
	#name : #SysmelPrimitiveMatrixType,
	#superclass : #SysmelPrimitiveType,
	#classInstVars : [
		'columnType',
		'rowType',
		'vector2Type',
		'vector3Type',
		'vector4Type',
		'matrix3x3Type',
		'matrix4x4Type',
		'matrix2x2Type'
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

{ #category : #accessing }
SysmelPrimitiveMatrixType class >> matrix2x2Type [
	^ matrix2x2Type ifNil: [matrix2x2Type := self scalarType primitiveMatrixWithRows: 2 columns: 2]
]

{ #category : #accessing }
SysmelPrimitiveMatrixType class >> matrix3x3Type [
	^ matrix3x3Type ifNil: [matrix3x3Type := self scalarType primitiveMatrixWithRows: 3 columns: 3]
]

{ #category : #accessing }
SysmelPrimitiveMatrixType class >> matrix4x4Type [
	^ matrix4x4Type ifNil: [matrix4x4Type := self scalarType primitiveMatrixWithRows: 4 columns: 4]
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

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrixType class >> validateExplicitCastOfValue: aValue [
	aValue class == self ifTrue: [ ^ aValue ].
	
	aValue class isPrimitiveMatrixType ifTrue: [
		(aValue class rows = self rows and: [ aValue class columns = self columns ]) ifFalse: [
			self error: 'Cannot cast vectors with mismatching number of elements.'
		].
	
		^ aValue collect: [ :each | each castTo: self columnType ] as: self
	].

	^ super validateExplicitCastOfValue: aValue
]

{ #category : #accessing }
SysmelPrimitiveMatrixType class >> vector2Type [
	^ vector2Type ifNil: [vector2Type := self elementType primitiveVectorWithElements: 2]
]

{ #category : #accessing }
SysmelPrimitiveMatrixType class >> vector3Type [
	^ vector3Type ifNil: [vector3Type := self elementType primitiveVectorWithElements: 3]
]

{ #category : #accessing }
SysmelPrimitiveMatrixType class >> vector4Type [
	^ vector4Type ifNil: [vector4Type := self elementType primitiveVectorWithElements: 4]
]

{ #category : #construction }
SysmelPrimitiveMatrixType class >> zeros [
	^ self withAll: self elementType zero
]

{ #category : #arithmetic }
SysmelPrimitiveMatrixType >> * other [
	other isNumber ifTrue: [
		^ self collect: [ :each | each * other ]
	].
	other isPrimitiveVector ifTrue: [
		^ self preMultiplyVector: other
	].

	self assert: other isPrimitiveMatrix.
	self class columns = other class rows ifFalse: [
		self error: 'Mismatching matrix rank for multiplication.'
	].
	^ self multiplyWithMatrix: other
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

{ #category : #converting }
SysmelPrimitiveMatrixType >> adaptToNumber: rcvr andSend: selector [
	^ (rcvr implicitCastTo: self class) perform: selector with: self
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

{ #category : #enumerating }
SysmelPrimitiveMatrixType >> collect: aBlock as: matrixType [
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

{ #category : #testing }
SysmelPrimitiveMatrixType >> isPrimitiveMatrix [
	^ true
]

{ #category : #testing }
SysmelPrimitiveMatrixType >> isZero [
	^ false
]

{ #category : #arithmetic }
SysmelPrimitiveMatrixType >> negated [
	^ self collect: [ :each | each negated ]
]

{ #category : #'memory access' }
SysmelPrimitiveMatrixType >> readBytesFrom: aByteArray position: byteArrayPosition [
	^ self readBytesFrom: aByteArray size: self class instanceSize position: byteArrayPosition
]

{ #category : #arithmetic }
SysmelPrimitiveMatrixType >> sign [
	^ self collect: [ :each | each sign ]
]

{ #category : #arithmetic }
SysmelPrimitiveMatrixType >> sqrt [
	^ self collect: [ :each | each sqrt ]
]

{ #category : #enumerating }
SysmelPrimitiveMatrixType >> with: other collect: aBlock [
	self subclassResponsibility
]
