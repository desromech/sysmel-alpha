Class {
	#name : #SYMLASTNode,
	#superclass : #SYMLObject,
	#instVars : [
		'position',
		'tokens'
	],
	#category : #'Sysmel-Parser-AST'
}

{ #category : #'as yet unclassified' }
SYMLASTNode >> apsgNodeInEnvironment: anEnvironment [
	^ self buildAPSG: anEnvironment apsgBuilder
]

{ #category : #converting }
SYMLASTNode >> asList [
	^ { self }
]

{ #category : #converting }
SYMLASTNode >> asSysmelSourcePosition [
	^ position
]

{ #category : #converting }
SYMLASTNode >> buildAPSG: builder [
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
SYMLASTNode >> isMessageNode [
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
	position := anObject asSysmelSourcePosition
]

{ #category : #'as yet unclassified' }
SYMLASTNode >> semanticAnalysisInEnvironment: anEnvironment [
	^ (self apsgNodeInEnvironment: anEnvironment) semanticAnalysisInEnvironment: anEnvironment
]

{ #category : #accessing }
SYMLASTNode >> tokens [
	^ tokens
]

{ #category : #accessing }
SYMLASTNode >> tokens: anObject [
	tokens := anObject
]
