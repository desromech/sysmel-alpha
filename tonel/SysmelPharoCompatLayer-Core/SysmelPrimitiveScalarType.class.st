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
SysmelPrimitiveScalarType class >> primitiveVectorWithElements: elementCount [
	| vectorTypeName |
	vectorTypeName := (self name , 'x' , elementCount asString) asSymbol.
	^ self environment at: vectorTypeName
]
