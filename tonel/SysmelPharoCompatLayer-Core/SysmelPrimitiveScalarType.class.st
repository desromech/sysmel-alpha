Class {
	#name : #SysmelPrimitiveScalarType,
	#superclass : #SysmelPrimitiveType,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #testing }
SysmelPrimitiveScalarType class >> isAbstract [
	^ self == SysmelPrimitiveScalarType
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveScalarType class >> newFromBytes: aByteArray position: byteArrayPosition [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveScalarType class >> primitiveCompactVectorWithElements: elementCount [
	| vectorTypeName |
	elementCount ~= 3 ifTrue: [ ^ self primitiveVectorWithElements: elementCount ].
	vectorTypeName := ('Compact' , self name , 'x' , elementCount asString) asSymbol.
	^ self environment at: vectorTypeName
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveScalarType class >> primitiveMatrixWithRows: rows columns: columns [
	| vectorTypeName |
	vectorTypeName := (self name , 'x' , rows asString , 'x' , columns asString) asSymbol.
	^ self environment at: vectorTypeName
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveScalarType class >> primitiveVectorWithElements: elementCount [
	| vectorTypeName |
	vectorTypeName := (self name , 'x' , elementCount asString) asSymbol.
	^ self environment at: vectorTypeName
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveScalarType class >> storeValue: value bytesIn: aByteArray position: byteArrayPosition [
	^ self subclassResponsibility
]

{ #category : #'memory access' }
SysmelPrimitiveScalarType >> readBytesFrom: aByteArray position: byteArrayPosition [
	^ self shouldNotImplement
]

{ #category : #'memory access' }
SysmelPrimitiveScalarType >> readBytesFrom: aByteArray size: readSize position: byteArrayPosition [
	^ self shouldNotImplement
]

{ #category : #'memory access' }
SysmelPrimitiveScalarType >> storeBytesIn: aByteArray position: byteArrayPosition [
	^ self subclassResponsibility
]
