Class {
	#name : #SYMLASTNode,
	#superclass : #Object,
	#instVars : [
		'position',
		'tokens'
	],
	#category : #'SysmelLanguage-Sysmel-AST'
}

{ #category : #'as yet unclassified' }
SYMLASTNode >> apsgNodeInEnvironment: anEnvironment [
	^ self buildMoebiusAST: anEnvironment apsgBuilder
]

{ #category : #converting }
SYMLASTNode >> asList [
	^ { self }
]

{ #category : #converting }
SYMLASTNode >> asMoebiusBandSourcePosition [
	^ position
]

{ #category : #converting }
SYMLASTNode >> buildMoebiusAST: builder [
	self subclassResponsibility
]

{ #category : #accessing }
SYMLASTNode >> children [
	^ #()
]

{ #category : #'as yet unclassified' }
SYMLASTNode >> evaluateInEnvironment: anEnvironment [
	^ (self apsgNodeInEnvironment: anEnvironment) evaluateInEnvironment: anEnvironment
]

{ #category : #'as yet unclassified' }
SYMLASTNode >> evaluateTypeInEnvironment: anEnvironment [
	^ (self apsgNodeInEnvironment: anEnvironment) evaluateTypeInEnvironment: anEnvironment
]

{ #category : #'as yet unclassified' }
SYMLASTNode >> gtInspectorModelNestingIn: composite [
	<gtInspectorPresentationOrder: 0>
	composite tree 
		title: 'AST';
		display: [ :root | self ];
		children: [ :each |
			each isSYMLASTNode ifTrue: [ 
				each children
			] ifFalse: [
				(each isKindOf: Association) ifTrue: [ each value ] ifFalse: [ #() ]
			] ];
		format: [ :each |
			(each isKindOf: Association)
				ifTrue: [ each key printString ]
				ifFalse: [ each printString]
		]
]

{ #category : #initialization }
SYMLASTNode >> initialize [
	super initialize.
	tokens := #().
	
]

{ #category : #testing }
SYMLASTNode >> isCommaSeparatedList [
	^ false
]

{ #category : #testing }
SYMLASTNode >> isIdentifierReference [
	^ false
]

{ #category : #testing }
SYMLASTNode >> isMessageNode [
	^ false
]

{ #category : #testing }
SYMLASTNode >> isParentExpression [
	^ false
]

{ #category : #testing }
SYMLASTNode >> isSYMLASTNode [
	^ true
]

{ #category : #accessing }
SYMLASTNode >> position [
	^ position
]

{ #category : #accessing }
SYMLASTNode >> position: anObject [
	position := anObject asMoebiusBandSourcePosition
]

{ #category : #'as yet unclassified' }
SYMLASTNode >> semanticAnalysisInEnvironment: anEnvironment [
	^ (self apsgNodeInEnvironment: anEnvironment) semanticAnalysisInEnvironment: anEnvironment
]

{ #category : #accessing }
SYMLASTNode >> sourceTextPosition [
	^ position sourceTextPosition
]

{ #category : #accessing }
SYMLASTNode >> tokens [
	^ tokens
]

{ #category : #accessing }
SYMLASTNode >> tokens: anObject [
	tokens := anObject
]
