Class {
	#name : #SysmelPrimitiveMatrix4x4TypeTest,
	#superclass : #SysmelPrimitiveTensorTypeTest,
	#category : #'SysmelPharoCompatLayer-Core-Tests-PrimitiveTypes'
}

{ #category : #accessing }
SysmelPrimitiveMatrix4x4TypeTest class >> isAbstract [
	^ self == SysmelPrimitiveMatrix4x4TypeTest
]

{ #category : #tests }
SysmelPrimitiveMatrix4x4TypeTest >> testCloseTo [
	self assert: Matrix4x4 ones closeTo: Matrix4x4 ones.
	self assert: Matrix4x4 zeros closeTo: Matrix4x4 zeros.
	self assert: Matrix4x4 identity closeTo: Matrix4x4 identity.

	self assert: Matrix4x4 ones notCloseTo: Matrix4x4 zeros.
	self assert: Matrix4x4 ones notCloseTo: Matrix4x4 identity.
	self assert: Matrix4x4 zeros notCloseTo: Matrix4x4 identity.
]

{ #category : #tests }
SysmelPrimitiveMatrix4x4TypeTest >> testColumnMajorIndices [
	self assert: Matrix4x4 columnMajorIndices equals: (Matrix4x4 columns: #(
		0 1 2 3
		4 5 6 7
		8 9 10 11
		12 13 14 15
	)).

	self assert: Matrix4x4 columnMajorIndices equals: (Matrix4x4 rows: #(
		0 4 8 12
		1 5 9 13
		2 6 10 14
		3 7 11 15
	)).
]

{ #category : #tests }
SysmelPrimitiveMatrix4x4TypeTest >> testDeterminant [
	self assert: Matrix4x4 ones determinant equals: 0.
	self assert: Matrix4x4 zeros determinant equals: 0.
	self assert: Matrix4x4 identity determinant equals: 1.
	self assert: (Matrix4x4 columns: #(
		0 1 2 4
		10 8 5 3
		9 3 8 1
		20 21 25 24)) determinant equals: 993.
]

{ #category : #tests }
SysmelPrimitiveMatrix4x4TypeTest >> testEquals [
	self assert: Matrix4x4 ones equals: Matrix4x4 ones.
	self assert: Matrix4x4 zeros closeTo: Matrix4x4 zeros.
	self assert: Matrix4x4 identity closeTo: Matrix4x4 identity.
]

{ #category : #tests }
SysmelPrimitiveMatrix4x4TypeTest >> testHash [
	self assert: Matrix4x4 ones hash equals: Matrix4x4 ones hash.
	self assert: Matrix4x4 zeros hash equals: Matrix4x4 zeros hash.
	self assert: Matrix4x4 identity hash equals: Matrix4x4 identity hash.

	self deny: Matrix4x4 ones hash equals: Matrix4x4 zeros hash.
	self deny: Matrix4x4 ones hash equals: Matrix4x4 identity hash.
	self deny: Matrix4x4 zeros hash equals: Matrix4x4 identity hash.
]

{ #category : #tests }
SysmelPrimitiveMatrix4x4TypeTest >> testIdentity [
	self assert: Matrix4x4 identity equals: (Matrix4x4 columns: #(
		1 0 0 0
		0 1 0 0
		0 0 1 0
		0 0 0 1
	)).
	self assert: Matrix4x4 identity isIdentity.
	self deny: Matrix4x4 identity isZeros.
	self deny: Matrix4x4 identity isOnes.
]

{ #category : #tests }
SysmelPrimitiveMatrix4x4TypeTest >> testNotEquals [
	self deny: Matrix4x4 ones equals: Matrix4x4 zeros.
	self deny: Matrix4x4 ones equals: Matrix4x4 identity.
	self deny: Matrix4x4 zeros equals: Matrix4x4 identity.
]

{ #category : #tests }
SysmelPrimitiveMatrix4x4TypeTest >> testOnes [
	self assert: Matrix4x4 ones equals: (Matrix4x4 columns: #(
		1 1 1 1
		1 1 1 1
		1 1 1 1
		1 1 1 1
	)).
	self assert: Matrix4x4 ones isOnes.
	self deny: Matrix4x4 ones isZeros.
	self deny: Matrix4x4 ones isIdentity.
]

{ #category : #tests }
SysmelPrimitiveMatrix4x4TypeTest >> testRowMajorIndices [
	self assert: Matrix4x4 rowMajorIndices equals: (Matrix4x4 rows: #(
		0 1 2 3
		4 5 6 7
		8 9 10 11
		12 13 14 15
	)).
	self assert: Matrix4x4 rowMajorIndices equals: (Matrix4x4 columns: #(
		0 4 8 12
		1 5 9 13
		2 6 10 14
		3 7 11 15
	)).
]

{ #category : #tests }
SysmelPrimitiveMatrix4x4TypeTest >> testScale [
	self assert: (Matrix4x4 scale: (Vector4 x: 2 y: 3 z: 4 w: 5)) equals: (Matrix4x4 columns: #(
		2 0 0 0
		0 3 0 0
		0 0 4 0
		0 0 0 5
	)).
	self assert: (Matrix4x4 scaleX: 2 y: 3 z: 4 w: 5) equals: (Matrix4x4 columns: #(
		2 0 0 0
		0 3 0 0
		0 0 4 0
		0 0 0 5
	)).
]

{ #category : #tests }
SysmelPrimitiveMatrix4x4TypeTest >> testTranspose [
	| a b |
	self assert: Matrix4x4 columnMajorIndices transpose transpose equals: Matrix4x4 columnMajorIndices.

	a := Matrix4x4 columnMajorIndices.
	b := Matrix4x4 rowMajorIndices.
	self assert: a transpose equals: b.
	self assert: b transpose equals: a.
	self assert: a transpose transpose equals: a.
	self assert: b transpose transpose equals: b.
]

{ #category : #tests }
SysmelPrimitiveMatrix4x4TypeTest >> testZeros [
	self assert: Matrix4x4 zeros equals: (Matrix4x4 columns: #(
		0 0 0 0
		0 0 0 0
		0 0 0 0
		0 0 0 0
	)).
	self deny: Matrix4x4 zeros isIdentity.
	self assert: Matrix4x4 zeros isZeros.
	self deny: Matrix4x4 zeros isOnes.
]
