Class {
	#name : #MbndAstMatrixSetRowValueNode,
	#superclass : #MbndAstAbstractMatrixAccessNode,
	#instVars : [
		'value'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMatrixSetRowValueNode >> accept: visitor [
	^ visitor visitMatrixSetRowValueNode: self
]

{ #category : #testing }
MbndAstMatrixSetRowValueNode >> isMatrixSetRowValueNode [
	^ true
]

{ #category : #accessing }
MbndAstMatrixSetRowValueNode >> value [
	^ value
]

{ #category : #accessing }
MbndAstMatrixSetRowValueNode >> value: anObject [
	value := anObject
]
