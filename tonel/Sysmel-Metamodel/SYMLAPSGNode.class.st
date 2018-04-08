"
I  represent a node in an abstract program semantic graph.

I am like an AST node, but independent of syntax and on stereoids.

"
Class {
	#name : #SYMLAPSGNode,
	#superclass : #SYMLObject,
	#instVars : [
		'position'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #'meta evaluation' }
SYMLAPSGNode >> analyzeAndEvaluateInEnvironment: anEnvironment [
	^ (self semanticAnalysisInEnvironment: anEnvironment) evaluateInEnvironment: anEnvironment
]

{ #category : #converting }
SYMLAPSGNode >> asNodeForSequenceElementIn: anEnvironment [
	^ self
]

{ #category : #converting }
SYMLAPSGNode >> asNodeForTupleElementIn: anEnvironment [
	^ self
]

{ #category : #converting }
SYMLAPSGNode >> asSysmelSourcePosition [
	^ position
]

{ #category : #testing }
SYMLAPSGNode >> asSysmelValueInEnvironment: anEnvironment [
	^ self sysmelValueWithType: anEnvironment compilationTarget apsgNodeType inEnvironment: anEnvironment
]

{ #category : #'as yet unclassified' }
SYMLAPSGNode >> buildLiteralWithValue: aValue [
	^ SYMLAPSGLiteral new position: position; value: aValue; yourself
]

{ #category : #accessing }
SYMLAPSGNode >> children [
	^ #()
]

{ #category : #'as yet unclassified' }
SYMLAPSGNode >> concretizeSemanticAnalysisInEnvironment: anEnvironment [
	^ self
]

{ #category : #'meta evaluation' }
SYMLAPSGNode >> evaluateCleanTypeInEnvironment: anEnvironment [
	^ (self evaluateTypeInEnvironment: anEnvironment) cleanType
]

{ #category : #'meta evaluation' }
SYMLAPSGNode >> evaluateCleanValueTypeInEnvironment: anEnvironment [
	^ (self evaluateTypeInEnvironment: anEnvironment) ifNotNil: [:type | type valueType cleanType]
]

{ #category : #'meta evaluation' }
SYMLAPSGNode >> evaluateInEnvironment: anEnvironment [
	self subclassResponsibility
]

{ #category : #'meta evaluation' }
SYMLAPSGNode >> evaluateTypeInEnvironment: anEnvironment [
	^ nil
]

{ #category : #'meta evaluation' }
SYMLAPSGNode >> evaluateValueTypeInEnvironment: anEnvironment [
	^ (self evaluateTypeInEnvironment: anEnvironment) valueType
]

{ #category : #'meta evaluation' }
SYMLAPSGNode >> generateSSACodeWith: aBuilder [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SYMLAPSGNode >> gtInspectorModelNestingIn: composite [
	<gtInspectorPresentationOrder: 0>
	composite tree 
		title: 'APSG Tree';
		display: [ :root | self ];
		children: [ :each |
			each isSYMLAPSGNode ifTrue: [ 
				each inspectorChildren
			] ifFalse: [
				(each isKindOf: Association) ifTrue: [ each value ] ifFalse: [ #() ]
			] ];
		format: [ :each |
			(each isKindOf: Association)
				ifTrue: [ each key printString ]
				ifFalse: [ each printString]
		]
]

{ #category : #testing }
SYMLAPSGNode >> hasTypeInEnvironment: anEnvironment [
	^ (self evaluateTypeInEnvironment: anEnvironment) isNotNil
	
]

{ #category : #'as yet unclassified' }
SYMLAPSGNode >> inlineBlockSemanticAnalysisInEnvironment: environment [
	^ self semanticAnalysisInEnvironment: environment
	
]

{ #category : #accessing }
SYMLAPSGNode >> inspectorChildren [
	^ self children
]

{ #category : #testing }
SYMLAPSGNode >> isImplicitContextMessageNode [
	^ false
]

{ #category : #testing }
SYMLAPSGNode >> isLiteralNode [
	^ false
]

{ #category : #testing }
SYMLAPSGNode >> isMessageNode [
	^ false
]

{ #category : #testing }
SYMLAPSGNode >> isMetaObjectInstance [
	^ false
]

{ #category : #testing }
SYMLAPSGNode >> isSYMLAPSGNode [
	^ true
]

{ #category : #testing }
SYMLAPSGNode >> isSequenceNode [
	^ false
]

{ #category : #testing }
SYMLAPSGNode >> isTupleNode [
	^ false
]

{ #category : #accessing }
SYMLAPSGNode >> position [
	^ position asSysmelSourcePosition
]

{ #category : #accessing }
SYMLAPSGNode >> position: anObject [
	position := anObject asSysmelSourcePosition
]

{ #category : #'as yet unclassified' }
SYMLAPSGNode >> quoted [
	^ SYMLAPSGQuote new node: self; position: self; yourself
]

{ #category : #'meta evaluation' }
SYMLAPSGNode >> semanticAnalysisInEnvironment: anEnvironment [
	self subclassResponsibility
]

{ #category : #'meta evaluation' }
SYMLAPSGNode >> type [
	^ self evaluateTypeInEnvironment: nil
]
