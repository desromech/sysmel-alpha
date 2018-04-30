Class {
	#name : #SYMLAPSGLocalInitialization,
	#superclass : #SYMLAPSGNode,
	#instVars : [
		'local',
		'initialization'
	],
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #'meta evaluation' }
SYMLAPSGLocalInitialization >> evaluateTypeInEnvironment: anEnvironment [
	^ local referenceType
]

{ #category : #'meta evaluation' }
SYMLAPSGLocalInitialization >> generateSSACodeWith: aBuilder [
	| localReference |
	aBuilder withDebugPosition: self position do: [
		initialization ifNotNil: [
			initialization generateSSACodeWith: aBuilder
		].

		localReference := local generateSSAReferenceWith: aBuilder.
		aBuilder compilationTarget emittingDebugInformation ifTrue: [ 
			(aBuilder debugDeclareVariable: localReference)
				debugInformation: local createSSADebugInformation
		].
		
		^ localReference
	]
]

{ #category : #accessing }
SYMLAPSGLocalInitialization >> initialization [
	^ initialization
]

{ #category : #accessing }
SYMLAPSGLocalInitialization >> initialization: anObject [
	initialization := anObject
]

{ #category : #accessing }
SYMLAPSGLocalInitialization >> local [
	^ local
]

{ #category : #accessing }
SYMLAPSGLocalInitialization >> local: anObject [
	local := anObject
]

{ #category : #'meta evaluation' }
SYMLAPSGLocalInitialization >> semanticAnalysisInEnvironment: anEnvironment [
	^ self
]
