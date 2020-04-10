Class {
	#name : #MbndAstLiteralValueNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'value'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstLiteralValueNode >> accept: aVisitor [
	^ aVisitor visitLiteralValueNode: self
]

{ #category : #'as yet unclassified' }
MbndAstLiteralValueNode >> asIntervalPatternNode [
	^ MbndAstPatternMatchingIntervalPatternNode new
		position: self;
		start: value first;
		stop: value last;
		type: type;
		yourself
]

{ #category : #converting }
MbndAstLiteralValueNode >> asLiteralSymbolNodeFor: aCompilationTarget [
	<compileTime>
	<returnType: #_ASTNodeType>
	type isLiteralSymbolType ifTrue: [ ^ self ].
	^ super asLiteralSymbolNodeFor: aCompilationTarget
]

{ #category : #'as yet unclassified' }
MbndAstLiteralValueNode >> asLiteralValuePatternNode [
	^ MbndAstPatternMatchingLiteralValuePatternNode new
		position: self;
		value: value;
		type: type;
		yourself
]

{ #category : #'as yet unclassified' }
MbndAstLiteralValueNode >> asSetValuePatternNode [
	^ MbndAstPatternMatchingSetValuePatternNode new
		position: self;
		elements: value;
		type: type;
		yourself
]

{ #category : #serialization }
MbndAstLiteralValueNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#value . value encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #'as yet unclassified' }
MbndAstLiteralValueNode >> evaluateMbndValue [
	^ value asMoebiusValueWithType: type
]

{ #category : #testing }
MbndAstLiteralValueNode >> isLiteralSymbolValueNode [
	^ type isLiteralSymbolType
]

{ #category : #testing }
MbndAstLiteralValueNode >> isLiteralValueNode [
	^ true
]

{ #category : #serialization }
MbndAstLiteralValueNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	value := encodedFields at: #value.
]

{ #category : #printing }
MbndAstLiteralValueNode >> printValueString [
	^ value printString
]

{ #category : #accessing }
MbndAstLiteralValueNode >> value [
	^ value
]

{ #category : #accessing }
MbndAstLiteralValueNode >> value: anObject [
	value := anObject
]
