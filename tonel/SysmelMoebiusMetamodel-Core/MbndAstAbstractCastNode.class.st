Class {
	#name : #MbndAstAbstractCastNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'expression',
		'targetType'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #serialization }
MbndAstAbstractCastNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#expression . expression encodeGraphForMessagePackWith: graphEncoder.
		#targetType . targetType encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #accessing }
MbndAstAbstractCastNode >> expression [
	^ expression
]

{ #category : #accessing }
MbndAstAbstractCastNode >> expression: anObject [
	expression := anObject
]

{ #category : #testing }
MbndAstAbstractCastNode >> isAbstractCastNode [
	^ true
]

{ #category : #serialization }
MbndAstAbstractCastNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	expression := encodedFields at: #expression.
	targetType := encodedFields at: #targetType.
]

{ #category : #accessing }
MbndAstAbstractCastNode >> pragmaAt: pragmaName ifAbsent: absentBlock ifPresent: presentBlock [
	^ expression pragmaAt: pragmaName ifAbsent: absentBlock ifPresent: presentBlock
]

{ #category : #accessing }
MbndAstAbstractCastNode >> targetType [
	^ targetType
]

{ #category : #accessing }
MbndAstAbstractCastNode >> targetType: anObject [
	targetType := anObject
]
