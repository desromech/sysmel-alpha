Class {
	#name : #MbndAstIdentifierReferenceNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'symbol'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstIdentifierReferenceNode >> accept: aVisitor [
	^ aVisitor visitIdentifierReferenceNode: self
]

{ #category : #converting }
MbndAstIdentifierReferenceNode >> asLiteralSymbolNodeFor: aCompilationTarget [
	^ MbndAstLiteralValueNode new
		value: symbol;
		type: aCompilationTarget literalSymbolType;
		yourself
]

{ #category : #serialization }
MbndAstIdentifierReferenceNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#symbol . symbol encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstIdentifierReferenceNode >> isGeneratedIdentifierNode [
	^ symbol isMbndGeneratedSymbol
]

{ #category : #testing }
MbndAstIdentifierReferenceNode >> isIdentifierReferenceNode [
	^ true
]

{ #category : #serialization }
MbndAstIdentifierReferenceNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	symbol := encodedFields at: #symbol.
]

{ #category : #parsing }
MbndAstIdentifierReferenceNode >> parseAsArgumentDefinition [
	^ MbndAstArgumentDefinitionNode new
		position: self;
		name: symbol;
		yourself
]

{ #category : #parsing }
MbndAstIdentifierReferenceNode >> parseAsFunctionArgumentsPrototype [
	^ { self parseAsArgumentDefinition }
]

{ #category : #accessing }
MbndAstIdentifierReferenceNode >> symbol [
	^ symbol
]

{ #category : #accessing }
MbndAstIdentifierReferenceNode >> symbol: anObject [
	symbol := anObject
]
