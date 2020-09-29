Class {
	#name : #SysmelPrimitiveMatrix3x3TypeTest,
	#superclass : #SysmelPrimitiveTensorTypeTest,
	#category : #'SysmelPharoCompatLayer-Core-Tests-PrimitiveTypes'
}

{ #category : #accessing }
SysmelPrimitiveMatrix3x3TypeTest class >> isAbstract [
	^ self == SysmelPrimitiveMatrix3x3TypeTest
]

{ #category : #tests }
SysmelPrimitiveMatrix3x3TypeTest >> testCloseTo [
	self assert: Matrix3x3 ones closeTo: Matrix3x3 ones.
	self assert: Matrix3x3 zeros closeTo: Matrix3x3 zeros.
	self assert: Matrix3x3 identity closeTo: Matrix3x3 identity.

	self assert: Matrix3x3 ones notCloseTo: Matrix3x3 zeros.
	self assert: Matrix3x3 ones notCloseTo: Matrix3x3 identity.
	self assert: Matrix3x3 zeros notCloseTo: Matrix3x3 identity.
]

{ #category : #tests }
SysmelPrimitiveMatrix3x3TypeTest >> testColumnMajorIndices [
	self assert: Matrix3x3 columnMajorIndices equals: (Matrix3x3 columns: #(
		0 1 2
		3 4 5
		6 7 8
	)).

	self assert: Matrix3x3 columnMajorIndices equals: (Matrix3x3 rows: #(
		0 3 6
		1 4 7
		2 5 8
	)).
]

{ #category : #tests }
SysmelPrimitiveMatrix3x3TypeTest >> testDeterminant [
	self assert: Matrix3x3 ones determinant equals: 0.
	self assert: Matrix3x3 zeros determinant equals: 0.
	self assert: Matrix3x3 identity determinant equals: 1.
	self assert: Matrix3x3 rowMajorIndices determinant equals: 0.
	self assert: (Matrix3x3 columns: #(
		0 1 2
		10 15 20
		-10 7 8)) determinant equals: 160.
]

{ #category : #tests }
SysmelPrimitiveMatrix3x3TypeTest >> testEquals [
	self assert: Matrix3x3 ones equals: Matrix3x3 ones.
	self assert: Matrix3x3 zeros closeTo: Matrix3x3 zeros.
	self assert: Matrix3x3 identity closeTo: Matrix3x3 identity.
]

{ #category : #tests }
SysmelPrimitiveMatrix3x3TypeTest >> testHash [
	self assert: Matrix3x3 ones hash equals: Matrix3x3 ones hash.
	self assert: Matrix3x3 zeros hash equals: Matrix3x3 zeros hash.
	self assert: Matrix3x3 identity hash equals: Matrix3x3 identity hash.

	self deny: Matrix3x3 ones hash equals: Matrix3x3 zeros hash.
	self deny: Matrix3x3 ones hash equals: Matrix3x3 identity hash.
	self deny: Matrix3x3 zeros hash equals: Matrix3x3 identity hash.
]

{ #category : #tests }
SysmelPrimitiveMatrix3x3TypeTest >> testIdentity [
	self assert: Matrix3x3 identity equals: (Matrix3x3 columns: #(
		1 0 0
		0 1 0
		0 0 1
	)).
	self assert: Matrix3x3 identity isIdentity.
	self deny: Matrix3x3 identity isZeros.
	self deny: Matrix3x3 identity isOnes.
]

{ #category : #tests }
SysmelPrimitiveMatrix3x3TypeTest >> testInverse [
	Scalar isPrimitiveFloatType ifFalse: [ ^ self skip ].
	self assert: Matrix3x3 identity inverse equals: Matrix3x3 identity.
	self assert: (Matrix3x3 columns: #(
		0 1 2
		3 -4 5
		-6 7 -8
 	)) inverse closeTo: (Matrix3x3 columns: #(
		0.25000 -1.83333 -1.08333
		0.50000 -1.00000 -0.50000
		0.25000 0.50000 0.25000
	)).
]

{ #category : #tests }
SysmelPrimitiveMatrix3x3TypeTest >> testNotEquals [
	self deny: Matrix3x3 ones equals: Matrix3x3 zeros.
	self deny: Matrix3x3 ones equals: Matrix3x3 identity.
	self deny: Matrix3x3 zeros equals: Matrix3x3 identity.
]

{ #category : #tests }
SysmelPrimitiveMatrix3x3TypeTest >> testOnes [
	self assert: Matrix3x3 ones equals: (Matrix3x3 columns: #(
		1 1 1
		1 1 1
		1 1 1
	)).
	self assert: Matrix3x3 ones isOnes.
	self deny: Matrix3x3 ones isZeros.
	self deny: Matrix3x3 ones isIdentity.
]

{ #category : #tests }
SysmelPrimitiveMatrix3x3TypeTest >> testRowMajorIndices [
	self assert: Matrix3x3 rowMajorIndices equals: (Matrix3x3 rows: #(
		0 1 2
		3 4 5
		6 7 8
	)).
	self assert: Matrix3x3 rowMajorIndices equals: (Matrix3x3 columns: #(
		0 3 6
		1 4 7
		2 5 8
	)).
]

{ #category : #tests }
SysmelPrimitiveMatrix3x3TypeTest >> testScale [
	self assert: (Matrix3x3 scale: (Vector3 x: 2 y: 3 z: 4)) equals: (Matrix3x3 columns: #(
		2 0 0
		0 3 0
		0 0 4
	)).
	self assert: (Matrix3x3 scaleX: 2 y: 3 z: 4) equals: (Matrix3x3 columns: #(
		2 0 0
		0 3 0
		0 0 4
	)).
]

{ #category : #tests }
SysmelPrimitiveMatrix3x3TypeTest >> testTranspose [
	| a b |
	self assert: Matrix3x3 columnMajorIndices transpose transpose equals: Matrix3x3 columnMajorIndices.

	a := Matrix3x3 columnMajorIndices.
	b := Matrix3x3 rowMajorIndices.
	self assert: a transpose equals: b.
	self assert: b transpose equals: a.
	self assert: a transpose transpose equals: a.
	self assert: b transpose transpose equals: b.
]

{ #category : #tests }
SysmelPrimitiveMatrix3x3TypeTest >> testZeros [
	self assert: Matrix3x3 zeros equals: (Matrix3x3 columns: #(
		0 0 0
		0 0 0
		0 0 0
	)).
	self deny: Matrix3x3 zeros isIdentity.
	self assert: Matrix3x3 zeros isZeros.
	self deny: Matrix3x3 zeros isOnes.
]
