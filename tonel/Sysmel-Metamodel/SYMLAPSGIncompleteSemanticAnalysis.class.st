Class {
	#name : #SYMLAPSGIncompleteSemanticAnalysis,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'action',
		'type',
		'incompleteValue'
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
	^ incompleteValue
]

{ #category : #'meta evaluation' }
SYMLAPSGIncompleteSemanticAnalysis >> evaluateTypeInEnvironment: anEnvironment [
	^ anEnvironment compilationTarget incompleteType
]

{ #category : #testing }
SYMLAPSGIncompleteSemanticAnalysis >> hasIncompleteSemanticAnalysis [
	^ true
]

{ #category : #accessing }
SYMLAPSGIncompleteSemanticAnalysis >> incompleteValue [
	^ incompleteValue
]

{ #category : #accessing }
SYMLAPSGIncompleteSemanticAnalysis >> incompleteValue: anObject [
	incompleteValue := anObject
]

{ #category : #'meta evaluation' }
SYMLAPSGIncompleteSemanticAnalysis >> macroExpansionInEnvironment: anEnvironment [
	^ self
]
