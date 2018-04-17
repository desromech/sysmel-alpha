Class {
	#name : #SYMLAPSGAnalyzedMessageChain,
	#superclass : #SYMLAPSGMessageChain,
	#category : #'Sysmel-Metamodel-APSG'
}

{ #category : #'meta evaluation' }
SYMLAPSGAnalyzedMessageChain >> evaluateTypeInEnvironment: anEnvironment [
	^ messages last evaluateTypeInEnvironment: anEnvironment
]

{ #category : #'meta evaluation' }
SYMLAPSGAnalyzedMessageChain >> generateSSACodeWith: aBuilder [
	| result |
	result := receiver generateSSACodeWith: aBuilder.
	messages do: [ :message |
		result := message generateSSACodeWith: aBuilder
	].
	^ result
]

{ #category : #'meta evaluation' }
SYMLAPSGAnalyzedMessageChain >> semanticAnalysisInEnvironment: anEnvironment [
	^ self
]

{ #category : #'meta evaluation' }
SYMLAPSGAnalyzedMessageChain >> type [
	^ messages last type
]
