Class {
	#name : #GenericLinearAlgebraTest,
	#superclass : #SysmelPrimitiveTensorTypeTest,
	#instVars : [
		'Complex',
		'Quaternion',
		'ReversibleAffineTransform3d'
	],
	#classInstVars : [
		'complexType',
		'quaternionType',
		'reversibleAffineTransform3dType'
	],
	#category : #'SysmelPharoCompatLayer-Core-Tests-LinearAlgebra'
}

{ #category : #accessing }
GenericLinearAlgebraTest class >> complexType [
	^ complexType ifNil: [ complexType := self environment at: (#Complex , self scalarType shortCapitalTypeSuffix) asSymbol ]
]

{ #category : #accessing }
GenericLinearAlgebraTest class >> isAbstract [
	^ self == GenericLinearAlgebraTest
]

{ #category : #accessing }
GenericLinearAlgebraTest class >> quaternionType [
	^ quaternionType ifNil: [ quaternionType := self environment at: (#Quaternion , self scalarType shortCapitalTypeSuffix) asSymbol ]
]

{ #category : #accessing }
GenericLinearAlgebraTest class >> reversibleAffineTransform3dType [
	^ reversibleAffineTransform3dType ifNil: [ reversibleAffineTransform3dType := self environment at: (#ReversibleAffineTransform3d , self scalarType shortCapitalTypeSuffix) asSymbol ]
]

{ #category : #running }
GenericLinearAlgebraTest >> setUp [
	super setUp.
	Complex := self class complexType.
	Quaternion := self class quaternionType.
	ReversibleAffineTransform3d := self class reversibleAffineTransform3dType.
	
]
