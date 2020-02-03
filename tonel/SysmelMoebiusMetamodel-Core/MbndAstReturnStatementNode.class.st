Class {
	#name : #MbndAstReturnStatementNode,
	#superclass : #MbndAstStatementNode,
	#instVars : [
		'expression',
		'implicitReturn',
		'isInImmediatelyActivatedClosure',
		'expectedReturnType',
		'nonLocalReturnTarget',
		'nonLocalResultVariable'
	],
	#category : #'SysmelMoebiusMetamodel-Core-AST'
}

{ #category : #visiting }
MbndAstReturnStatementNode >> accept: aVisitor [
	^ aVisitor visitReturnStatementNode: self
]

{ #category : #accessing }
MbndAstReturnStatementNode >> expectedReturnType [
	^ expectedReturnType
]

{ #category : #accessing }
MbndAstReturnStatementNode >> expectedReturnType: anObject [
	expectedReturnType := anObject
]

{ #category : #accessing }
MbndAstReturnStatementNode >> expression [
	^ expression
]

{ #category : #accessing }
MbndAstReturnStatementNode >> expression: anObject [
	expression := anObject
]

{ #category : #accessing }
MbndAstReturnStatementNode >> implicitReturn [
	^ implicitReturn
]

{ #category : #accessing }
MbndAstReturnStatementNode >> implicitReturn: anObject [
	implicitReturn := anObject
]

{ #category : #initialization }
MbndAstReturnStatementNode >> initialize [
	super initialize.
	implicitReturn := false.
	isInImmediatelyActivatedClosure := false.
]

{ #category : #accessing }
MbndAstReturnStatementNode >> isInImmediatelyActivatedClosure [
	^ isInImmediatelyActivatedClosure
]

{ #category : #accessing }
MbndAstReturnStatementNode >> isInImmediatelyActivatedClosure: anObject [
	isInImmediatelyActivatedClosure := anObject
]

{ #category : #testing }
MbndAstReturnStatementNode >> isReturnStatementNode [
	^ true
]

{ #category : #accessing }
MbndAstReturnStatementNode >> nonLocalResultVariable [
	^ nonLocalResultVariable
]

{ #category : #accessing }
MbndAstReturnStatementNode >> nonLocalResultVariable: anObject [
	nonLocalResultVariable := anObject
]

{ #category : #accessing }
MbndAstReturnStatementNode >> nonLocalReturnTarget [
	^ nonLocalReturnTarget
]

{ #category : #accessing }
MbndAstReturnStatementNode >> nonLocalReturnTarget: anObject [
	nonLocalReturnTarget := anObject
]

{ #category : #accessing }
MbndAstReturnStatementNode >> pragmaAt: pragmaName ifAbsent: absentBlock ifPresent: presentBloc [
	implicitReturn ifTrue: [ ^ expression pragmaAt: pragmaName ifAbsent: absentBlock ifPresent: presentBloc ].
	^ super pragmaAt: pragmaName ifAbsent: absentBlock ifPresent: presentBloc
]
