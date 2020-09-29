"
A SysmelPrimitiveVector3TypeTest is a test class for testing the behavior of SysmelPrimitiveVector3Type
"
Class {
	#name : #SysmelPrimitiveVector3TypeTest,
	#superclass : #SysmelPrimitiveTensorTypeTest,
	#category : #'SysmelPharoCompatLayer-Core-Tests-PrimitiveTypes'
}

{ #category : #accessing }
SysmelPrimitiveVector3TypeTest class >> isAbstract [
	^ self == SysmelPrimitiveVector3TypeTest
]

{ #category : #tests }
SysmelPrimitiveVector3TypeTest >> testAddition [
	self assert: (Vector3 x: 0 y: 0 z: 0) + (Vector3 x: 0 y: 0 z: 0) equals: (Vector3 x: 0 y: 0 z: 0).
	self assert: (Vector3 x: 1 y: 2 z: 3) + (Vector3 x: 0 y: 0 z: 0) equals: (Vector3 x: 1 y: 2 z: 3).
	self assert: (Vector3 x: 1 y: 2 z: 3) + (Vector3 x: 4 y: 5 z: 6) equals: (Vector3 x: 5 y: 7 z: 9).
	self assert: (Vector3 x: 4 y: 5 z: 6) + (Vector3 x: 1 y: 2 z: 3) equals: (Vector3 x: 5 y: 7 z: 9).
]

{ #category : #tests }
SysmelPrimitiveVector3TypeTest >> testCloseTo [
	| a b c |
	a := Vector3 x: 1 y: 2 z: 4.
	b := Vector3 x: 3 y: 4 z: 5.
	c := Vector3 x: 3 y: 4 z: 5.

	self assert: b closeTo: c.
	self deny: (a closeTo: b).
	self assert: a notCloseTo:  b.

	self deny: (a closeTo: c).
	self assert: a notCloseTo: c.
]

{ #category : #tests }
SysmelPrimitiveVector3TypeTest >> testCross [
	self assert: ((Vector3 x: 2 y: 0 z: 0) cross: (Vector3 x: 2 y: 0 z: 0)) equals: Vector3 zeros.
	self assert: ((Vector3 x: 0 y: 2 z: 0) cross: (Vector3 x: 0 y: 2 z: 0)) equals: Vector3 zeros.
	self assert: ((Vector3 x: 0 y: 0 z: 2) cross: (Vector3 x: 0 y: 0 z: 2)) equals: Vector3 zeros.

	self assert: ((Vector3 x: 2 y: 0 z: 0) cross: (Vector3 x: 0 y: 3 z: 0)) equals: (Vector3 x: 0 y: 0 z: 6).
	self assert: ((Vector3 x: 0 y: 2 z: 0) cross: (Vector3 x: 0 y: 0 z: 3)) equals: (Vector3 x: 6 y: 0 z: 0).
	self assert: ((Vector3 x: 0 y: 0 z: 2) cross: (Vector3 x: 3 y: 0 z: 0)) equals: (Vector3 x: 0 y: 6 z: 0).
]

{ #category : #tests }
SysmelPrimitiveVector3TypeTest >> testDivision [
	self assert: (Vector3 x: 1 y: 2 z: 3) / (Vector3 x: 1 y: 1 z: 1) equals: (Vector3 x: 1 y: 2 z: 3).
	self assert: (Vector3 x: 20 y: 9 z: 50) / (Vector3 x: 5 y: 3 z: 10) equals: (Vector3 x: 4 y: 3 z: 5).
]

{ #category : #tests }
SysmelPrimitiveVector3TypeTest >> testDot [
	self assert: ((Vector3 x: 1 y: 2 z: 3) dot: (Vector3 x: 4 y: 7 z: 8)) equals: "4 + 14 + 24" 42.
]

{ #category : #tests }
SysmelPrimitiveVector3TypeTest >> testEquals [
	| a b c |
	a := Vector3 x: 1 y: 2 z: 4.
	b := Vector3 x: 3 y: 4 z: 5.
	c := Vector3 x: 3 y: 4 z: 5.

	self assert: b equals:  c.
	self deny: a = b.
	self deny: a = c.
]

{ #category : #tests }
SysmelPrimitiveVector3TypeTest >> testHash [
	| b c |
	b := Vector3 x: 3 y: 4 z: 5.
	c := Vector3 x: 3 y: 4 z: 5.
	self assert: b hash equals: c hash.
]

{ #category : #tests }
SysmelPrimitiveVector3TypeTest >> testLength [
	Scalar isPrimitiveFloatType ifFalse: [ ^ self skip ].
	self assert: (Vector3 x: 1 y: 2 z: 2) length equals: 3.
]

{ #category : #tests }
SysmelPrimitiveVector3TypeTest >> testLength2 [
	self assert: (Vector3 x: 3 y: 4 z: 5) length2 equals: 50.
]

{ #category : #tests }
SysmelPrimitiveVector3TypeTest >> testMultiplication [
	self assert: (Vector3 x: 0 y: 0 z: 0) * (Vector3 x: 0 y: 0 z: 0) equals: (Vector3 x: 0 y: 0 z: 0).
	self assert: (Vector3 x: 1 y: 2 z: 3) * (Vector3 x: 0 y: 0 z: 0) equals: (Vector3 x: 0 y: 0 z: 0).
	self assert: (Vector3 x: 1 y: 2 z: 3) * (Vector3 x: 1 y: 1 z: 1) equals: (Vector3 x: 1 y: 2 z: 3).
	self assert: (Vector3 x: 2 y: 3 z: 4) * (Vector3 x: 3 y: 5 z: 7) equals: (Vector3 x: 6 y: 15 z: 28).
]

{ #category : #tests }
SysmelPrimitiveVector3TypeTest >> testNegated [
	self assert: (Vector3 x: 1 y: 2 z: 3) negated equals: (Vector3 x: -1 y: -2 z: -3).
]

{ #category : #tests }
SysmelPrimitiveVector3TypeTest >> testNotEquals [
	| a b c |
	a := Vector3 x: 1 y: 2 z: 4.
	b := Vector3 x: 3 y: 4 z: 5.
	c := Vector3 x: 3 y: 4 z: 5.

	self deny: (b ~=  c).
	self assert: a ~= b.
	self assert: a ~= c.
]

{ #category : #tests }
SysmelPrimitiveVector3TypeTest >> testSubtraction [
	self assert: (Vector3 x: 0 y: 0 z: 0) - (Vector3 x: 0 y: 0 z: 0) equals: (Vector3 x: 0 y: 0 z: 0).
	self assert: (Vector3 x: 1 y: 2 z: 3) - (Vector3 x: 0 y: 0 z: 0) equals: (Vector3 x: 1 y: 2 z: 3).
	self assert: (Vector3 x: 1 y: 2 z: 3) - (Vector3 x: 4 y: 6 z: 8) equals: (Vector3 x: -3 y: -4 z: -5).
]
