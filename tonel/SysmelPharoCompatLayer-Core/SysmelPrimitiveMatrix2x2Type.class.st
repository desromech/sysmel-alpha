Class {
	#name : #SysmelPrimitiveMatrix2x2Type,
	#superclass : #SysmelPrimitiveMatrixType,
	#instVars : [
		'firstColumn',
		'secondColumn'
	],
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix2x2Type class >> columnMajorIndices [
	^ self columns: #(0 1 2 3)
]

{ #category : #accessing }
SysmelPrimitiveMatrix2x2Type class >> columns [
	^ 2
]

{ #category : #accessing }
SysmelPrimitiveMatrix2x2Type class >> columns: columns [
	columns size = 2 ifTrue: [ 
		^ self basicNew
			firstColumn: columns first;
			secondColumn: columns second;
			yourself
	].
	columns size = 4 ifTrue: [ 
		^ self basicNew
			firstColumn: (self columnType x: columns first y: columns second);
			secondColumn: (columnType x: columns third y: columns fourth);
			yourself
	].
	self error: 'Unsupported element count for matrix creation.'
]

{ #category : #accessing }
SysmelPrimitiveMatrix2x2Type class >> identity [
	^ self basicNew
		firstColumn: (self columnType x: 1 y: 0);
		secondColumn: (self columnType x: 0 y: 1);
		yourself

]

{ #category : #testing }
SysmelPrimitiveMatrix2x2Type class >> isAbstract [
	^ self == SysmelPrimitiveMatrix2x2Type
]

{ #category : #'manage rotation' }
SysmelPrimitiveMatrix2x2Type class >> rotation: angle [
	| c s |
	c := angle cos.
	s := angle sin.
	^ self columns: {
		c. s.
		s negated. c
	}
	
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix2x2Type class >> rowMajorIndices [
	^ self rows: #(0 1 2 3)
]

{ #category : #accessing }
SysmelPrimitiveMatrix2x2Type class >> rows [
	^ 2
]

{ #category : #accessing }
SysmelPrimitiveMatrix2x2Type class >> rows: rows [
	rows size = 2 ifTrue: [ 
		^ self basicNew
			firstColumn: (self columnType x: rows first x y: rows second x);
			secondColumn: (columnType x: rows first y y: rows second y);
			yourself
	].
	rows size = 4 ifTrue: [ 
		^ self basicNew
			firstColumn: (self columnType x: rows first y: rows third);
			secondColumn: (columnType x: rows second y: rows fourth);
			yourself
	].
	self error: 'Unsupported element count for matrix creation.'
]

{ #category : #accessing }
SysmelPrimitiveMatrix2x2Type class >> scale: scale [
	| coercedScale |
	coercedScale := scale implicitCastTo: self columnType.
	^ self basicNew
		firstColumn: (columnType x: coercedScale x y: 0);
		secondColumn: (columnType x: 0 y: coercedScale y);
		yourself
]

{ #category : #accessing }
SysmelPrimitiveMatrix2x2Type class >> scaleX: x y: y [
	^ self basicNew
		firstColumn: (self columnType x: x y: 0);
		secondColumn: (columnType x: 0 y: y);
		yourself
]

{ #category : #'instance creation' }
SysmelPrimitiveMatrix2x2Type class >> withAll: value [
	^ self basicNew
		firstColumn: value;
		secondColumn: value;
		yourself
]

{ #category : #comparing }
SysmelPrimitiveMatrix2x2Type >> = other [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	^ firstColumn = coercedOther firstColumn and: [
	  secondColumn = coercedOther secondColumn ]
]

{ #category : #accessing }
SysmelPrimitiveMatrix2x2Type >> at: column [
	column = 1 ifTrue: [
		^ firstColumn
	].
	column = 2 ifTrue: [
		^ secondColumn
	].
	self error
]

{ #category : #comparing }
SysmelPrimitiveMatrix2x2Type >> closeTo: other [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	^ (firstColumn closeTo: coercedOther firstColumn) and: [
	  secondColumn closeTo: coercedOther secondColumn ]
]

{ #category : #comparing }
SysmelPrimitiveMatrix2x2Type >> closeTo: other precision: precision [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	^ (firstColumn closeTo: coercedOther firstColumn precision: precision) and: [
	  secondColumn closeTo: coercedOther secondColumn precision: precision ]
]

{ #category : #enumerating }
SysmelPrimitiveMatrix2x2Type >> collect: aBlock [
	^ self class basicNew
		firstColumn: (aBlock value: firstColumn);
		secondColumn: (aBlock value: secondColumn);
		yourself
]

{ #category : #enumerating }
SysmelPrimitiveMatrix2x2Type >> collect: aBlock as: matrixType [
	^ matrixType basicNew
		firstColumn: (aBlock value: firstColumn);
		secondColumn: (aBlock value: secondColumn);
		yourself
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix2x2Type >> determinant [
	^ (firstColumn x * secondColumn y) - (firstColumn y * secondColumn x)
]

{ #category : #accessing }
SysmelPrimitiveMatrix2x2Type >> firstColumn [
	^ firstColumn
]

{ #category : #accessing }
SysmelPrimitiveMatrix2x2Type >> firstColumn: anObject [
	firstColumn := anObject implicitCastTo: self class columnType
]

{ #category : #accessing }
SysmelPrimitiveMatrix2x2Type >> firstRow [
	^ self class rowType x: firstColumn x y: secondColumn x
]

{ #category : #comparing }
SysmelPrimitiveMatrix2x2Type >> hash [
	^ firstColumn hash hashMultiply + secondColumn hash
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix2x2Type >> inverse [
	| det |
	det := self determinant.
	(det closeTo: 0) ifTrue: [ ^ self error: 'Matrix is not invertible.' ].
	^ self class basicNew
		firstColumn: (self class columnType x: secondColumn y / det y: firstColumn y negated / det);
		secondColumn: (self class columnType x: secondColumn x negated / det y: firstColumn x / det);
		yourself
]

{ #category : #testing }
SysmelPrimitiveMatrix2x2Type >> isIdentity [
	^ firstColumn x = 1 and: [
	  firstColumn y = 0 and: [

	  secondColumn x = 0 and: [
	  secondColumn y = 1 ]]]
]

{ #category : #testing }
SysmelPrimitiveMatrix2x2Type >> isOnes [
	^ firstColumn x = 1 and: [
	  firstColumn y = 1 and: [

	  secondColumn x = 1 and: [
	  secondColumn y = 1 ]]]
]

{ #category : #testing }
SysmelPrimitiveMatrix2x2Type >> isZeros [
	^ firstColumn x = 0 and: [
	  firstColumn y = 0 and: [

	  secondColumn x = 0 and: [
	  secondColumn y = 0 ]]]
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix2x2Type >> multiplyWithMatrix: other [
	| coerced |
	coerced := other implicitCastTo: self class.
	^ self class basicNew
		firstColumn: (firstColumn * coerced firstColumn x) + (secondColumn * coerced firstColumn y);
		secondColumn: (firstColumn * coerced secondColumn x) + (secondColumn * coerced secondColumn y);
		yourself

]

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix2x2Type >> postMultiplyVector: vector [
	| coercedVector |
	coercedVector := vector implicitCastTo: self class rowType.
	^ self class rowType x: (firstColumn dot: coercedVector) y: (secondColumn dot: coercedVector)
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix2x2Type >> preMultiplyVector: vector [
	| coercedVector |
	coercedVector := vector implicitCastTo: self class rowType.
	^ (firstColumn * coercedVector x) + (secondColumn * coercedVector y)
]

{ #category : #accessing }
SysmelPrimitiveMatrix2x2Type >> secondColumn [
	^ secondColumn
]

{ #category : #accessing }
SysmelPrimitiveMatrix2x2Type >> secondColumn: anObject [
	secondColumn := anObject implicitCastTo: self class columnType
]

{ #category : #accessing }
SysmelPrimitiveMatrix2x2Type >> secondRow [
	^ self class rowType x: firstColumn y y: secondColumn y
]

{ #category : #accessing }
SysmelPrimitiveMatrix2x2Type >> transpose [
	^ self class basicNew
		firstColumn: self firstRow;
		secondColumn: self secondRow;
		yourself
]

{ #category : #enumerating }
SysmelPrimitiveMatrix2x2Type >> with: other collect: aBlock [
	| castedOther |
	castedOther := other implicitCastTo: self class.
	^ self class basicNew
		firstColumn: (aBlock value: firstColumn value: castedOther firstColumn);
		secondColumn: (aBlock value: secondColumn value: castedOther secondColumn);
		yourself
]

{ #category : #comparing }
SysmelPrimitiveMatrix2x2Type >> ~= other [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	^ firstColumn ~= coercedOther firstColumn or: [
	  secondColumn ~= coercedOther secondColumn ]
]
