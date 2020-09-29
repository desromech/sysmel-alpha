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

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix3x3Type class >> columnMajorIndices [
	^ self columns: #(0 1 2 3 4 5 6 7 8)
]

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type class >> columns [
	^ 3
]

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type class >> columns: columns [
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

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix3x3Type class >> scaleX: x y: y z: z [
	^ self basicNew
		firstColumn: (self columnType x: x y: 0 z: 0);
		secondColumn: (columnType x: 0 y: y z: 0);
		thirdColumn: (columnType x: 0 y: 0 z: z);
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

{ #category : #comparing }
SysmelPrimitiveMatrix3x3Type >> = other [
	| coercedOther |
	coercedOther := other implicitCastTo: self class.
	^ firstColumn = coercedOther firstColumn and: [
	  secondColumn = coercedOther secondColumn and: [
	  thirdColumn = coercedOther thirdColumn ]]
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

{ #category : #'as yet unclassified' }
SysmelPrimitiveMatrix3x3Type >> determinant [
	^ firstColumn dot: (secondColumn cross: thirdColumn)
]

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type >> firstColumn [
	^ firstColumn
]

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type >> firstColumn: anObject [
	firstColumn := anObject implicitCastTo: self class columnType
]

{ #category : #comparing }
SysmelPrimitiveMatrix3x3Type >> hash [
	^ (firstColumn hash hashMultiply + secondColumn hash) hashMultiply + thirdColumn hash
]

{ #category : #operations }
SysmelPrimitiveMatrix3x3Type >> inverse [
	| det detVector |
	det := self determinant.
	(det closeTo: 0) ifTrue: [ ^ self error: 'Matrix is not invertible.' ].
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

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type >> secondColumn [
	^ secondColumn
]

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type >> secondColumn: anObject [
	secondColumn := anObject implicitCastTo: self class columnType
]

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type >> thirdColumn [
	^ thirdColumn
]

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type >> thirdColumn: anObject [
	thirdColumn := anObject implicitCastTo: self class columnType
]

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type >> transpose [
	^ self class rows: { firstColumn . secondColumn . thirdColumn }
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
