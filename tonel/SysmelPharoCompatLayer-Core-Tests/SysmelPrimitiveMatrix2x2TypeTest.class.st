Class {
	#name : #SysmelPrimitiveMatrix2x2TypeTest,
	#superclass : #SysmelPrimitiveTensorTypeTest,
	#category : #'SysmelPharoCompatLayer-Core-Tests-PrimitiveTypes'
}

{ #category : #accessing }
SysmelPrimitiveMatrix2x2TypeTest class >> isAbstract [
	^ self == SysmelPrimitiveMatrix2x2TypeTest
]

{ #category : #tests }
SysmelPrimitiveMatrix2x2TypeTest >> testCloseTo [
	self assert: Matrix2x2 ones closeTo: Matrix2x2 ones.
	self assert: Matrix2x2 zeros closeTo: Matrix2x2 zeros.
	self assert: Matrix2x2 identity closeTo: Matrix2x2 identity.

	self assert: Matrix2x2 ones notCloseTo: Matrix2x2 zeros.
	self assert: Matrix2x2 ones notCloseTo: Matrix2x2 identity.
	self assert: Matrix2x2 zeros notCloseTo: Matrix2x2 identity.
]

{ #category : #tests }
SysmelPrimitiveMatrix2x2TypeTest >> testColumnMajorIndices [
	self assert: Matrix2x2 columnMajorIndices equals: (Matrix2x2 columns: #(
		0 1
		2 3
	)).
	self assert: Matrix2x2 columnMajorIndices equals: (Matrix2x2 rows: #(
		0 2
		1 3
	)).
]

{ #category : #tests }
SysmelPrimitiveMatrix2x2TypeTest >> testDeterminant [
	self assert: Matrix2x2 ones determinant equals: 0.
	self assert: Matrix2x2 zeros determinant equals: 0.
	self assert: Matrix2x2 identity determinant equals: 1.
	self assert: (Matrix2x2 columns: #(1 3 2 4)) determinant equals: -2.
	self assert: (Matrix2x2 columns: #(1 2 3 4)) determinant equals: -2.
]

{ #category : #tests }
SysmelPrimitiveMatrix2x2TypeTest >> testEquals [
	self assert: Matrix2x2 ones equals: Matrix2x2 ones.
	self assert: Matrix2x2 zeros closeTo: Matrix2x2 zeros.
	self assert: Matrix2x2 identity closeTo: Matrix2x2 identity.
]

{ #category : #tests }
SysmelPrimitiveMatrix2x2TypeTest >> testHash [
	self assert: Matrix2x2 ones hash equals: Matrix2x2 ones hash.
	self assert: Matrix2x2 zeros hash equals: Matrix2x2 zeros hash.
	self assert: Matrix2x2 identity hash equals: Matrix2x2 identity hash.

	self deny: Matrix2x2 ones hash equals: Matrix2x2 zeros hash.
	self deny: Matrix2x2 ones hash equals: Matrix2x2 identity hash.
	self deny: Matrix2x2 zeros hash equals: Matrix2x2 identity hash.
]

{ #category : #tests }
SysmelPrimitiveMatrix2x2TypeTest >> testIdentity [
	self assert: Matrix2x2 identity equals: (Matrix2x2 rows: #(
		1 0
		0 1
	)).
	self assert: Matrix2x2 identity isIdentity.
	self deny: Matrix2x2 identity isZeros.
	self deny: Matrix2x2 identity isOnes.
]

{ #category : #tests }
SysmelPrimitiveMatrix2x2TypeTest >> testInverse [
	Scalar isPrimitiveFloatType ifFalse: [ ^ self skip ].
	self assert: Matrix2x2 identity inverse equals: Matrix2x2 identity.
	self assert: (Matrix2x2 columns: #(0 1 2 3)) inverse equals: (Matrix2x2 columns: #(-1.5 0.5 1.0 0.0)).
]

{ #category : #tests }
SysmelPrimitiveMatrix2x2TypeTest >> testNotEquals [
	self deny: Matrix2x2 ones equals: Matrix2x2 zeros.
	self deny: Matrix2x2 ones equals: Matrix2x2 identity.
	self deny: Matrix2x2 zeros equals: Matrix2x2 identity.
]

{ #category : #tests }
SysmelPrimitiveMatrix2x2TypeTest >> testOnes [
	self assert: Matrix2x2 ones equals: (Matrix2x2 rows: #(
		1 1
		1 1
	)).
	self assert: Matrix2x2 ones isOnes.
	self deny: Matrix2x2 ones isZeros.
	self deny: Matrix2x2 ones isIdentity.
]

{ #category : #tests }
SysmelPrimitiveMatrix2x2TypeTest >> testRowMajorIndices [
	self assert: Matrix2x2 rowMajorIndices equals: (Matrix2x2 rows: #(
		0 1
		2 3
	)).
	self assert: Matrix2x2 rowMajorIndices equals: (Matrix2x2 columns: #(
		0 2
		1 3
	)).
]

{ #category : #tests }
SysmelPrimitiveMatrix2x2TypeTest >> testScale [
	self assert: (Matrix2x2 scale: (Vector2 x: 2 y: 3)) equals: (Matrix2x2 rows: #(
		2 0
		0 3
	)).
	self assert: (Matrix2x2 scaleX: 2 y: 3) equals: (Matrix2x2 rows: #(
		2 0
		0 3
	)).
]

{ #category : #tests }
SysmelPrimitiveMatrix2x2TypeTest >> testTranspose [
	| a b |
	self assert: Matrix2x2 columnMajorIndices transpose transpose equals: Matrix2x2 columnMajorIndices.

	a := Matrix2x2 columnMajorIndices.
	b := Matrix2x2 rowMajorIndices.
	self assert: a transpose equals: b.
	self assert: b transpose equals: a.
	self assert: a transpose transpose equals: a.
	self assert: b transpose transpose equals: b.
]

{ #category : #tests }
SysmelPrimitiveMatrix2x2TypeTest >> testZeros [
	self assert: Matrix2x2 zeros equals: (Matrix2x2 rows: #(
		0 0
		0 0
	)).
	self deny: Matrix2x2 zeros isIdentity.
	self assert: Matrix2x2 zeros isZeros.
	self deny: Matrix2x2 zeros isOnes.
]
