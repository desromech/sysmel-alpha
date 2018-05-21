Class {
	#name : #SYMLAPSGIncompleteSemanticAnalysis,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'action',
		'type'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #accessing }
SYMLAPSGIncompleteSemanticAnalysis >> action [
	^ action
]

{ #category : #accessing }
SYMLAPSGIncompleteSemanticAnalysis >> action: anObject [
	action := anObject
]

{ #category : #'as yet unclassified' }
SYMLAPSGIncompleteSemanticAnalysis >> concretizeSemanticAnalysisInEnvironment: anEnvironment [
	^ action value: anEnvironment
]

{ #category : #'meta evaluation' }
SYMLAPSGIncompleteSemanticAnalysis >> evaluateInEnvironment: anEnvironment [
	self halt
]

{ #category : #'meta evaluation' }
SYMLAPSGIncompleteSemanticAnalysis >> evaluateTypeInEnvironment: anEnvironment [
	^ anEnvironment compilationTarget incompleteType
]

{ #category : #testing }
SYMLAPSGIncompleteSemanticAnalysis >> hasIncompleteSemanticAnalysis [
	^ true
]

{ #category : #'meta evaluation' }
SYMLAPSGIncompleteSemanticAnalysis >> macroExpansionInEnvironment: anEnvironment [
	^ self
]
