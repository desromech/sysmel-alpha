Class {
	#name : #SysmelPrimitiveMatrix4x4Type,
	#superclass : #SysmelPrimitiveMatrixType,
	#instVars : [
		'firstColumn',
		'secondColumn',
		'thirdColumn',
		'fourthColumn'
	],
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type class >> columns [
	^ 4
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type class >> columns: columns [
	self assert: columns size = 4.
	^ self basicNew
		firstColumn: columns first;
		secondColumn: columns second;
		thirdColumn: columns third;
		fourthColumn: columns fourth;
		yourself
]

{ #category : #testing }
SysmelPrimitiveMatrix4x4Type class >> isAbstract [
	^ self == SysmelPrimitiveMatrix4x4Type
]

{ #category : #accessing }
SysmelPrimitiveMatrix4x4Type class >> rows [
	^ 4
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
