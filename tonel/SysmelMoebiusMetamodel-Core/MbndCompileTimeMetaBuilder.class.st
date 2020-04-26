Class {
	#name : #MbndCompileTimeMetaBuilder,
	#superclass : #MbndMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndCompileTimeMetaBuilder class >> globalBindingName [
	^ #compileTime
]

{ #category : #accessing }
MbndCompileTimeMetaBuilder >> constant [
	^ self delegateToMetaBuilder: MbndCompileTimeConstantMetaBuilder new
]

{ #category : #'as yet unclassified' }
MbndCompileTimeMetaBuilder >> if: conditionNode then: thenNode [
	^ self if: conditionNode then: thenNode else: ((currentAnalyzer astBuilder literalVoid)
		position: conditionNode position)
]

{ #category : #'as yet unclassified' }
MbndCompileTimeMetaBuilder >> if: conditionNode then: thenNode else: elseNode [
	| condition |
	condition := (currentAnalyzer evaluateCompileTimeExpression: conditionNode) unwrapMbndValue.
	condition == true ifTrue: [ ^ currentAnalyzer analyzeNodeIfNeeded: thenNode ].
	condition == false ifTrue: [ ^ currentAnalyzer analyzeNodeIfNeeded: elseNode ].
	currentAnalyzer error: 'Compile time condition must evaluate to a boolean value instead of: {1}.' format: { condition asString } at: conditionNode
]

{ #category : #accessing }
MbndCompileTimeMetaBuilder >> parsePatternNode: patternNode [
	^ (currentAnalyzer parsePatternMatchingPatternNode: patternNode) asMoebiusLiteralValueNodeWithTarget: currentAnalyzer compilationTarget
]
