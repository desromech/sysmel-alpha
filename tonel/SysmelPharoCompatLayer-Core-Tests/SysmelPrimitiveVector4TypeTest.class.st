"
A SysmelPrimitiveVector4TypeTest is a test class for testing the behavior of SysmelPrimitiveVector4Type
"
Class {
	#name : #SysmelPrimitiveVector4TypeTest,
	#superclass : #SysmelPrimitiveTensorTypeTest,
	#category : #'SysmelPharoCompatLayer-Core-Tests-PrimitiveTypes'
}

{ #category : #accessing }
SysmelPrimitiveVector4TypeTest class >> isAbstract [
	^ self == SysmelPrimitiveVector4TypeTest
]

{ #category : #tests }
SysmelPrimitiveVector4TypeTest >> testAddition [
	self assert: (Vector4 x: 0 y: 0 z: 0 w: 0) + (Vector4 x: 0 y: 0 z: 0 w: 0) equals: (Vector4 x: 0 y: 0 z: 0 w: 0).
	self assert: (Vector4 x: 1 y: 2 z: 3 w: 4) + (Vector4 x: 0 y: 0 z: 0 w: 0) equals: (Vector4 x: 1 y: 2 z: 3 w: 4).
	self assert: (Vector4 x: 1 y: 2 z: 3 w: 4) + (Vector4 x: 5 y: 6 z: 7 w: 8) equals: (Vector4 x: 6 y: 8 z: 10 w: 12).
	self assert: (Vector4 x: 5 y: 6 z: 7 w: 8) + (Vector4 x: 1 y: 2 z: 3 w: 4) equals: (Vector4 x: 6 y: 8 z: 10 w: 12).
]

{ #category : #tests }
SysmelPrimitiveVector4TypeTest >> testCloseTo [
	| a b c |
	a := Vector4 x: 1 y: 2 z: 4 w: 5.
	b := Vector4 x: 3 y: 4 z: 5 w: 6.
	c := Vector4 x: 3 y: 4 z: 5 w: 6.

	self assert: b closeTo: c.
	self deny: (a closeTo: b).
	self assert: a notCloseTo:  b.

	self deny: (a closeTo: c).
	self assert: a notCloseTo: c.
]

{ #category : #tests }
SysmelPrimitiveVector4TypeTest >> testDivision [
	self assert: (Vector4 x: 1 y: 2 z: 3 w: 4) / (Vector4 x: 1 y: 1 z: 1 w: 1) equals: (Vector4 x: 1 y: 2 z: 3 w: 4).
	self assert: (Vector4 x: 20 y: 9 z: 50 w: 49) / (Vector4 x: 5 y: 3 z: 10 w: 7) equals: (Vector4 x: 4 y: 3 z: 5 w: 7).
]

{ #category : #tests }
SysmelPrimitiveVector4TypeTest >> testDot [
	self assert: ((Vector4 x: 1 y: 2 z: 3 w: 4) dot: (Vector4 x: 4 y: 7 z: 8 w: 9)) equals: "4 + 14 + 24 + 36" 78.
]

{ #category : #tests }
SysmelPrimitiveVector4TypeTest >> testEquals [
	| a b c |
	a := Vector4 x: 1 y: 2 z: 4 w: 5.
	b := Vector4 x: 3 y: 4 z: 5 w: 6.
	c := Vector4 x: 3 y: 4 z: 5 w: 6.

	self assert: b equals:  c.
	self deny: a = b.
	self deny: a = c.
]

{ #category : #tests }
SysmelPrimitiveVector4TypeTest >> testHash [
	| b c |
	b := Vector4 x: 3 y: 4 z: 5 w: 6.
	c := Vector4 x: 3 y: 4 z: 5 w: 6.
	self assert: b hash equals: c hash.
]

{ #category : #tests }
SysmelPrimitiveVector4TypeTest >> testLength [
	Scalar isPrimitiveFloatType ifFalse: [ ^ self skip ].
	self assert: (Vector4 x: 2 y: 2 z: 2 w: 2) length equals: 4.
]

{ #category : #tests }
SysmelPrimitiveVector4TypeTest >> testLength2 [
	self assert: (Vector4 x: 2 y: 2 z: 2 w: 2) length2 equals: 16.
]

{ #category : #tests }
SysmelPrimitiveVector4TypeTest >> testMultiplication [
	self assert: (Vector4 x: 0 y: 0 z: 0 w: 0) * (Vector4 x: 0 y: 0 z: 0 w: 0) equals: (Vector4 x: 0 y: 0 z: 0 w: 0).
	self assert: (Vector4 x: 1 y: 2 z: 3 w: 4) * (Vector4 x: 0 y: 0 z: 0 w: 0) equals: (Vector4 x: 0 y: 0 z: 0 w: 0).
	self assert: (Vector4 x: 1 y: 2 z: 3 w: 4) * (Vector4 x: 1 y: 1 z: 1 w: 1) equals: (Vector4 x: 1 y: 2 z: 3 w: 4).
	self assert: (Vector4 x: 2 y: 3 z: 4 w: 5) * (Vector4 x: 3 y: 5 z: 7 w: 9) equals: (Vector4 x: 6 y: 15 z: 28 w: 45).
]

{ #category : #tests }
SysmelPrimitiveVector4TypeTest >> testNegated [
	self assert: (Vector4 x: 1 y: 2 z: 3 w: 4) negated equals: (Vector4 x: -1 y: -2 z: -3 w: -4).
]

{ #category : #tests }
SysmelPrimitiveVector4TypeTest >> testNotEquals [
	| a b c |
	a := Vector4 x: 1 y: 2 z: 4 w: 5.
	b := Vector4 x: 3 y: 4 z: 5 w: 6.
	c := Vector4 x: 3 y: 4 z: 5 w: 6.

	self deny: (b ~= c).
	self assert: a ~= b.
	self assert: a ~= c.
]

{ #category : #tests }
SysmelPrimitiveVector4TypeTest >> testSubtraction [
	self assert: (Vector4 x: 0 y: 0 z: 0 w: 0) - (Vector4 x: 0 y: 0 z: 0 w: 0) equals: (Vector4 x: 0 y: 0 z: 0 w: 0).
	self assert: (Vector4 x: 1 y: 2 z: 3 w: 4) - (Vector4 x: 0 y: 0 z: 0 w: 0) equals: (Vector4 x: 1 y: 2 z: 3 w: 4).
	self assert: (Vector4 x: 1 y: 2 z: 3 w: 4) - (Vector4 x: 10 y: 12 z: 14 w: 20) equals: (Vector4 x: -9 y: -10 z: -11 w: -16).
]
