Class {
	#name : #MbndPrimitiveMatrixType,
	#superclass : #MbndPrimitiveType,
	#instVars : [
		'elementType',
		'rows',
		'columns'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndPrimitiveMatrixType class >> typeName [
	^ #_PrimitiveMatrixType
]

{ #category : #visiting }
MbndPrimitiveMatrixType >> accept: visitor [
	^ visitor visitPrimitiveMatrixType: self
]

{ #category : #adding }
MbndPrimitiveMatrixType >> addArithmeticOperationCoercionMacro: selector [
	self flag: 'TODO: implement this'
]

{ #category : #accessing }
MbndPrimitiveMatrixType >> columns [
	^ columns
]

{ #category : #accessing }
MbndPrimitiveMatrixType >> columns: anObject [
	columns := anObject
]

{ #category : #accessing }
MbndPrimitiveMatrixType >> elementType [
	^ elementType
]

{ #category : #accessing }
MbndPrimitiveMatrixType >> elementType: anObject [
	elementType := anObject
]

{ #category : #'testing methods' }
MbndPrimitiveMatrixType >> isPrimitiveMatrixType [
	^ true
]

{ #category : #accessing }
MbndPrimitiveMatrixType >> rows [
	^ rows
]

{ #category : #accessing }
MbndPrimitiveMatrixType >> rows: anObject [
	rows := anObject
]
