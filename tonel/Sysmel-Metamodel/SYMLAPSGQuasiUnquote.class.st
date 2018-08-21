Class {
	#name : #SYMLAPSGQuasiUnquote,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'node'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #testing }
SYMLAPSGQuasiUnquote >> isQuasiUnquote [
	^ true
]

{ #category : #'meta evaluation' }
SYMLAPSGQuasiUnquote >> macroExpansionInEnvironment: anEnvironment [
	^ node macroExpansionEvaluateInEnvironment: anEnvironment
]

{ #category : #accessing }
SYMLAPSGQuasiUnquote >> node [
	^ node
]

{ #category : #accessing }
SYMLAPSGQuasiUnquote >> node: anObject [
	node := anObject
]
