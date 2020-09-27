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

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type class >> columns [
	^ 3
]

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type class >> columns: columns [
	self assert: columns size = 3.
	^ self basicNew
		firstColumn: columns first;
		secondColumn: columns second;
		thirdColumn: columns third;
		yourself
]

{ #category : #testing }
SysmelPrimitiveMatrix3x3Type class >> isAbstract [
	^ self == SysmelPrimitiveMatrix3x3Type
]

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type class >> rows [
	^ 3
]

{ #category : #enumerating }
SysmelPrimitiveMatrix3x3Type >> collect: aBlock [
	^ self class basicNew
		firstColumn: (aBlock value: firstColumn);
		secondColumn: (aBlock value: secondColumn);
		thirdColumn: (aBlock value: thirdColumn);
		yourself
]

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type >> firstColumn [
	^ firstColumn
]

{ #category : #accessing }
SysmelPrimitiveMatrix3x3Type >> firstColumn: anObject [
	firstColumn := anObject implicitCastTo: self class columnType
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
