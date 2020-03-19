Class {
	#name : #MbndAstSymbolReference,
	#superclass : #MbndAstNode,
	#instVars : [
		'binding'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #accessing }
MbndAstSymbolReference >> binding [
	^ binding
]

{ #category : #accessing }
MbndAstSymbolReference >> binding: anObject [
	binding := anObject.
	type := binding type.
]

{ #category : #serialization }
MbndAstSymbolReference >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#binding . binding encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstSymbolReference >> isBoundIdentifierReferenceNode [
	^ true
]

{ #category : #serialization }
MbndAstSymbolReference >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	binding := encodedFields at: #binding.
]
