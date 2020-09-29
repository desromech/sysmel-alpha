Class {
	#name : #SysmelPrimitiveMatrix4x4Type,
	#superclass : #SysmelPrimitiveMatrixType,
	#instVars : [
		'firstColumn',
		'secondColumn',
		'thirdColumn',
		'fourthColumn'
	],
	#classInstVars : [
		'minorMatrixType'
	],
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix4x4Type class >> columnMajorIndices [
	^ self columns: #(0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15)
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type class >> columns [
	^ 4
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type class >> columns: columns [
	columns size = 4 ifTrue: [ 
		^ self basicNew
			firstColumn: columns first;
			secondColumn: columns second;
			thirdColumn: columns third;
			fourthColumn: columns fourth;
			yourself
	].
	columns size = 16 ifTrue: [ 
		^ self basicNew
			firstColumn: (self columnType x: (columns at: 1) y: (columns at: 2) z: (columns at: 3) w: (columns at: 4));
			secondColumn: (self columnType x: (columns at: 5) y: (columns at: 6) z: (columns at: 7) w: (columns at: 8));
			thirdColumn: (self columnType x: (columns at: 9) y: (columns at: 10) z: (columns at: 11) w: (columns at: 12));
			fourthColumn: (self columnType x: (columns at: 13) y: (columns at: 14) z: (columns at: 15) w: (columns at: 16));
			yourself
	].
	self error: 'Unsupported element count for matrix creation.'
]

{ #category : #'instance creation' }
SysmelPrimitiveMatrix4x4Type class >> identity [
	^ self basicNew
		firstColumn: (self columnType x: 1 y: 0 z: 0 w: 0);
		secondColumn: (self columnType x: 0 y: 1 z: 0 w: 0);
		thirdColumn: (self columnType x: 0 y: 0 z: 1 w: 0);
		fourthColumn: (self columnType x: 0 y: 0 z: 0 w: 1);
		yourself

]

{ #category : #testing }
SysmelPrimitiveMatrix4x4Type class >> isAbstract [
	^ self == SysmelPrimitiveMatrix4x4Type
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type class >> minorMatrixType [
	^ minorMatrixType ifNil: [ minorMatrixType := self elementType primitiveMatrixWithRows: 3 columns: 3 ]
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix4x4Type class >> rowMajorIndices [
	^ self rows: #(0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15)
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type class >> rows [
	^ 4
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type class >> rows: rows [
	rows size = 4 ifTrue: [ 
		^ self basicNew
			firstColumn: (self columnType x: rows first x y: rows second x z: rows third x w: rows fourth x);
			secondColumn: (self columnType x: rows first y y: rows second y z: rows third y w: rows fourth y);
			thirdColumn: (self columnType x: rows first z y: rows second z z: rows third z w: rows fourth z);
			fourthColumn: (self columnType x: rows first w y: rows second w z: rows third w w: rows fourth w);
			yourself
	].
	rows size = 16 ifTrue: [ 
		^ self basicNew
			firstColumn: (self columnType x: (rows at: 1) y: (rows at: 5) z: (rows at: 9) w: (rows at: 13));
			secondColumn: (columnType x: (rows at: 2) y: (rows at: 6) z: (rows at: 10) w: (rows at: 14));
			thirdColumn: (columnType x: (rows at: 3) y: (rows at: 7) z: (rows at: 11) w: (rows at: 15));
			fourthColumn: (columnType x: (rows at: 4) y: (rows at: 8) z: (rows at: 12) w: (rows at: 16));
			yourself
	].
	self error: 'Unsupported element count for matrix creation.'
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type class >> scale: scale [
	| coercedScale |
	coercedScale := scale implicitCastTo: self columnType.
	^ self basicNew
		firstColumn: (columnType x: coercedScale x y: 0 z: 0 w: 0);
		secondColumn: (columnType x: 0 y: coercedScale y z: 0 w: 0);
		thirdColumn: (columnType x: 0 y: 0 z: coercedScale z w: 0);
		fourthColumn: (columnType x: 0 y: 0 z: 0 w: coercedScale w);
		yourself
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix4x4Type class >> scaleX: x y: y z: z w: w [
	^ self basicNew
		firstColumn: (self columnType x: x y: 0 z: 0 w: 0);
		secondColumn: (columnType x: 0 y: y z: 0 w: 0);
		thirdColumn: (columnType x: 0 y: 0 z: z w: 0);
		fourthColumn: (columnType x: 0 y: 0 z: 0 w: w);
		yourself
]

{ #category : #'instance creation' }
SysmelPrimitiveMatrix4x4Type class >> withAll: value [
	^ self basicNew
		firstColumn: value;
		secondColumn: value;
		thirdColumn: value;
		fourthColumn: value;
		yourself
]

{ #category : #comparing }
SysmelPrimitiveMatrix4x4Type >> = other [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	^ firstColumn = coercedOther firstColumn and: [
	  secondColumn = coercedOther secondColumn and: [
	  thirdColumn = coercedOther thirdColumn and: [
	  fourthColumn = coercedOther fourthColumn ]]]
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix4x4Type >> adjugateMatrix [
	^ self class columns: { 
			self cofactorAtRow: 1 atColumn: 1.
			self cofactorAtRow: 1 atColumn: 2.
			self cofactorAtRow: 1 atColumn: 3.
			self cofactorAtRow: 1 atColumn: 4.

			self cofactorAtRow: 2 atColumn: 1.
			self cofactorAtRow: 2 atColumn: 2.
			self cofactorAtRow: 2 atColumn: 3.
			self cofactorAtRow: 2 atColumn: 4.

			self cofactorAtRow: 3 atColumn: 1.
			self cofactorAtRow: 3 atColumn: 2.
			self cofactorAtRow: 3 atColumn: 3.
			self cofactorAtRow: 3 atColumn: 4.

			self cofactorAtRow: 4 atColumn: 1.
			self cofactorAtRow: 4 atColumn: 2.
			self cofactorAtRow: 4 atColumn: 3.
			self cofactorAtRow: 4 atColumn: 4.
		}
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix4x4Type >> at: column [
	column = 1 ifTrue: [
		^ firstColumn
	].
	column = 2 ifTrue: [
		^ secondColumn
	].
	column = 3 ifTrue: [
		^ thirdColumn
	].
	column = 4 ifTrue: [
		^ fourthColumn
	].
	self error
]

{ #category : #comparing }
SysmelPrimitiveMatrix4x4Type >> closeTo: other [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	^ (firstColumn closeTo: coercedOther firstColumn) and: [
	  (secondColumn closeTo: coercedOther secondColumn) and: [
	  (thirdColumn closeTo: coercedOther thirdColumn) and: [
	   fourthColumn closeTo: coercedOther fourthColumn ]]]
]

{ #category : #comparing }
SysmelPrimitiveMatrix4x4Type >> closeTo: other precision: precision [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	^ (firstColumn closeTo: coercedOther firstColumn precision: precision) and: [
	  (secondColumn closeTo: coercedOther secondColumn precision: precision) and: [
	  (thirdColumn closeTo: coercedOther thirdColumn precision: precision) and: [
	   fourthColumn closeTo: coercedOther fourthColumn precision: precision ]]]
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix4x4Type >> cofactorAtRow: row atColumn: column [
	^ (self minorMatrixAtRow: row atColumn: column) determinant * ((row + column) even ifTrue: [ 1 ] ifFalse: [ -1 ])
]

{ #category : #enumerating }
SysmelPrimitiveMatrix4x4Type >> collect: aBlock [
	^ self class basicNew
		firstColumn: (aBlock value: firstColumn);
		secondColumn: (aBlock value: secondColumn);
		thirdColumn: (aBlock value: thirdColumn);
		fourthColumn: (aBlock value: fourthColumn);
		yourself
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix4x4Type >> determinant [
	^ ((self minorAtRow: 1 atColumn: 1)*firstColumn x)
		- ((self minorAtRow: 1 atColumn: 2)*secondColumn x)
		+ ((self minorAtRow: 1 atColumn: 3)*thirdColumn x)
		- ((self minorAtRow: 1 atColumn: 4)*fourthColumn x)
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type >> firstColumn [
	^ firstColumn
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type >> firstColumn: anObject [
	firstColumn := anObject implicitCastTo: self class columnType
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type >> fourthColumn [
	^ fourthColumn
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type >> fourthColumn: anObject [
	fourthColumn := anObject implicitCastTo: self class columnType
]

{ #category : #comparing }
SysmelPrimitiveMatrix4x4Type >> hash [
	^ ((firstColumn hash hashMultiply + secondColumn hash) hashMultiply + thirdColumn hash) hashMultiply + fourthColumn hash
]

{ #category : #operations }
SysmelPrimitiveMatrix4x4Type >> inverse [
	| det detVector adjugate |
	det := self determinant.
	(det closeTo: 0) ifTrue: [ ^ self error: 'Matrix is not invertible.' ].
	detVector := det implicitCastTo: self class columnType.
	adjugate := self adjugateMatrix.
	^ self class basicNew
		firstColumn: adjugate firstColumn / detVector;
		secondColumn: adjugate secondColumn / detVector;
		thirdColumn: adjugate thirdColumn / detVector;
		fourthColumn: adjugate fourthColumn / detVector;
		yourself
]

{ #category : #testing }
SysmelPrimitiveMatrix4x4Type >> isIdentity [
	^ firstColumn x = 1 and: [
	  firstColumn y = 0 and: [
	  firstColumn z = 0 and: [
	  firstColumn w = 0 and: [

	  secondColumn x = 0 and: [
	  secondColumn y = 1 and: [
	  secondColumn z = 0 and: [
	  secondColumn w = 0 and: [
		
	  thirdColumn x = 0 and: [
	  thirdColumn y = 0 and: [
	  thirdColumn z = 1 and: [
	  thirdColumn w = 0 and: [

	  fourthColumn x = 0 and: [
	  fourthColumn y = 0 and: [
	  fourthColumn z = 0 and: [
	  fourthColumn w = 1 ]]]]]]]]]]]]]]]
]

{ #category : #testing }
SysmelPrimitiveMatrix4x4Type >> isOnes [
	^ firstColumn x = 1 and: [
	  firstColumn y = 1 and: [
	  firstColumn z = 1 and: [
	  firstColumn w = 1 and: [

	  secondColumn x = 1 and: [
	  secondColumn y = 1 and: [
	  secondColumn z = 1 and: [
	  secondColumn w = 1 and: [
		
	  thirdColumn x = 1 and: [
	  thirdColumn y = 1 and: [
	  thirdColumn z = 1 and: [
	  thirdColumn w = 1 and: [

	  fourthColumn x = 1 and: [
	  fourthColumn y = 1 and: [
	  fourthColumn z = 1 and: [
	  fourthColumn w = 1 ]]]]]]]]]]]]]]]
]

{ #category : #testing }
SysmelPrimitiveMatrix4x4Type >> isZeros [
	^ firstColumn x = 0 and: [
	  firstColumn y = 0 and: [
	  firstColumn z = 0 and: [
	  firstColumn w = 0 and: [

	  secondColumn x = 0 and: [
	  secondColumn y = 0 and: [
	  secondColumn z = 0 and: [
	  secondColumn w = 0 and: [
		
	  thirdColumn x = 0 and: [
	  thirdColumn y = 0 and: [
	  thirdColumn z = 0 and: [
	  thirdColumn w = 0 and: [

	  fourthColumn x = 0 and: [
	  fourthColumn y = 0 and: [
	  fourthColumn z = 0 and: [
	  fourthColumn w = 0 ]]]]]]]]]]]]]]]
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix4x4Type >> minorAtRow: row atColumn: column [
	^ (self minorMatrixAtRow: row atColumn: column) determinant
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix4x4Type >> minorMatrixAtRow: row atColumn: column [
	| result |
	result := self class minorMatrixType basicNew.
	column = 1 ifTrue: [
		^ result
			firstColumn: (secondColumn minorAt: row);
			secondColumn: (thirdColumn minorAt: row);
			thirdColumn: (fourthColumn minorAt: row);
			yourself
	].
	column = 2 ifTrue: [
		^ result
			firstColumn: (firstColumn minorAt: row);
			secondColumn: (thirdColumn minorAt: row);
			thirdColumn: (fourthColumn minorAt: row);
			yourself
	].
	column = 3 ifTrue: [
		^ result
			firstColumn: (firstColumn minorAt: row);
			secondColumn: (secondColumn minorAt: row);
			thirdColumn: (fourthColumn minorAt: row);
			yourself
	].
	column = 4 ifTrue: [
		^ result
			firstColumn: (firstColumn minorAt: row);
			secondColumn: (secondColumn minorAt: row);
			thirdColumn: (thirdColumn minorAt: row);
			yourself
	].
	self error
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type >> secondColumn [
	^ secondColumn
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type >> secondColumn: anObject [
	secondColumn := anObject implicitCastTo: self class columnType
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type >> thirdColumn [
	^ thirdColumn
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type >> thirdColumn: anObject [
	thirdColumn := anObject implicitCastTo: self class columnType
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type >> transpose [
	^ self class rows: { firstColumn . secondColumn . thirdColumn . fourthColumn }
]

{ #category : #enumerating }
SysmelPrimitiveMatrix4x4Type >> with: other collect: aBlock [
	| castedOther |
	castedOther := other implicitCastTo: self class.
	^ self class basicNew
		firstColumn: (aBlock value: firstColumn value: castedOther firstColumn);
		secondColumn: (aBlock value: secondColumn value: castedOther secondColumn);
		thirdColumn: (aBlock value: thirdColumn value: castedOther thirdColumn);
		fourthColumn: (aBlock value: fourthColumn value: castedOther fourthColumn);
		yourself
]

{ #category : #comparing }
SysmelPrimitiveMatrix4x4Type >> ~= other [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	^ firstColumn ~= coercedOther firstColumn or: [
	  secondColumn ~= coercedOther secondColumn or: [
	  thirdColumn ~= coercedOther thirdColumn or: [
	  fourthColumn ~= coercedOther fourthColumn ]]]
]
