Class {
	#name : #MbndAstBlockClosureNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'isBlockWithNonLocalReturn',
		'arguments',
		'returnType',
		'body',
		'blockClosureProgramEntity'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstBlockClosureNode >> accept: aVisitor [
	^ aVisitor visitBlockClosureNode: self
]

{ #category : #accessing }
MbndAstBlockClosureNode >> arguments [
	^ arguments
]

{ #category : #accessing }
MbndAstBlockClosureNode >> arguments: anObject [
	arguments := anObject
]

{ #category : #converting }
MbndAstBlockClosureNode >> asFunctionDefinitionNode [
	| prototype |
	prototype := MbndAstFunctionPrototypeNode new
		position: self;
		arguments: arguments;
		returnType: returnType;
		yourself.
	^ MbndAstFunctionDefinitionNode new
		position: self;
		prototype: prototype;
		body: body;
		yourself
]

{ #category : #accessing }
MbndAstBlockClosureNode >> blockClosureProgramEntity [
	^ blockClosureProgramEntity
]

{ #category : #accessing }
MbndAstBlockClosureNode >> blockClosureProgramEntity: anObject [
	blockClosureProgramEntity := anObject
]

{ #category : #accessing }
MbndAstBlockClosureNode >> body [
	^ body
]

{ #category : #accessing }
MbndAstBlockClosureNode >> body: anObject [
	body := anObject
]

{ #category : #serialization }
MbndAstBlockClosureNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#isBlockWithNonLocalReturn . isBlockWithNonLocalReturn.
		#arguments . arguments encodeGraphForMessagePackWith: graphEncoder.
		#returnType . returnType encodeGraphForMessagePackWith: graphEncoder.
		#body . body encodeGraphForMessagePackWith: graphEncoder.
		#blockClosureProgramEntity . blockClosureProgramEntity encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #initialization }
MbndAstBlockClosureNode >> initialize [
	super initialize.
	isBlockWithNonLocalReturn := true.
]

{ #category : #'as yet unclassified' }
MbndAstBlockClosureNode >> isBlockClosureNode [
	^ true
]

{ #category : #testing }
MbndAstBlockClosureNode >> isBlockClosureWithImmediateActivation [
	^ blockClosureProgramEntity isBlockClosureWithImmediateActivation
]

{ #category : #accessing }
MbndAstBlockClosureNode >> isBlockWithNonLocalReturn [
	^ isBlockWithNonLocalReturn
]

{ #category : #accessing }
MbndAstBlockClosureNode >> isBlockWithNonLocalReturn: anObject [
	isBlockWithNonLocalReturn := anObject
]

{ #category : #serialization }
MbndAstBlockClosureNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	isBlockWithNonLocalReturn := encodedFields at: #isBlockWithNonLocalReturn.
	arguments := encodedFields at: #arguments.
	returnType := encodedFields at: #returnType.
	body := encodedFields at: #body.
	blockClosureProgramEntity := encodedFields at: #blockClosureProgramEntity.
]

{ #category : #accessing }
MbndAstBlockClosureNode >> returnType [
	^ returnType
]

{ #category : #accessing }
MbndAstBlockClosureNode >> returnType: anObject [
	returnType := anObject
]
