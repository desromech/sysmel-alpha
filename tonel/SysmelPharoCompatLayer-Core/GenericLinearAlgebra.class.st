Class {
	#name : #GenericLinearAlgebra,
	#superclass : #Object,
	#classInstVars : [
		'vector2Type',
		'vector3Type',
		'vector4Type',
		'matrix2x2Type',
		'matrix3x3Type',
		'matrix4x4Type'
	],
	#category : #'SysmelPharoCompatLayer-Core-Math'
}

{ #category : #testing }
GenericLinearAlgebra class >> isAbstract [
	^ self == GenericLinearAlgebra
]

{ #category : #accessing }
GenericLinearAlgebra class >> matrix2x2Type [
	^ matrix2x2Type ifNil: [ matrix2x2Type := self scalarType primitiveMatrixWithRows: 2 columns: 2 ]
]

{ #category : #accessing }
GenericLinearAlgebra class >> matrix3x3Type [
	^ matrix3x3Type ifNil: [ matrix3x3Type := self scalarType primitiveMatrixWithRows: 3 columns: 3 ]
]

{ #category : #accessing }
GenericLinearAlgebra class >> matrix4x4Type [
	^ matrix4x4Type ifNil: [ matrix4x4Type := self scalarType primitiveMatrixWithRows: 4 columns: 4 ]
]

{ #category : #accessing }
GenericLinearAlgebra class >> scalarType [
	^ self subclassResponsibility
]

{ #category : #accessing }
GenericLinearAlgebra class >> vector2Type [
	^ vector2Type ifNil: [ vector2Type := self scalarType primitiveVectorWithElements: 2 ]
]

{ #category : #accessing }
GenericLinearAlgebra class >> vector3Type [
	^ vector3Type ifNil: [ vector3Type := self scalarType primitiveVectorWithElements: 3 ]
]

{ #category : #accessing }
GenericLinearAlgebra class >> vector4Type [
	^ vector4Type ifNil: [ vector4Type := self scalarType primitiveVectorWithElements: 4 ]
]
