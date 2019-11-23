Class {
	#name : #MbndAstMatrixSetColumnValueNode,
	#superclass : #MbndAstAbstractMatrixAccessNode,
	#instVars : [
		'value'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstMatrixSetColumnValueNode >> accept: visitor [
	^ visitor visitMatrixSetColumnValueNode: self
]

{ #category : #testing }
MbndAstMatrixSetColumnValueNode >> isMatrixSetColumnValueNode [
	^ true
]

{ #category : #accessing }
MbndAstMatrixSetColumnValueNode >> value [
	^ value
]

{ #category : #accessing }
MbndAstMatrixSetColumnValueNode >> value: anObject [
	value := anObject
]
