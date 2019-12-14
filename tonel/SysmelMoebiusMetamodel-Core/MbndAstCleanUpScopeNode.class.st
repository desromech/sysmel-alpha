Class {
	#name : #MbndAstCleanUpScopeNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'expression',
		'nodesWithImplicitFinalization',
		'explicitCleanUpActions'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstCleanUpScopeNode >> accept: aVisitor [
	^ aVisitor visitCleanUpScopeNode: self
]

{ #category : #adding }
MbndAstCleanUpScopeNode >> addNodeWithImplicitFinalization: node [
	self nodesWithImplicitFinalization add: node
]

{ #category : #accessing }
MbndAstCleanUpScopeNode >> explicitCleanUpActions [
	^ explicitCleanUpActions
]

{ #category : #accessing }
MbndAstCleanUpScopeNode >> explicitCleanUpActions: anObject [
	explicitCleanUpActions := anObject
]

{ #category : #accessing }
MbndAstCleanUpScopeNode >> expression [
	^ expression
]

{ #category : #accessing }
MbndAstCleanUpScopeNode >> expression: anObject [
	expression := anObject
]

{ #category : #initialization }
MbndAstCleanUpScopeNode >> initialize [
	super initialize.
	explicitCleanUpActions := #().
]

{ #category : #testing }
MbndAstCleanUpScopeNode >> isCleanUpScopeNode [
	^ true
]

{ #category : #accessing }
MbndAstCleanUpScopeNode >> nodesWithImplicitFinalization [
	^ nodesWithImplicitFinalization ifNil: [ nodesWithImplicitFinalization := OrderedCollection new ]
]

{ #category : #copying }
MbndAstCleanUpScopeNode >> postCopy [
	nodesWithImplicitFinalization := nodesWithImplicitFinalization copy
]

{ #category : #accessing }
MbndAstCleanUpScopeNode >> pragmaAt: pragmaName ifAbsent: absentBlock ifPresent: presentBlock [
	^ expression pragmaAt: pragmaName ifAbsent: absentBlock ifPresent: presentBlock
]

{ #category : #composition }
MbndAstCleanUpScopeNode >> withNextExpression: anotherNode [
	<compileTime>
	<returnType: #_ASTNodeType>
	^ self copy
		expression: (expression withNextExpression: anotherNode);
		yourself
]
