Class {
	#name : #SysmelPrimitiveMatrix3x3Type,
	#superclass : #SysmelPrimitiveMatrixType,
	#instVars : [
		'firstColumn',
		'secondColumn',
		'thirdColumn'
	],
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #'special matrices' }
SysmelPrimitiveMatrix3x3Type class >> cieXYZD65ToRGB [
	^ self rows: #(
		3.24096994 -1.53738318 -0.49861076
		-0.96924364 1.8759675 0.04155506
		0.05563008 -0.20397696 1.05697151
	)
]

{ #category : #'special matrices' }
SysmelPrimitiveMatrix3x3Type class >> columnMajorIndices [
	^ self columns: #(0 1 2 3 4 5 6 7 8)
]

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type class >> columns [
	^ 3
]

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type class >> columns: columns [
	<constructor>
	columns size = 3 ifTrue: [ 
		^ self basicNew
			firstColumn: columns first;
			secondColumn: columns second;
			thirdColumn: columns third;
			yourself
	].
	columns size = 9 ifTrue: [ 
		^ self basicNew
			firstColumn: (self columnType x: columns first y: columns second z: columns third);
			secondColumn: (columnType x: columns fourth y: columns fifth z: columns sixth);
			thirdColumn: (columnType x: columns seventh y: columns eighth z: columns ninth);
			yourself
	].
	self error: 'Unsupported element count for matrix creation.'
]

{ #category : #'instance creation' }
SysmelPrimitiveMatrix3x3Type class >> identity [
	^ self basicNew
		firstColumn: (self columnType x: 1 y: 0 z: 0);
		secondColumn: (self columnType x: 0 y: 1 z: 0);
		thirdColumn: (self columnType x: 0 y: 0 z: 1);
		yourself

]

{ #category : #testing }
SysmelPrimitiveMatrix3x3Type class >> isAbstract [
	^ self == SysmelPrimitiveMatrix3x3Type
]

{ #category : #'special matrices' }
SysmelPrimitiveMatrix3x3Type class >> lookAtBack [
	^ self yRotation: Float pi
]

{ #category : #'special matrices' }
SysmelPrimitiveMatrix3x3Type class >> lookAtBottom [
	^ self xRotation: Float halfPi negated
]

{ #category : #'special matrices' }
SysmelPrimitiveMatrix3x3Type class >> lookAtDirection: direction up: upVector [
	| up f s u |
	up := upVector normalized.

	f := direction normalized.
	s := (direction cross: up) normalized.
	u := s cross: f.

	^ self columns: {s . u . f negated}.
]

{ #category : #'special matrices' }
SysmelPrimitiveMatrix3x3Type class >> lookAtFront [
	^ self identity
]

{ #category : #'special matrices' }
SysmelPrimitiveMatrix3x3Type class >> lookAtLeft [
	^ self yRotation: Float halfPi
]

{ #category : #'special matrices' }
SysmelPrimitiveMatrix3x3Type class >> lookAtRight [
	^ self yRotation: Float halfPi negated
]

{ #category : #'special matrices' }
SysmelPrimitiveMatrix3x3Type class >> lookAtTop [
	^ self yRotation: Float halfPi
]

{ #category : #'special matrices' }
SysmelPrimitiveMatrix3x3Type class >> ndcToTexcoord2D [
	^ self columns: #(
		0.5 0 0
		0 0.5 0
		0.5 0.5 1
	)
]

{ #category : #'special matrices' }
SysmelPrimitiveMatrix3x3Type class >> rgbToCieXYZD65 [
	^ self rows: #(
	0.41239080048064336 0.3575843413327116 0.18048078863120978
	0.2126390074514529 0.7151686808619413 0.07219231450020425
	0.01933081913945106 0.11919478122389784 0.9505321559112775
	)
]

{ #category : #'special matrices' }
SysmelPrimitiveMatrix3x3Type class >> rowMajorIndices [
	^ self rows: #(0 1 2 3 4 5 6 7 8)
]

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type class >> rows [
	^ 3
]

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type class >> rows: rows [
	rows size = 3 ifTrue: [ 
		^ self basicNew
			firstColumn: (self columnType x: rows first x y: rows second x z: rows third x);
			secondColumn: (self columnType x: rows first y y: rows second y z: rows third y);
			thirdColumn: (self columnType x: rows first z y: rows second z z: rows third z);
			yourself
	].
	rows size = 9 ifTrue: [ 
		^ self basicNew
			firstColumn: (self columnType x: rows first y: rows fourth z: rows seventh);
			secondColumn: (columnType x: rows second y: rows fifth z: rows eighth);
			thirdColumn: (columnType x: rows third y: rows sixth z: rows ninth);
			yourself
	].
	self error: 'Unsupported element count for matrix creation.'
]

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type class >> scale: scale [
	| coercedScale |
	coercedScale := scale implicitCastTo: self columnType.
	^ self basicNew
		firstColumn: (columnType x: coercedScale x y: 0 z: 0);
		secondColumn: (columnType x: 0 y: coercedScale y z: 0);
		thirdColumn: (columnType x: 0 y: 0 z: coercedScale z);
		yourself
]

{ #category : #'special matrices' }
SysmelPrimitiveMatrix3x3Type class >> scaleX: x y: y z: z [
	^ self basicNew
		firstColumn: (self columnType x: x y: 0 z: 0);
		secondColumn: (columnType x: 0 y: y z: 0);
		thirdColumn: (columnType x: 0 y: 0 z: z);
		yourself
]

{ #category : #'special matrices' }
SysmelPrimitiveMatrix3x3Type class >> texScale: scale offset: offset [
	| coercedScale coercedOffset |
	coercedScale := scale implicitCastTo: self vector2Type.
	coercedOffset := scale implicitCastTo: self vector2Type.
	^ self basicNew
		firstColumn: (self vector3Type x: coercedScale x y: 0 z: 0);
		secondColumn: (self vector3Type x: 0 y: coercedScale y z: 0);
		thirdColumn: (self vector3Type x: coercedOffset x y: coercedOffset y z: 1);
		yourself
]

{ #category : #'instance creation' }
SysmelPrimitiveMatrix3x3Type class >> withAll: value [
	^ self basicNew
		firstColumn: value;
		secondColumn: value;
		thirdColumn: value;
		yourself
]

{ #category : #'special matrices' }
SysmelPrimitiveMatrix3x3Type class >> xRotation: angle [
	| c s |
	c := angle cos.
	s := angle sin.
	^ self columns: {
		1. 0. 0.
		0. c. s.
		0. s negated. c
	}
]

{ #category : #'special matrices' }
SysmelPrimitiveMatrix3x3Type class >> xyzRotation: angles [
	^ (self xRotation: angles x) * (self yRotation: angles y) * (self zRotation: angles z)
]

{ #category : #'special matrices' }
SysmelPrimitiveMatrix3x3Type class >> yRotation: angle [
	| c s |
	c := angle cos.
	s := angle sin.
	^ self columns: {
		c. 0. s negated.
		0. 1. 0.
		s. 0. c
	}
]

{ #category : #'special matrices' }
SysmelPrimitiveMatrix3x3Type class >> zRotation: angle [
	| c s |
	c := angle cos.
	s := angle sin.
	^ self columns: {
		c. s. 0.
		s negated. c. 0.
		0. 0. 1
	}
]

{ #category : #'special matrices' }
SysmelPrimitiveMatrix3x3Type class >> zyxRotation: angles [
	^ (self zRotation: angles z) * (self yRotation: angles y) * (self xRotation: angles x)
]

{ #category : #comparing }
SysmelPrimitiveMatrix3x3Type >> = other [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	^ firstColumn = coercedOther firstColumn and: [
	  secondColumn = coercedOther secondColumn and: [
	  thirdColumn = coercedOther thirdColumn ]]
]

{ #category : #converting }
SysmelPrimitiveMatrix3x3Type >> asFloat32x3x3 [
	^ Float32x3x3 basicNew
		firstColumn: firstColumn asFloat32x3;
		secondColumn: secondColumn asFloat32x3;
		thirdColumn: thirdColumn asFloat32x3;
		yourself
]

{ #category : #converting }
SysmelPrimitiveMatrix3x3Type >> asFloat64x3x3 [
	^ Float64x3x3 basicNew
		firstColumn: firstColumn asFloat64x3;
		secondColumn: secondColumn asFloat64x3;
		thirdColumn: thirdColumn asFloat64x3;
		yourself
]

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type >> at: column [
	column = 1 ifTrue: [
		^ firstColumn
	].
	column = 2 ifTrue: [
		^ secondColumn
	].
	column = 3 ifTrue: [
		^ thirdColumn
	].
	self error
]

{ #category : #comparing }
SysmelPrimitiveMatrix3x3Type >> closeTo: other [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	^ (firstColumn closeTo: coercedOther firstColumn) and: [
	  (secondColumn closeTo: coercedOther secondColumn) and: [
	  thirdColumn closeTo: coercedOther thirdColumn ]]
]

{ #category : #comparing }
SysmelPrimitiveMatrix3x3Type >> closeTo: other precision: precision [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	^ (firstColumn closeTo: coercedOther firstColumn precision: precision) and: [
	  (secondColumn closeTo: coercedOther secondColumn precision: precision) and: [
	  thirdColumn closeTo: coercedOther thirdColumn precision: precision ]]
]

{ #category : #enumerating }
SysmelPrimitiveMatrix3x3Type >> collect: aBlock [
	^ self class basicNew
		firstColumn: (aBlock value: firstColumn);
		secondColumn: (aBlock value: secondColumn);
		thirdColumn: (aBlock value: thirdColumn);
		yourself
]

{ #category : #enumerating }
SysmelPrimitiveMatrix3x3Type >> collect: aBlock as: matrixType [
	^ matrixType basicNew
		firstColumn: (aBlock value: firstColumn);
		secondColumn: (aBlock value: secondColumn);
		thirdColumn: (aBlock value: thirdColumn);
		yourself
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix3x3Type >> determinant [
	^ firstColumn dot: (secondColumn cross: thirdColumn)
]

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type >> firstColumn [
	<accessor>
	^ firstColumn
]

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type >> firstColumn: anObject [
	<accessor>
	firstColumn := anObject implicitCastTo: self class columnType
]

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type >> firstRow [
	^ self class rowType x: firstColumn x y: secondColumn x z: thirdColumn x
]

{ #category : #comparing }
SysmelPrimitiveMatrix3x3Type >> hash [
	^ (firstColumn hash hashMultiply + secondColumn hash) hashMultiply + thirdColumn hash
]

{ #category : #operations }
SysmelPrimitiveMatrix3x3Type >> inverse [
	| det detVector |
	det := self determinant.
	self flag: 'Select a more appropiate epsilon here.'.
	det = 0 ifTrue: [ ^ self error: 'Matrix is not invertible.' ].
	"Formula from: https://en.wikipedia.org/wiki/Invertible_matrix#Inversion_of_3_%C3%97_3_matrices [30th September, 2020]"

	detVector := det implicitCastTo: self class columnType.
	^ self class rows: {
		(secondColumn cross: thirdColumn) / detVector.
		(thirdColumn cross: firstColumn) / detVector.
		(firstColumn cross: secondColumn) / detVector.
	}
]

{ #category : #testing }
SysmelPrimitiveMatrix3x3Type >> isIdentity [
	^ firstColumn x = 1 and: [
	  firstColumn y = 0 and: [
	  firstColumn z = 0 and: [

	  secondColumn x = 0 and: [
	  secondColumn y = 1 and: [
	  secondColumn z = 0 and: [
		
	  thirdColumn x = 0 and: [
	  thirdColumn y = 0 and: [
	  thirdColumn z = 1 ]]]]]]]]
]

{ #category : #testing }
SysmelPrimitiveMatrix3x3Type >> isOnes [
	^ firstColumn x = 1 and: [
	  firstColumn y = 1 and: [
	  firstColumn z = 1 and: [

	  secondColumn x = 1 and: [
	  secondColumn y = 1 and: [
	  secondColumn z = 1 and: [
		
	  thirdColumn x = 1 and: [
	  thirdColumn y = 1 and: [
	  thirdColumn z = 1 ]]]]]]]]
]

{ #category : #testing }
SysmelPrimitiveMatrix3x3Type >> isZeros [
	^ firstColumn x = 0 and: [
	  firstColumn y = 0 and: [
	  firstColumn z = 0 and: [

	  secondColumn x = 0 and: [
	  secondColumn y = 0 and: [
	  secondColumn z = 0 and: [
		
	  thirdColumn x = 0 and: [
	  thirdColumn y = 0 and: [
	  thirdColumn z = 0 ]]]]]]]]
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix3x3Type >> multiplyWithMatrix: other [
	| coerced |
	coerced := other implicitCastTo: self class.
	^ self class basicNew
		firstColumn: (firstColumn * coerced firstColumn x) + (secondColumn * coerced firstColumn y) + (thirdColumn * coerced firstColumn z);
		secondColumn: (firstColumn * coerced secondColumn x) + (secondColumn * coerced secondColumn y) + (thirdColumn * coerced secondColumn z);
		thirdColumn: (firstColumn * coerced thirdColumn x) + (secondColumn * coerced thirdColumn y) + (thirdColumn * coerced thirdColumn z);
		yourself

]

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix3x3Type >> postMultiplyVector: vector [
	| coercedVector |
	coercedVector := vector implicitCastTo: self class rowType.
	^ self class rowType
		x: (firstColumn dot: coercedVector)
		y: (secondColumn dot: coercedVector)
		z: (thirdColumn dot: coercedVector)
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix3x3Type >> preMultiplyVector: vector [
	| coercedVector |
	coercedVector := vector implicitCastTo: self class rowType.
	^ (firstColumn * coercedVector x) + (secondColumn * coercedVector y)
	+ (thirdColumn * coercedVector z)
]

{ #category : #printing }
SysmelPrimitiveMatrix3x3Type >> printOn: aStream [
	aStream nextPut: $(; nextPutAll: self class name; nextPutAll: ' rows: {'; cr;
		tab; print: self firstRow; nextPut: $.; cr;
		tab; print: self secondRow; nextPut: $.; cr;
		tab; print: self thirdRow; nextPut: $.; cr;
		nextPutAll: '})'
]

{ #category : #'memory access' }
SysmelPrimitiveMatrix3x3Type >> readBytesFrom: aByteArray size: readSize position: byteArrayPosition [
	| columnType columnTypeSize |
	columnType := self class columnType.
	columnTypeSize := columnType alignedInstanceSize.
	firstColumn := columnType newFromBytes: aByteArray position: byteArrayPosition.
	secondColumn := columnType newFromBytes: aByteArray position: byteArrayPosition + columnTypeSize.
	thirdColumn := columnType newFromBytes: aByteArray position: byteArrayPosition + (columnTypeSize*2).
]

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type >> secondColumn [
	<accessor>
	^ secondColumn
]

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type >> secondColumn: anObject [
	<accessor>
	secondColumn := anObject implicitCastTo: self class columnType
]

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type >> secondRow [
	^ self class rowType x: firstColumn y y: secondColumn y z: thirdColumn y
]

{ #category : #'memory access' }
SysmelPrimitiveMatrix3x3Type >> storeBytesIn: aByteArray position: byteArrayPosition [
	| columnType columnTypeSize |
	columnType := self class columnType.
	columnTypeSize := columnType alignedInstanceSize.
	columnType storeValue: firstColumn bytesIn: aByteArray position: byteArrayPosition.
	columnType storeValue: secondColumn bytesIn: aByteArray position: byteArrayPosition + columnTypeSize.
	columnType storeValue: thirdColumn bytesIn: aByteArray position: byteArrayPosition + (columnTypeSize*2).
]

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type >> thirdColumn [
	<accessor>
	^ thirdColumn
]

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type >> thirdColumn: anObject [
	<accessor>
	thirdColumn := anObject implicitCastTo: self class columnType
]

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type >> thirdRow [
	^ self class rowType x: firstColumn z y: secondColumn z z: thirdColumn z
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix3x3Type >> transformPosition2: vector [
	| coercedVector |
	coercedVector := vector implicitCastTo: self class vector2Type.
	^ ((firstColumn * coercedVector x) + (secondColumn * coercedVector y) + thirdColumn) xy
]

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix3x3Type >> transformVector2: vector [
	| coercedVector |
	coercedVector := vector implicitCastTo: self class vector2Type.
	^ ((firstColumn * coercedVector x) + (secondColumn * coercedVector y)) xy
]

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type >> transpose [
	^ self class basicNew
		firstColumn: self firstRow;
		secondColumn: self secondRow;
		thirdColumn: self thirdRow;
		yourself
]

{ #category : #enumerating }
SysmelPrimitiveMatrix3x3Type >> with: other collect: aBlock [
	| castedOther |
	castedOther := other implicitCastTo: self class.
	^ self class basicNew
		firstColumn: (aBlock value: firstColumn value: castedOther firstColumn);
		secondColumn: (aBlock value: secondColumn value: castedOther secondColumn);
		thirdColumn: (aBlock value: thirdColumn value: castedOther thirdColumn);
		yourself
]

{ #category : #comparing }
SysmelPrimitiveMatrix3x3Type >> ~= other [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	^ firstColumn ~= coercedOther firstColumn or: [
	  secondColumn ~= coercedOther secondColumn or: [
	  thirdColumn ~= coercedOther thirdColumn ]]
]
