Class {
	#name : #MbndAstAbstractFieldAccessNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'aggregate',
		'field'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstAbstractFieldAccessNode >> aggregate [
	^ aggregate
]

{ #category : #accessing }
MbndAstAbstractFieldAccessNode >> aggregate: anObject [
	aggregate := anObject
]

{ #category : #accessing }
MbndAstAbstractFieldAccessNode >> field [
	^ field
]

{ #category : #accessing }
MbndAstAbstractFieldAccessNode >> field: anObject [
	field := anObject
]
