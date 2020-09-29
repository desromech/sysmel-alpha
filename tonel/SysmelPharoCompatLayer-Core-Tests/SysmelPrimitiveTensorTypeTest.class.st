Class {
	#name : #SysmelPrimitiveTensorTypeTest,
	#superclass : #TestCase,
	#instVars : [
		'Scalar',
		'Vector2',
		'Vector3',
		'Vector4',
		'Matrix2x2',
		'Matrix3x3',
		'Matrix4x4'
	],
	#category : #'SysmelPharoCompatLayer-Core-Tests-PrimitiveTypes'
}

{ #category : #accessing }
SysmelPrimitiveTensorTypeTest class >> isAbstract [
	^ self == SysmelPrimitiveTensorTypeTest
]

{ #category : #accessing }
SysmelPrimitiveTensorTypeTest class >> matrix2x2Type [
	^ self scalarType primitiveMatrixWithRows: 2 columns: 2
]

{ #category : #accessing }
SysmelPrimitiveTensorTypeTest class >> matrix3x3Type [
	^ self scalarType primitiveMatrixWithRows: 3 columns: 3
]

{ #category : #accessing }
SysmelPrimitiveTensorTypeTest class >> matrix4x4Type [
	^ self scalarType primitiveMatrixWithRows: 4 columns: 4
]

{ #category : #accessing }
SysmelPrimitiveTensorTypeTest class >> scalarType [
	self subclassResponsibility
]

{ #category : #accessing }
SysmelPrimitiveTensorTypeTest class >> vector2Type [
	^ self scalarType primitiveVectorWithElements: 2
]

{ #category : #accessing }
SysmelPrimitiveTensorTypeTest class >> vector3Type [
	^ self scalarType primitiveVectorWithElements: 3
]

{ #category : #accessing }
SysmelPrimitiveTensorTypeTest class >> vector4Type [
	^ self scalarType primitiveVectorWithElements: 4
]

{ #category : #running }
SysmelPrimitiveTensorTypeTest >> setUp [
	super setUp.
	Scalar := self class scalarType.
	Vector2 := self class vector2Type.
	Vector3 := self class vector3Type.
	Vector4 := self class vector4Type.
	Matrix2x2 := self class matrix2x2Type.
	Matrix3x3 := self class matrix3x3Type.
	Matrix4x4 := self class matrix4x4Type.
]
