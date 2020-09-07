Class {
	#name : #MbndAstIdentifierReferenceNode,
	#superclass : #MbndAstNode,
	#traits : 'TMbndFlagContainer',
	#classTraits : 'TMbndFlagContainer classTrait',
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
	<compileTime>
	<returnType: #_ASTNodeType>
	^ MbndAstLiteralValueNode new
		value: symbol;
		type: aCompilationTarget literalSymbolType;
		yourself
]

{ #category : #serialization }
MbndAstIdentifierReferenceNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#symbol . symbol encodeGraphForMessagePackWith: graphEncoder.
		#flags . flags
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
	flags := encodedFields at: #flags.
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

{ #category : #serialization }
MbndAstIdentifierReferenceNode >> shouldBeAccessedAsDynamicObject [
	^ self hasFlag: #shouldBeAccessedAsDynamicObject
]

{ #category : #serialization }
MbndAstIdentifierReferenceNode >> shouldBeAccessedAsDynamicObject: aBoolean [
	self setFlag: #shouldBeAccessedAsDynamicObject value: aBoolean
]

{ #category : #accessing }
MbndAstIdentifierReferenceNode >> symbol [
	^ symbol
]

{ #category : #accessing }
MbndAstIdentifierReferenceNode >> symbol: anObject [
	symbol := anObject
]
