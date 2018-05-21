Class {
	#name : #SYMLAPSGLiteralWithLazyType,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'value',
		'typeSelector',
		'environment'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #accessing }
SYMLAPSGLiteralWithLazyType >> environment [
	^ environment
]

{ #category : #accessing }
SYMLAPSGLiteralWithLazyType >> environment: anObject [
	environment := anObject
]

{ #category : #'meta evaluation' }
SYMLAPSGLiteralWithLazyType >> macroExpansionInEnvironment: anEnvironment [
	^ self
]

{ #category : #'meta evaluation' }
SYMLAPSGLiteralWithLazyType >> semanticAnalysisInEnvironment: anEnvironment [
	^ SYMLAPSGLiteral new
		position: position;
		value: (value sysmelValueWithType: (anEnvironment compilationTarget perform: typeSelector) inEnvironment: anEnvironment);
		yourself
]

{ #category : #accessing }
SYMLAPSGLiteralWithLazyType >> typeSelector [
	^ typeSelector
]

{ #category : #accessing }
SYMLAPSGLiteralWithLazyType >> typeSelector: anObject [
	typeSelector := anObject
]

{ #category : #accessing }
SYMLAPSGLiteralWithLazyType >> value [
	^ value
]

{ #category : #accessing }
SYMLAPSGLiteralWithLazyType >> value: anObject [
	value := anObject
]
