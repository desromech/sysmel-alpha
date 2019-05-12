Class {
	#name : #MbndAstGenericCastNode,
	#superclass : #MbndAstAbstractCastNode,
	#instVars : [
		'typeConversionRule'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #testing }
MbndAstGenericCastNode >> isGenericCastNode [
	^ true
]

{ #category : #accessing }
MbndAstGenericCastNode >> typeConversionRule [
	^ typeConversionRule
]

{ #category : #accessing }
MbndAstGenericCastNode >> typeConversionRule: anObject [
	typeConversionRule := anObject
]
