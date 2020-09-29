"
A SysmelPrimitiveVector2TypeTest is a test class for testing the behavior of SysmelPrimitiveVector2Type
"
Class {
	#name : #SysmelPrimitiveVector2TypeTest,
	#superclass : #SysmelPrimitiveTensorTypeTest,
	#category : #'SysmelPharoCompatLayer-Core-Tests-PrimitiveTypes'
}

{ #category : #accessing }
SysmelPrimitiveVector2TypeTest class >> isAbstract [
	^ self == SysmelPrimitiveVector2TypeTest
]

{ #category : #tests }
SysmelPrimitiveVector2TypeTest >> testAbsolute [
	self assert: (Vector2 x: 0 y: 1) abs equals: (Vector2 x: 0 y: 1).
	self assert: (Vector2 x: 0 y: -1) abs equals: (Vector2 x: 0 y: 1).
	self assert: (Vector2 x: 1 y: 0) abs equals: (Vector2 x: 1 y: 0).
	self assert: (Vector2 x: -1 y: 0) abs equals: (Vector2 x: 1 y: 0).
	self assert: (Vector2 x: 2 y: 3) abs equals: (Vector2 x: 2 y: 3).
	self assert: (Vector2 x: -2 y: 3) abs equals: (Vector2 x: 2 y: 3).
	self assert: (Vector2 x: 2 y: -3) abs equals: (Vector2 x: 2 y: 3).
	self assert: (Vector2 x: -2 y: -3) abs equals: (Vector2 x: 2 y: 3).
]

{ #category : #tests }
SysmelPrimitiveVector2TypeTest >> testAddition [
	self assert: (Vector2 x: 0 y: 0) + (Vector2 x: 0 y: 0) equals: (Vector2 x: 0 y: 0).
	self assert: (Vector2 x: 1 y: 2) + (Vector2 x: 0 y: 0) equals: (Vector2 x: 1 y: 2).
	self assert: (Vector2 x: 1 y: 2) + (Vector2 x: 3 y: 4) equals: (Vector2 x: 4 y: 6).
	self assert: (Vector2 x: 3 y: 4) + (Vector2 x: 1 y: 2) equals: (Vector2 x: 4 y: 6).
]

{ #category : #tests }
SysmelPrimitiveVector2TypeTest >> testCloseTo [
	| a b c |
	a := Vector2 x: 1 y: 2.
	b := Vector2 x: 3 y: 4.
	c := Vector2 x: 3 y: 4.

	self assert: b closeTo:  c.
 	self deny: (a closeTo: b).
	self assert: a notCloseTo: b.

	self deny: (a closeTo: c).
	self assert: a notCloseTo: c.
]

{ #category : #tests }
SysmelPrimitiveVector2TypeTest >> testConstruction [
	| vector |
	vector := Vector2 x: 2 y: 3.
	self assert: vector x equals: 2.
	self assert: vector y equals: 3.
	self assert: vector equals: (Vector2 x: 2 y: 3).
]

{ #category : #tests }
SysmelPrimitiveVector2TypeTest >> testCross [
	self assert: ((Vector2 x: 1 y: 2) cross: (Vector2 x: 3 y: 7)) equals: "7 - 6" 1.
]

{ #category : #tests }
SysmelPrimitiveVector2TypeTest >> testDivision [
	self assert: (Vector2 x: 1 y: 2) / (Vector2 x: 1 y: 1) equals: (Vector2 x: 1 y: 2).
	self assert: (Vector2 x: 20 y: 9) / (Vector2 x: 5 y: 3) equals: (Vector2 x: 4 y: 3).
]

{ #category : #tests }
SysmelPrimitiveVector2TypeTest >> testDot [
	self assert: ((Vector2 x: 1 y: 2) dot: (Vector2 x: 4 y: 7)) equals: "4 + 14" 18.
]

{ #category : #tests }
SysmelPrimitiveVector2TypeTest >> testEquals [
	| a b c |
	a := Vector2 x: 1 y: 2.
	b := Vector2 x: 3 y: 4.
	c := Vector2 x: 3 y: 4.

	self assert: b equals: c.
	self deny: a = b.
	self deny: a = c.
]

{ #category : #tests }
SysmelPrimitiveVector2TypeTest >> testGreaterOrEqual [
	self assert: (Vector2 x: 0 y: 0) >= (Vector2 x: 0 y: 0).
	self deny: (Vector2 x: 0 y: 0) >= (Vector2 x: 1 y: 0).
	self assert: (Vector2 x: 1 y: 0) >= (Vector2 x: 0 y: 0).

	self deny: (Vector2 x: 0 y: 0) >= (Vector2 x: 0 y: 1).
	self assert: (Vector2 x: 0 y: 1) >= (Vector2 x: 0 y: 0).
	self assert: (Vector2 x: 0 y: 1) >= (Vector2 x: 0 y: 1).
]

{ #category : #tests }
SysmelPrimitiveVector2TypeTest >> testGreaterThan [
	self deny: (Vector2 x: 0 y: 0) > (Vector2 x: 0 y: 0).
	self deny: (Vector2 x: 0 y: 0) > (Vector2 x: 1 y: 0).
	self assert: (Vector2 x: 1 y: 0) > (Vector2 x: 0 y: 0).

	self deny: (Vector2 x: 0 y: 0) > (Vector2 x: 0 y: 1).
	self assert: (Vector2 x: 0 y: 1) > (Vector2 x: 0 y: 0).
	self deny: (Vector2 x: 0 y: 1) > (Vector2 x: 0 y: 1).
]

{ #category : #tests }
SysmelPrimitiveVector2TypeTest >> testHash [
	| b c |
	b := Vector2 x: 3 y: 4.
	c := Vector2 x: 3 y: 4.
	self assert: b hash equals: c hash.
]

{ #category : #tests }
SysmelPrimitiveVector2TypeTest >> testLength [
	Scalar isPrimitiveFloatType ifFalse: [ ^ self skip ].
	self assert: (Vector2 x: 3 y: 4) length equals: 5.
]

{ #category : #tests }
SysmelPrimitiveVector2TypeTest >> testLength2 [
	self assert: (Vector2 x: 3 y: 4) length2 equals: 25.
]

{ #category : #tests }
SysmelPrimitiveVector2TypeTest >> testLessOrEqual [
	self assert: (Vector2 x: 0 y: 0) <= (Vector2 x: 0 y: 0).
	self assert: (Vector2 x: 0 y: 0) <= (Vector2 x: 1 y: 0).
	self deny: (Vector2 x: 1 y: 0) <= (Vector2 x: 0 y: 0).

	self assert: (Vector2 x: 0 y: 0) <= (Vector2 x: 0 y: 1).
	self deny: (Vector2 x: 0 y: 1) <= (Vector2 x: 0 y: 0).
	self assert: (Vector2 x: 0 y: 1) <= (Vector2 x: 0 y: 1).
]

{ #category : #tests }
SysmelPrimitiveVector2TypeTest >> testLessThan [
	self deny: (Vector2 x: 0 y: 0) < (Vector2 x: 0 y: 0).
	self assert: (Vector2 x: 0 y: 0) < (Vector2 x: 1 y: 0).
	self deny: (Vector2 x: 1 y: 0) < (Vector2 x: 0 y: 0).

	self assert: (Vector2 x: 0 y: 0) < (Vector2 x: 0 y: 1).
	self deny: (Vector2 x: 0 y: 1) < (Vector2 x: 0 y: 0).
	self deny: (Vector2 x: 0 y: 1) < (Vector2 x: 0 y: 1).
]

{ #category : #tests }
SysmelPrimitiveVector2TypeTest >> testMultiplication [
	self assert: (Vector2 x: 0 y: 0) * (Vector2 x: 0 y: 0) equals: (Vector2 x: 0 y: 0).
	self assert: (Vector2 x: 1 y: 2) * (Vector2 x: 0 y: 0) equals: (Vector2 x: 0 y: 0).
	self assert: (Vector2 x: 1 y: 2) * (Vector2 x: 1 y: 1) equals: (Vector2 x: 1 y: 2).
	self assert: (Vector2 x: 2 y: 3) * (Vector2 x: 3 y: 5) equals: (Vector2 x: 6 y: 15).
]

{ #category : #tests }
SysmelPrimitiveVector2TypeTest >> testNegated [
	self assert: (Vector2 x: 1 y: 2) negated equals: (Vector2 x: -1 y: -2).
]

{ #category : #tests }
SysmelPrimitiveVector2TypeTest >> testNotEquals [
	| a b c |
	a := Vector2 x: 1 y: 2.
	b := Vector2 x: 3 y: 4.
	c := Vector2 x: 3 y: 4.

	self deny: (b ~=  c).
	self assert: a ~= b.
	self assert: a ~= c.
]

{ #category : #tests }
SysmelPrimitiveVector2TypeTest >> testOnes [
	self assert: Vector2 ones equals: (Vector2 x: 1 y: 1).
]

{ #category : #tests }
SysmelPrimitiveVector2TypeTest >> testSubtraction [
	self assert: (Vector2 x: 0 y: 0) - (Vector2 x: 0 y: 0) equals: (Vector2 x: 0 y: 0).
	self assert: (Vector2 x: 1 y: 2) - (Vector2 x: 0 y: 0) equals: (Vector2 x: 1 y: 2).
	self assert: (Vector2 x: 1 y: 2) - (Vector2 x: 3 y: 5) equals: (Vector2 x: -2 y: -3).
]

{ #category : #tests }
SysmelPrimitiveVector2TypeTest >> testZeros [
	self assert: Vector2 zeros equals: (Vector2 x: 0 y: 0).
]
