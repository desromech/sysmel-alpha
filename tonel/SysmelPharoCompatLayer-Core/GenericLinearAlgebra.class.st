Class {
	#name : #GenericLinearAlgebra,
	#superclass : #SysmelGenericStructureType,
	#classInstVars : [
		'vector2Type',
		'vector3Type',
		'vector4Type',
		'matrix2x2Type',
		'matrix3x3Type',
		'matrix4x4Type',
		'reversibleAffineTransform3dType',
		'complexType',
		'quaternionType',
		'decomposedTransform3dType'
	],
	#category : #'SysmelPharoCompatLayer-Core-Math'
}

{ #category : #accessing }
GenericLinearAlgebra class >> complexType [
	^ complexType ifNil: [ complexType := self environment at: (#Complex , self scalarType shortCapitalTypeSuffix) asSymbol ]
]

{ #category : #accessing }
GenericLinearAlgebra class >> decomposedTransform3dType [
	^ decomposedTransform3dType ifNil: [ decomposedTransform3dType := self environment at: (#DecomposedTransform3d , self scalarType shortCapitalTypeSuffix) asSymbol ]
]

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
GenericLinearAlgebra class >> quaternionType [
	^ quaternionType ifNil: [ quaternionType := self environment at: (#Quaternion , self scalarType shortCapitalTypeSuffix) asSymbol ]
]

{ #category : #accessing }
GenericLinearAlgebra class >> reversibleAffineTransform3dType [
	^ reversibleAffineTransform3dType ifNil: [ reversibleAffineTransform3dType := self environment at: (#ReversibleAffineTransform3d , self scalarType shortCapitalTypeSuffix) asSymbol ]
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
