Class {
	#name : #GenericReversibleAffineTransform3dTest,
	#superclass : #GenericLinearAlgebraTest,
	#category : #'SysmelPharoCompatLayer-Core-Tests-LinearAlgebra'
}

{ #category : #accessing }
GenericReversibleAffineTransform3dTest class >> isAbstract [
	^ self == GenericReversibleAffineTransform3dTest
]

{ #category : #tests }
GenericReversibleAffineTransform3dTest >> testIdentity [
	| transform |
	transform := ReversibleAffineTransform3d identity.
	self assert: transform matrix4 equals: Matrix4x4 identity.
	self assert: transform matrix equals: Matrix3x3 identity.
	self assert: transform translation equals: Vector3 zeros.

	self assert: transform inverseMatrix4 equals: Matrix4x4 identity.
	self assert: transform inverseMatrix equals: Matrix3x3 identity.
	self assert: transform inverseTranslation equals: Vector3 zeros.

	self assert: transform isIdentity.
]

{ #category : #tests }
GenericReversibleAffineTransform3dTest >> testSetIdentity [
	| transform |
	transform := ReversibleAffineTransform3d new setIdentity; yourself.
	self assert: transform matrix4 equals: Matrix4x4 identity.
	self assert: transform translation equals: Vector3 zeros.

	self assert: transform inverseMatrix4 equals: Matrix4x4 identity.
	self assert: transform inverseTranslation equals: Vector3 zeros.

	self assert: transform isIdentity.
]
