Class {
	#name : #MbndAstLexicalScopeNode,
	#superclass : #MbndAstExceptionScopeNode,
	#instVars : [
		'lexicalScope'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstLexicalScopeNode >> accept: aVisitor [
	^ aVisitor visitLexicalScopeNode: self
]

{ #category : #serialization }
MbndAstLexicalScopeNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#lexicalScope . lexicalScope encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #testing }
MbndAstLexicalScopeNode >> isLexicalScopeNode [
	^ true
]

{ #category : #accessing }
MbndAstLexicalScopeNode >> lexicalScope [
	^ lexicalScope
]

{ #category : #accessing }
MbndAstLexicalScopeNode >> lexicalScope: anObject [
	lexicalScope := anObject
]

{ #category : #'as yet unclassified' }
MbndAstLexicalScopeNode >> lexicallyScoped [
	^ self
]

{ #category : #serialization }
MbndAstLexicalScopeNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	lexicalScope := encodedFields at: #lexicalScope.
]
