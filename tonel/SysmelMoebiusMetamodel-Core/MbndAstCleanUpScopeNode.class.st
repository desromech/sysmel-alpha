Class {
	#name : #MbndAstCleanUpScopeNode,
	#superclass : #MbndAstNode,
	#instVars : [
		'expression',
		'cleanUpActions'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstCleanUpScopeNode >> accept: aVisitor [
	^ aVisitor visitCleanUpScopeNode: self
]

{ #category : #accessing }
MbndAstCleanUpScopeNode >> cleanUpActions [
	^ cleanUpActions
]

{ #category : #accessing }
MbndAstCleanUpScopeNode >> cleanUpActions: anObject [
	cleanUpActions := anObject
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
	cleanUpActions := #().
]

{ #category : #testing }
MbndAstCleanUpScopeNode >> isCleanUpScopeNode [
	^ true
]

{ #category : #accessing }
MbndAstCleanUpScopeNode >> pragmaAt: pragmaName ifAbsent: absentBlock ifPresent: presentBlock [
	^ expression pragmaAt: pragmaName ifAbsent: absentBlock ifPresent: presentBlock
]
