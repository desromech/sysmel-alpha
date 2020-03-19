Class {
	#name : #MbndAstExceptionScopeNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'expression',
		'catchExpressions',
		'nodesWithImplicitFinalization',
		'explicitCleanUpActions'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstExceptionScopeNode >> accept: aVisitor [
	^ aVisitor visitExceptionScopeNode: self
]

{ #category : #adding }
MbndAstExceptionScopeNode >> addNodeWithImplicitFinalization: node [
	self nodesWithImplicitFinalization add: node
]

{ #category : #accessing }
MbndAstExceptionScopeNode >> catchExpressions [
	^ catchExpressions
]

{ #category : #accessing }
MbndAstExceptionScopeNode >> catchExpressions: anObject [
	catchExpressions := anObject
]

{ #category : #serialization }
MbndAstExceptionScopeNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#expression . expression encodeGraphForMessagePackWith: graphEncoder.
		#catchExpressions . catchExpressions encodeGraphForMessagePackWith: graphEncoder.
		#nodesWithImplicitFinalization . nodesWithImplicitFinalization encodeGraphForMessagePackWith: graphEncoder.
		#explicitCleanUpActions . explicitCleanUpActions encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
]

{ #category : #accessing }
MbndAstExceptionScopeNode >> explicitCleanUpActions [
	^ explicitCleanUpActions
]

{ #category : #accessing }
MbndAstExceptionScopeNode >> explicitCleanUpActions: anObject [
	explicitCleanUpActions := anObject
]

{ #category : #accessing }
MbndAstExceptionScopeNode >> expression [
	^ expression
]

{ #category : #accessing }
MbndAstExceptionScopeNode >> expression: anObject [
	expression := anObject
]

{ #category : #initialization }
MbndAstExceptionScopeNode >> initialize [
	super initialize.
	catchExpressions := #().
	explicitCleanUpActions := #().
]

{ #category : #testing }
MbndAstExceptionScopeNode >> isExceptionScopeNode [
	^ true
]

{ #category : #'as yet unclassified' }
MbndAstExceptionScopeNode >> markStorageCreationNodeForCopyEllision: node [
	expression markStorageCreationNodeForCopyEllision: node
]

{ #category : #serialization }
MbndAstExceptionScopeNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	expression := encodedFields at: #expression.
	catchExpressions := encodedFields at: #catchExpressions.
	nodesWithImplicitFinalization := encodedFields at: #nodesWithImplicitFinalization.
	explicitCleanUpActions := encodedFields at: #explicitCleanUpActions.
]

{ #category : #accessing }
MbndAstExceptionScopeNode >> nodesWithImplicitFinalization [
	^ nodesWithImplicitFinalization ifNil: [ nodesWithImplicitFinalization := OrderedCollection new ]
]

{ #category : #copying }
MbndAstExceptionScopeNode >> postCopy [
	nodesWithImplicitFinalization := nodesWithImplicitFinalization copy
]

{ #category : #accessing }
MbndAstExceptionScopeNode >> pragmaAt: pragmaName ifAbsent: absentBlock ifPresent: presentBlock [
	^ expression pragmaAt: pragmaName ifAbsent: absentBlock ifPresent: presentBlock
]

{ #category : #composition }
MbndAstExceptionScopeNode >> withNextExpression: anotherNode [
	<compileTime>
	<returnType: #_ASTNodeType>
	^ self copy
		expression: (expression withNextExpression: anotherNode);
		yourself
]
