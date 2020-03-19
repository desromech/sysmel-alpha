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

{ #category : #serialization }
MbndAstReturnStatementNode >> encodeFieldsForMessagePackWith: graphEncoder [
	^ {
		#expression . expression encodeGraphForMessagePackWith: graphEncoder.
		#implicitReturn. implicitReturn encodeGraphForMessagePackWith: graphEncoder.
		#isInImmediatelyActivatedClosure. isInImmediatelyActivatedClosure.
		#expectedReturnType. expectedReturnType encodeGraphForMessagePackWith: graphEncoder.
		#nonLocalReturnTarget. nonLocalReturnTarget encodeGraphForMessagePackWith: graphEncoder.
		#nonLocalResultVariable . nonLocalResultVariable encodeGraphForMessagePackWith: graphEncoder.
	} , (super encodeFieldsForMessagePackWith: graphEncoder)
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

{ #category : #serialization }
MbndAstReturnStatementNode >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
	super materializeWithGraphDecoder: graphDecoder withFields: encodedFields.
	expression := encodedFields at: #expression.
	implicitReturn := encodedFields at: #implicitReturn.
	isInImmediatelyActivatedClosure := encodedFields at: #isInImmediatelyActivatedClosure.
	expectedReturnType := encodedFields at: #expectedReturnType.
	nonLocalReturnTarget := encodedFields at: #nonLocalReturnTarget.
	nonLocalResultVariable := encodedFields at: #nonLocalResultVariable.
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
