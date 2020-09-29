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
