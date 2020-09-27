Class {
	#name : #SysmelPrimitiveMatrix2x2Type,
	#superclass : #SysmelPrimitiveMatrixType,
	#instVars : [
		'firstColumn',
		'secondColumn'
	],
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #accessing }
SysmelPrimitiveMatrix2x2Type class >> columns [
	^ 2
]

{ #category : #accessing }
SysmelPrimitiveMatrix2x2Type class >> columns: columns [
	self assert: columns size = 2.
	^ self basicNew
		firstColumn: columns first;
		secondColumn: columns second;
		yourself
]

{ #category : #testing }
SysmelPrimitiveMatrix2x2Type class >> isAbstract [
	^ self == SysmelPrimitiveMatrix2x2Type
]

{ #category : #accessing }
SysmelPrimitiveMatrix2x2Type class >> rows [
	^ 2
]

{ #category : #enumerating }
SysmelPrimitiveMatrix2x2Type >> collect: aBlock [
	^ self class basicNew
		firstColumn: (aBlock value: firstColumn);
		secondColumn: (aBlock value: secondColumn);
		yourself
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
SysmelPrimitiveMatrix2x2Type >> secondColumn [
	^ secondColumn
]

{ #category : #accessing }
SysmelPrimitiveMatrix2x2Type >> secondColumn: anObject [
	secondColumn := anObject implicitCastTo: self class columnType
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
