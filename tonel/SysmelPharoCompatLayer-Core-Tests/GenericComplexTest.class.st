Class {
	#name : #GenericComplexTest,
	#superclass : #GenericLinearAlgebraTest,
	#category : #'SysmelPharoCompatLayer-Core-Tests-LinearAlgebra'
}

{ #category : #accessing }
GenericComplexTest class >> isAbstract [
	^ self == GenericComplexTest
]

{ #category : #tests }
GenericComplexTest >> testAbsolute [
	self assert: (Complex r: 0 i: 1) abs equals: 1.
	self assert: (Complex r: 0 i: -1) abs equals: 1.
	self assert: (Complex r: 1 i: 0) abs equals: 1.
	self assert: (Complex r: -1 i: 0) abs equals: 1.
	self assert: (Complex r: 3 i: 4) abs equals: 5.
	self assert: (Complex r: -3 i: 4) abs equals: 5.
	self assert: (Complex r: 3 i: -4) abs equals: 5.
	self assert: (Complex r: -3 i: -4) abs equals: 5.
]

{ #category : #tests }
GenericComplexTest >> testAddition [
	self assert: (Complex r: 0 i: 0) + (Complex r: 0 i: 0) equals: (Complex r: 0 i: 0).
	self assert: (Complex r: 1 i: 2) + (Complex r: 0 i: 0) equals: (Complex r: 1 i: 2).
	self assert: (Complex r: 1 i: 2) + (Complex r: 3 i: 4) equals: (Complex r: 4 i: 6).
	self assert: (Complex r: 3 i: 4) + (Complex r: 1 i: 2) equals: (Complex r: 4 i: 6).
]

{ #category : #tests }
GenericComplexTest >> testAngle [
	self assert: (Complex r: 1 i: 0) angle closeTo: 0.
	self assert: (Complex r: 0 i: 1) angle closeTo: Scalar halfPi.
	self assert: (((Complex r: -1 i: 0) angle closeTo: Scalar pi) or: [(Complex r: -1 i: 0) angle closeTo: Scalar pi negated]).
	self assert: (Complex r: 0 i: -1) angle closeTo: Scalar halfPi negated.
]

{ #category : #tests }
GenericComplexTest >> testArgument [
	self assert: (Complex r: 1 i: 0) arg closeTo: 0.
	self assert: (Complex r: 0 i: 1) arg closeTo: Scalar halfPi.
	self assert: (((Complex r: -1 i: 0) arg closeTo: Scalar pi) or: [(Complex r: -1 i: 0) arg closeTo: Scalar pi negated]).
	self assert: (Complex r: 0 i: -1) arg closeTo: Scalar halfPi negated.
]

{ #category : #tests }
GenericComplexTest >> testAsFloat32x2x2 [
	self assert: Complex zero asFloat32x2x2 equals: Float32x2x2 zeros.
	self assert: Complex identity asFloat32x2x2 equals: Float32x2x2 identity.
	self assert: (Complex angle: Scalar halfPi) asFloat32x2x2 closeTo: ((Matrix2x2 rotation: Scalar halfPi) castTo: Float32x2x2).
	self assert: (Complex angle: Scalar halfPi negated) asFloat32x2x2 closeTo: ((Matrix2x2 rotation: Scalar halfPi negated) castTo: Float32x2x2).
	self assert: (Complex angle: Scalar pi) asFloat32x2x2 closeTo: ((Matrix2x2 rotation: Scalar pi) castTo: Float32x2x2).
]

{ #category : #tests }
GenericComplexTest >> testAsFloat64x2x2 [
	self assert: Complex zero asFloat64x2x2 equals: Float64x2x2 zeros.
	self assert: Complex identity asFloat64x2x2 equals: Float64x2x2 identity.
	self assert: (Complex angle: Scalar halfPi) asFloat64x2x2 closeTo: ((Matrix2x2 rotation: Scalar halfPi) castTo: Float64x2x2).
	self assert: (Complex angle: Scalar halfPi negated) asFloat64x2x2 closeTo: ((Matrix2x2 rotation: Scalar halfPi negated) castTo: Float64x2x2).
	self assert: (Complex angle: Scalar pi) asFloat64x2x2 closeTo: ((Matrix2x2 rotation: Scalar pi) castTo: Float64x2x2).
]

{ #category : #tests }
GenericComplexTest >> testAsMatrix2x2 [
	self assert: Complex zero asMatrix2x2 equals: Matrix2x2 zeros.
	self assert: Complex identity asMatrix2x2 equals: Matrix2x2 identity.
	self assert: (Complex angle: Scalar halfPi) asMatrix2x2 closeTo: (Matrix2x2 rotation: Scalar halfPi).
	self assert: (Complex angle: Scalar halfPi negated) asMatrix2x2 closeTo: (Matrix2x2 rotation: Scalar halfPi negated).
	self assert: (Complex angle: Scalar pi) asMatrix2x2 closeTo: (Matrix2x2 rotation: Scalar pi).
]

{ #category : #tests }
GenericComplexTest >> testCloseTo [
	| a b c |
	a := Complex r: 1 i: 2.
	b := Complex r: 3 i: 4.
	c := Complex r: 3 i: 4.

	self assert: b closeTo:  c.
	self deny: (a closeTo: b).
	self assert: a notCloseTo:  b.

	self deny: (a closeTo: c).
	self deny: a closeTo: c.

]

{ #category : #tests }
GenericComplexTest >> testConjugated [
	self assert: (Complex r: 1 i: 2) conjugated equals: (Complex r: 1 i: -2).
]

{ #category : #tests }
GenericComplexTest >> testConstruction [
	| complex |
	complex := Complex x: 2 y: 3.
	self assert: complex x equals: 2.
	self assert: complex y equals: 3.
	self assert: complex equals: (Complex r: 2 i: 3).
]

{ #category : #tests }
GenericComplexTest >> testConstruction2 [
	| complex |
	complex := Complex r: 2 i: 3.
	self assert: complex x equals: 2.
	self assert: complex y equals: 3.
	self assert: complex equals: (Complex r: 2 i: 3).
]

{ #category : #tests }
GenericComplexTest >> testDivision [
	self assert: (Complex r: 1 i: 2) / (Complex r: 1 i: 0) equals: (Complex r: 1 i: 2).
	self assert: (Complex r: 20 i: 25) / (Complex r: 5 i: 0) equals: (Complex r: 4 i: 5).
	self assert: (Complex r: 4 i: 89) / (Complex r: 4 i: 89) closeTo: (Complex r: 1 i: 0).
]

{ #category : #tests }
GenericComplexTest >> testDot [
	self assert: ((Complex r: 1 i: 2) dot: (Complex r: 4 i: 7)) equals: "4 + 14" 18.
]

{ #category : #tests }
GenericComplexTest >> testEquals [
	| a b c |
	a := Complex r: 1 i: 2.
	b := Complex r: 3 i: 4.
	c := Complex r: 3 i: 4.

	self assert: b equals:  c.
	self deny: a = b.
	self deny: a = c.

]

{ #category : #tests }
GenericComplexTest >> testGreaterOrEqual [
	self assert: (Complex r: 0 i: 0) >= (Complex r: 0 i: 0).
	self deny: (Complex r: 0 i: 0) >= (Complex r: 1 i: 0).
	self assert: (Complex r: 1 i: 0) >= (Complex r: 0 i: 0).

	self deny: (Complex r: 0 i: 0) >= (Complex r: 0 i: 1).
	self assert: (Complex r: 0 i: 1) >= (Complex r: 0 i: 0).
	self assert: (Complex r: 0 i: 1) >= (Complex r: 0 i: 1).
]

{ #category : #tests }
GenericComplexTest >> testGreaterThan [
	self deny: (Complex r: 0 i: 0) > (Complex r: 0 i: 0).
	self deny: (Complex r: 0 i: 0) > (Complex r: 1 i: 0).
	self assert: (Complex r: 1 i: 0) > (Complex r: 0 i: 0).

	self deny: (Complex r: 0 i: 0) > (Complex r: 0 i: 1).
	self assert: (Complex r: 0 i: 1) > (Complex r: 0 i: 0).
	self deny: (Complex r: 0 i: 1) > (Complex r: 0 i: 1).
]

{ #category : #tests }
GenericComplexTest >> testHash [
	| b c |
	b := Complex r: 3 i: 4.
	c := Complex r: 3 i: 4.
	self assert: b hash equals: c hash.
]

{ #category : #tests }
GenericComplexTest >> testIdentity [
	self assert: Complex identity equals: (Complex r: 1 i: 0).
]

{ #category : #tests }
GenericComplexTest >> testInverse [
	self assert: (Complex r: 1 i: 0) inverse equals: (Complex r: 1 i: 0).
	self assert: Complex one inverse equals: Complex one.
]

{ #category : #tests }
GenericComplexTest >> testLength [
	self assert: (Complex r: 3 i: 4) length equals: 5.
]

{ #category : #tests }
GenericComplexTest >> testLength2 [
	self assert: (Complex r: 3 i: 4) length2 equals: 25.
]

{ #category : #tests }
GenericComplexTest >> testLessOrEqual [
	self assert: (Complex r: 0 i: 0) <= (Complex r: 0 i: 0).
	self assert: (Complex r: 0 i: 0) <= (Complex r: 1 i: 0).
	self deny: (Complex r: 1 i: 0) <= (Complex r: 0 i: 0).

	self assert: (Complex r: 0 i: 0) <= (Complex r: 0 i: 1).
	self deny: (Complex r: 0 i: 1) <= (Complex r: 0 i: 0).
	self assert: (Complex r: 0 i: 1) <= (Complex r: 0 i: 1).
]

{ #category : #tests }
GenericComplexTest >> testLessThan [
	self deny: (Complex r: 0 i: 0) < (Complex r: 0 i: 0).
	self assert: (Complex r: 0 i: 0) < (Complex r: 1 i: 0).
	self deny: (Complex r: 1 i: 0) < (Complex r: 0 i: 0).

	self assert: (Complex r: 0 i: 0) < (Complex r: 0 i: 1).
	self deny: (Complex r: 0 i: 1) < (Complex r: 0 i: 0).
	self deny: (Complex r: 0 i: 1) < (Complex r: 0 i: 1).
]

{ #category : #tests }
GenericComplexTest >> testMultiplication [
	self assert: (Complex r: 2 i: 3) * (Complex r: 4 i: 5) equals: (Complex r: -7 i: 22).
]

{ #category : #tests }
GenericComplexTest >> testMultiplicationScalar [
	self assert: (Complex r: 0 i: 0) * (Complex r: 0 i: 0) equals: (Complex r: 0 i: 0).
	self assert: (Complex r: 1 i: 2) * (Complex r: 0 i: 0) equals: (Complex r: 0 i: 0).
	self assert: (Complex r: 1 i: 2) * 0 equals: (Complex r: 0 i: 0).

	self assert: (Complex r: 0 i: 0) * (Complex r: 1 i: 0) equals: (Complex r: 0 i: 0).
	self assert: (Complex r: 1 i: 2) * (Complex r: 1 i: 0) equals: (Complex r: 1 i: 2).
	self assert: (Complex r: 1 i: 2) * 1 equals: (Complex r: 1 i: 2).

	self assert: (Complex r: 0 i: 0) * (Complex r: 3 i: 0) equals: (Complex r: 0 i: 0).
	self assert: (Complex r: 1 i: 2) * (Complex r: 3 i: 0) equals: (Complex r: 3 i: 6).
	self assert: (Complex r: 1 i: 2) * 3 equals: (Complex r: 3 i: 6).
]

{ #category : #tests }
GenericComplexTest >> testNegated [
	self assert: (Complex r: 1 i: 2) negated equals: (Complex r: -1 i: -2).
]

{ #category : #tests }
GenericComplexTest >> testNotEquals [
	| a b c |
	a := Complex r: 1 i: 2.
	b := Complex r: 3 i: 4.
	c := Complex r: 3 i: 4.

	self deny: (b ~=  c).
	self assert: a ~= b.
	self assert: a ~= c.

]

{ #category : #tests }
GenericComplexTest >> testOne [
	self assert: Complex one equals: (Complex r: 1 i: 0).
]

{ #category : #tests }
GenericComplexTest >> testSubtraction [
	self assert: (Complex r: 0 i: 0) - (Complex r: 0 i: 0) equals: (Complex r: 0 i: 0).
	self assert: (Complex r: 1 i: 2) - (Complex r: 0 i: 0) equals: (Complex r: 1 i: 2).
	self assert: (Complex r: 1 i: 2) - (Complex r: 3 i: 5) equals: (Complex r: -2 i: -3).
]

{ #category : #tests }
GenericComplexTest >> testZero [
	self assert: Complex zero equals: (Complex r: 0 i: 0).
]
