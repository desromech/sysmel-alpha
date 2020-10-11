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
	<constructor>
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

{ #category : #'special matrices' }
SysmelPrimitiveMatrix4x4Type class >> frustumLeft: left right: right bottom: bottom top: top
	near: near far: far invertedY: invertedY [
	| yAxisFactor |
	yAxisFactor := invertedY
		ifTrue: [self columnType ones negated]
		ifFalse: [self columnType ones].

	^ self rows: {
		columnType x: 2*near /(right - left) y: 0 z: (right + left) / (right - left) w: 0.
		(columnType x: 0 y: 2*near /(top - bottom) z: (top + bottom) / (top - bottom) w: 0) * yAxisFactor.
		columnType x: 0 y: 0 z: far negated / (far - near) w: near*far negated / (far - near).
		columnType x: 0 y: 0 z: -1 w: 0
	}
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

{ #category : #'special matrices' }
SysmelPrimitiveMatrix4x4Type class >> mat3: mat3 [
	^ self columns: {
		self columnType xyz: mat3 firstColumn w: 0.
		self columnType xyz: mat3 secondColumn w: 0.
		self columnType xyz: mat3 thirdColumn w: 0.
		self columnType w: 1.
	}
]

{ #category : #'special matrices' }
SysmelPrimitiveMatrix4x4Type class >> mat3: mat3 translation4: translation4 [
	^ self columns: {
		self columnType xyz: mat3 firstColumn w: 0.
		self columnType xyz: mat3 secondColumn w: 0.
		self columnType xyz: mat3 thirdColumn w: 0.
		translation4
	}
]

{ #category : #'special matrices' }
SysmelPrimitiveMatrix4x4Type class >> mat3: mat3 translation: translation [
	^ self columns: {
		self columnType xyz: mat3 firstColumn w: 0.
		self columnType xyz: mat3 secondColumn w: 0.
		self columnType xyz: mat3 thirdColumn w: 0.
		self columnType xyz: translation w: 1.
	}
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type class >> minorMatrixType [
	^ minorMatrixType ifNil: [ minorMatrixType := self elementType primitiveMatrixWithRows: 3 columns: 3 ]
]

{ #category : #'special matrices' }
SysmelPrimitiveMatrix4x4Type class >> orthoLeft: left right: right bottom: bottom top: top
	near: near far: far invertedY: invertedY [
	| yAxisFactor |
	yAxisFactor := invertedY
		ifTrue: [self columnType ones negated]
		ifFalse: [self columnType ones].

	^ self rows: {
		columnType x: 2 /(right - left) y: 0 z: 0 w: ((right + left) / (right - left)) negated.
		(columnType x: 0 y: 2 /(top - bottom) z: 0 w: ((top + bottom) / (top - bottom)) negated) * yAxisFactor.
		columnType x: 0 y: 0 z: -1 / (far - near) w: near / (far - near) negated.
		columnType x: 0 y: 0 z: 0 w: 1
	}
]

{ #category : #'special matrices' }
SysmelPrimitiveMatrix4x4Type class >> perspectiveFovY: fovy aspect: aspect near: near far: far invertedY: invertedY [
	| fovyRad top right |
	fovyRad := fovy degreesToRadians * 0.5.
	top := near * fovyRad tan.
	right := top * aspect.
	^ self frustumLeft: right negated right: right bottom: top negated top: top near: near far: far invertedY: invertedY
]

{ #category : #'special matrices' }
SysmelPrimitiveMatrix4x4Type class >> reverseDepthFrustumLeft: left right: right bottom: bottom top: top near: near far: far invertedY: invertedY [
	| yAxisFactor |
	yAxisFactor := invertedY
		ifTrue: [self columnType ones negated]
		ifFalse: [self columnType ones].

	^ self rows: {
		columnType x: 2*near /(right - left) y: 0 z: (right + left) / (right - left) w: 0.
		(columnType x: 0 y: 2*near /(top - bottom) z: (top + bottom) / (top - bottom) w: 0) * yAxisFactor.
		columnType x: 0 y: 0 z: near / (far - near) w: near*far / (far - near).
		columnType x: 0 y: 0 z: -1 w: 0
	}
]

{ #category : #'special matrices' }
SysmelPrimitiveMatrix4x4Type class >> reverseDepthOrthoLeft: left right: right bottom: bottom top: top near: near far: far invertedY: invertedY [
	| yAxisFactor |
	yAxisFactor := invertedY
		ifTrue: [self columnType ones negated]
		ifFalse: [self columnType ones].

	^ self rows: {
		columnType x: 2 /(right - left) y: 0 z: 0 w: ((right + left) / (right - left)) negated.
		(columnType x: 0 y: 2 /(top - bottom) z: 0 w: ((top + bottom) / (top - bottom)) negated) * yAxisFactor.
		columnType x: 0 y: 0 z: 1 / (far - near) w: far / (far - near).
		columnType x: 0 y: 0 z: 0 w: 1
	}
]

{ #category : #'special matrices' }
SysmelPrimitiveMatrix4x4Type class >> reverseDepthPerspectiveFovY: fovy aspect: aspect near: near far: far invertedY: invertedY [
	| fovyRad top right |
	fovyRad := fovy degreesToRadians * 0.5.
	top := near * fovyRad tan.
	right := top * aspect.
	^ self reverseDepthFrustumLeft: right negated right: right bottom: top negated top: top near: near far: far invertedY: invertedY
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

{ #category : #'special matrices' }
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

{ #category : #'special matrices' }
SysmelPrimitiveMatrix4x4Type class >> scaleX: x y: y z: z w: w [
	^ self basicNew
		firstColumn: (self columnType x: x y: 0 z: 0 w: 0);
		secondColumn: (columnType x: 0 y: y z: 0 w: 0);
		thirdColumn: (columnType x: 0 y: 0 z: z w: 0);
		fourthColumn: (columnType x: 0 y: 0 z: 0 w: w);
		yourself
]

{ #category : #'special matrices' }
SysmelPrimitiveMatrix4x4Type class >> translation4: translation4 [
	^ self columns: {
		self columnType x: 1 y: 0 z: 0 w: 0.
		self columnType x: 0 y: 1 z: 0 w: 0.
		self columnType x: 0 y: 0 z: 1 w: 0.
		translation4
	}
]

{ #category : #'special matrices' }
SysmelPrimitiveMatrix4x4Type class >> translation: translation [
	^ self columns: {
		self columnType x: 1 y: 0 z: 0 w: 0.
		self columnType x: 0 y: 1 z: 0 w: 0.
		self columnType x: 0 y: 0 z: 1 w: 0.
		self columnType xyz: translation w: 1.
	}
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

{ #category : #enumerating }
SysmelPrimitiveMatrix4x4Type >> collect: aBlock as: matrixType [
	^ matrixType basicNew
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
	<accessor>
	^ firstColumn
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type >> firstColumn: anObject [
	<accessor>
	firstColumn := anObject implicitCastTo: self class columnType
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type >> firstRow [
	^ self class rowType x: firstColumn x y: secondColumn x z: thirdColumn x w: fourthColumn x
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type >> fourthColumn [
	<accessor>
	^ fourthColumn
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type >> fourthColumn: anObject [
	<accessor>
	fourthColumn := anObject implicitCastTo: self class columnType
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type >> fourthRow [
	^ self class rowType x: firstColumn w y: secondColumn w z: thirdColumn w w: fourthColumn w
]

{ #category : #comparing }
SysmelPrimitiveMatrix4x4Type >> hash [
	^ ((firstColumn hash hashMultiply + secondColumn hash) hashMultiply + thirdColumn hash) hashMultiply + fourthColumn hash
]

{ #category : #operations }
SysmelPrimitiveMatrix4x4Type >> inverse [
	| det detVector adjugate |
	det := self determinant.
	(det = 0) ifTrue: [ ^ self error: 'Matrix is not invertible.' ].
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

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix4x4Type >> multiplyWithMatrix: other [
	| coerced |
	coerced := other implicitCastTo: self class.
	^ self class basicNew
		firstColumn: (firstColumn * coerced firstColumn x) + (secondColumn * coerced firstColumn y) + (thirdColumn * coerced firstColumn z) + (fourthColumn * coerced firstColumn w);
		secondColumn: (firstColumn * coerced secondColumn x) + (secondColumn * coerced secondColumn y) + (thirdColumn * coerced secondColumn z) + (fourthColumn * coerced secondColumn w);
		thirdColumn: (firstColumn * coerced thirdColumn x) + (secondColumn * coerced thirdColumn y) + (thirdColumn * coerced thirdColumn z) + (fourthColumn * coerced thirdColumn w);
		fourthColumn: (firstColumn * coerced fourthColumn x) + (secondColumn * coerced fourthColumn y) + (thirdColumn * coerced fourthColumn z) + (fourthColumn * coerced fourthColumn w);
		yourself

]

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix4x4Type >> perspectiveTransformPosition3: position3 [
	| coercedPosition result4 |
	coercedPosition := position3 implicitCastTo: self class vector3Type.
	result4 := (firstColumn * coercedPosition x) + (secondColumn * coercedPosition y)
	+ (thirdColumn * coercedPosition z) + fourthColumn.
	^ result4 xyz / result4 w
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix4x4Type >> postMultiplyVector: vector [
	| coercedVector |
	coercedVector := vector implicitCastTo: self class rowType.
	^ self class rowType
		x: (firstColumn dot: coercedVector)
		y: (secondColumn dot: coercedVector)
		z: (thirdColumn dot: coercedVector)
		w: (fourthColumn dot: coercedVector)
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix4x4Type >> preMultiplyVector: vector [
	| coercedVector |
	coercedVector := vector implicitCastTo: self class rowType.
	^ (firstColumn * coercedVector x) + (secondColumn * coercedVector y)
	+ (thirdColumn * coercedVector z) + (fourthColumn * coercedVector w)
]

{ #category : #printing }
SysmelPrimitiveMatrix4x4Type >> printOn: aStream [
	aStream nextPut: $(; nextPutAll: self class name; nextPutAll: ' rows: {'; cr;
		tab; print: self firstRow; nextPut: $.; cr;
		tab; print: self secondRow; nextPut: $.; cr;
		tab; print: self thirdRow; nextPut: $.; cr;
		tab; print: self fourthRow; nextPut: $.; cr;
		nextPutAll: '})'
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type >> secondColumn [
	<accessor>
	^ secondColumn
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type >> secondColumn: anObject [
	<accessor>
	secondColumn := anObject implicitCastTo: self class columnType
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type >> secondRow [
	^ self class rowType x: firstColumn y y: secondColumn y z: thirdColumn y w: fourthColumn y
]

{ #category : #'memory access' }
SysmelPrimitiveMatrix4x4Type >> storeBytesIn: aByteArray position: byteArrayPosition [
	| columnType columnTypeSize |
	columnType := self class columnType.
	columnTypeSize := columnType alignedInstanceSize.
	columnType storeValue: firstColumn bytesIn: aByteArray position: byteArrayPosition.
	columnType storeValue: secondColumn bytesIn: aByteArray position: byteArrayPosition + columnTypeSize.
	columnType storeValue: thirdColumn bytesIn: aByteArray position: byteArrayPosition + (columnTypeSize*2).
	columnType storeValue: fourthColumn bytesIn: aByteArray position: byteArrayPosition + (columnTypeSize*3).
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type >> thirdColumn [
	<accessor>
	^ thirdColumn
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type >> thirdColumn: anObject [
	<accessor>
	thirdColumn := anObject implicitCastTo: self class columnType
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type >> thirdRow [
	^ self class rowType x: firstColumn z y: secondColumn z z: thirdColumn z w: fourthColumn z
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix4x4Type >> topLeft3x3 [
	^ self class matrix3x3Type columns: {
		firstColumn xyz.
		secondColumn xyz.
		thirdColumn xyz.
	}
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type >> transpose [
	^ self class basicNew
		firstColumn: self firstRow;
		secondColumn: self secondRow;
		thirdColumn: self thirdRow;
		fourthColumn: self fourthRow;
		yourself
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
