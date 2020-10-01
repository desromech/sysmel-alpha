Class {
	#name : #GenericQuaternionTest,
	#superclass : #GenericLinearAlgebraTest,
	#category : #'SysmelPharoCompatLayer-Core-Tests-LinearAlgebra'
}

{ #category : #accessing }
GenericQuaternionTest class >> isAbstract [
	^ self == GenericQuaternionTest
]

{ #category : #tests }
GenericQuaternionTest >> testAbsolute [
	self assert: (Quaternion r: 2 i: 2 j: 2 k: 2) abs equals: 4.
]

{ #category : #tests }
GenericQuaternionTest >> testAddition [
	self assert: (Quaternion r: 0 i: 0 j: 0 k: 0) + (Quaternion r: 0 i: 0 j: 0 k: 0) equals: (Quaternion r: 0 i: 0 j: 0 k: 0).
	self assert: (Quaternion r: 1 i: 2 j: 3 k: 4) + (Quaternion r: 0 i: 0 j: 0 k: 0) equals: (Quaternion r: 1 i: 2 j: 3 k: 4).
	self assert: (Quaternion r: 1 i: 2 j: 3 k: 4) + (Quaternion r: 5 i: 6 j: 7 k: 8) equals: (Quaternion r: 6 i: 8 j: 10 k: 12).
	self assert: (Quaternion r: 5 i: 6 j: 7 k: 8) + (Quaternion r: 1 i: 2 j: 3 k: 4) equals: (Quaternion r: 6 i: 8 j: 10 k: 12).
]

{ #category : #tests }
GenericQuaternionTest >> testAsMatrix [
	self assert: Quaternion identity asMatrix3x3 closeTo: Matrix3x3 identity.
	self assert: (Quaternion xRotation: 1) asMatrix3x3 closeTo: (Matrix3x3 xRotation: 1).
	self assert: (Quaternion yRotation: 1) asMatrix3x3 closeTo: (Matrix3x3 yRotation: 1).
	self assert: (Quaternion zRotation: 1) asMatrix3x3 closeTo: (Matrix3x3 zRotation: 1).
	self assert: (Quaternion xyzRotation: (Vector3 x: 1 y: 2 z: 3)) asMatrix3x3 closeTo: (Matrix3x3 xyzRotation: (Vector3 x: 1 y: 2 z: 3)).
	self assert: (Quaternion zyxRotation: (Vector3 x: 1 y: 2 z: 3)) asMatrix3x3 closeTo: (Matrix3x3 zyxRotation: (Vector3 x: 1 y: 2 z: 3)).
]

{ #category : #tests }
GenericQuaternionTest >> testCloseTo [
	| a b c |
	a := Quaternion x: 1 y: 2 z: 4 w: 5.
	b := Quaternion x: 3 y: 4 z: 5 w: 6.
	c := Quaternion x: 3 y: 4 z: 5 w: 6.

	self assert: b closeTo: c.
	self deny: (a closeTo: b).
	self assert: a notCloseTo:  b.

	self deny: (a closeTo: c).
	self assert: a notCloseTo: c.
]

{ #category : #tests }
GenericQuaternionTest >> testConjugated [
	self assert: (Quaternion r: 1 i: 2 j: 3 k: 4) conjugated equals: (Quaternion r: 1 i: -2 j: -3 k: -4).
	self assert: (Quaternion r: 1 i: 2 j: 3 k: 4) conjugated xyzw equals: (Vector4 x: -2 y: -3 z: -4 w: 1).
]

{ #category : #tests }
GenericQuaternionTest >> testDivision [
	self assert: (Quaternion r: 1 i: 2 j: 3 k: 4) / Quaternion one equals: (Quaternion r: 1 i: 2 j: 3 k: 4).
	self assert: (Quaternion r: 20 i: 9 j: 50 k: 49) / (Quaternion r: 20 i: 9 j: 50 k: 49) closeTo: Quaternion one.
]

{ #category : #tests }
GenericQuaternionTest >> testDot [
	self assert: ((Quaternion r: 1 i: 2 j: 3 k: 4) dot: (Quaternion r: 4 i: 7 j: 8 k: 9)) equals: "4 + 14 + 24 + 36" 78.
]

{ #category : #tests }
GenericQuaternionTest >> testEquals [
	| a b c |
	a := Quaternion x: 1 y: 2 z: 4 w: 5.
	b := Quaternion x: 3 y: 4 z: 5 w: 6.
	c := Quaternion x: 3 y: 4 z: 5 w: 6.

	self assert: b equals:  c.
	self deny: a = b.
	self deny: a = c.
]

{ #category : #tests }
GenericQuaternionTest >> testHash [
	| b c |
	b := Quaternion x: 3 y: 4 z: 5 w: 6.
	c := Quaternion x: 3 y: 4 z: 5 w: 6.
	self assert: b hash equals: c hash.
]

{ #category : #tests }
GenericQuaternionTest >> testIdentity [
	self assert: Quaternion identity equals: (Quaternion r: 1 i: 0 j: 0 k: 0).
	self assert: Quaternion identity xyzw equals: (Vector4 x: 0 y: 0 z: 0 w: 1).
]

{ #category : #tests }
GenericQuaternionTest >> testLength [
	self assert: (Quaternion r: 2 i: 2 j: 2 k: 2) length equals: 4.
]

{ #category : #tests }
GenericQuaternionTest >> testLength2 [
	self assert: (Quaternion r: 2 i: 2 j: 2 k: 2) length2 equals: 16.
]

{ #category : #tests }
GenericQuaternionTest >> testMultiplication [
	self assert: (Quaternion r: 1 i: 2 j: 3 k: 4) * (Quaternion r: 20 i: 31 j: 41 k: 51) equals: (Quaternion r: -369 i: 60 j: 123 k: 120).
]

{ #category : #tests }
GenericQuaternionTest >> testMultiplicationScalar [
	self assert: (Quaternion r: 0 i: 0 j: 0 k: 0) * (Quaternion r: 0 i: 0 j: 0 k: 0) equals: (Quaternion r: 0 i: 0 j: 0 k: 0).
	self assert: (Quaternion r: 1 i: 2 j: 3 k: 4) * (Quaternion r: 0 i: 0 j: 0 k: 0) equals: (Quaternion r: 0 i: 0 j: 0 k: 0).
	self assert: (Quaternion r: 1 i: 2 j: 3 k: 4) * 0 equals: (Quaternion r: 0 i: 0 j: 0 k: 0).

	self assert: (Quaternion r: 0 i: 0 j: 0 k: 0) * (Quaternion r: 1 i: 0 j: 0 k: 0) equals: (Quaternion r: 0 i: 0 j: 0 k: 0).
	self assert: (Quaternion r: 1 i: 2 j: 3 k: 4) * (Quaternion r: 1 i: 0 j: 0 k: 0) equals: (Quaternion r: 1 i: 2 j: 3 k: 4).
	self assert: (Quaternion r: 1 i: 2 j: 3 k: 4) * 1 equals: (Quaternion r: 1 i: 2 j: 3 k: 4).

	self assert: (Quaternion r: 0 i: 0 j: 0 k: 0) * (Quaternion r: 3 i: 0 j: 0 k: 0) equals: (Quaternion r: 0 i: 0 j: 0 k: 0).
	self assert: (Quaternion r: 1 i: 2 j: 3 k: 4) * (Quaternion r: 3 i: 0 j: 0 k: 0) equals: (Quaternion r: 3 i: 6 j: 9 k: 12).
	self assert: (Quaternion r: 1 i: 2 j: 3 k: 4) * 3 equals: (Quaternion r: 3 i: 6 j: 9 k: 12).
]

{ #category : #tests }
GenericQuaternionTest >> testNegated [
	self assert: (Quaternion r: 1 i: 2 j: 3 k: 4) negated equals: (Quaternion r: -1 i: -2 j: -3 k: -4).
]

{ #category : #tests }
GenericQuaternionTest >> testNotEquals [
	| a b c |
	a := Quaternion x: 1 y: 2 z: 4 w: 5.
	b := Quaternion x: 3 y: 4 z: 5 w: 6.
	c := Quaternion x: 3 y: 4 z: 5 w: 6.

	self deny: (b ~=  c).
	self assert: a ~= b.
	self assert: a ~= c.
]

{ #category : #tests }
GenericQuaternionTest >> testOne [
	self assert: Quaternion one equals: (Quaternion r: 1 i: 0 j: 0 k: 0).
	self assert: Quaternion one xyzw equals: (Vector4 x: 0 y: 0 z: 0 w: 1).
]

{ #category : #tests }
GenericQuaternionTest >> testSubtraction [
	self assert: (Quaternion r: 0 i: 0 j: 0 k: 0) - (Quaternion r: 0 i: 0 j: 0 k: 0) equals: (Quaternion r: 0 i: 0 j: 0 k: 0).
	self assert: (Quaternion r: 1 i: 2 j: 3 k: 4) - (Quaternion r: 0 i: 0 j: 0 k: 0) equals: (Quaternion r: 1 i: 2 j: 3 k: 4).
	self assert: (Quaternion r: 1 i: 2 j: 3 k: 4) - (Quaternion r: 10 i: 12 j: 14 k: 20) equals: (Quaternion r: -9 i: -10 j: -11 k: -16).
]

{ #category : #tests }
GenericQuaternionTest >> testZero [
	self assert: Quaternion zero equals: (Quaternion x: 0 y: 0 z: 0 w: 0).
]
