Class {
	#name : #MbndCompileTimeMetaBuilder,
	#superclass : #MbndMetaBuilder,
	#category : #'SysmelMoebiusMetamodel-Core-MetaBuilder'
}

{ #category : #'as yet unclassified' }
MbndCompileTimeMetaBuilder class >> globalBindingName [
	^ #compileTime
]

{ #category : #compiling }
MbndCompileTimeMetaBuilder >> compileLanguage: languageNameNode source: sourceStringNode [
	| languageName sourceString parsedSource |
	languageName := (metaBuilderAnalyzer evaluateCompileTimeExpression: languageNameNode) unwrapMbndValue.
	sourceString := (metaBuilderAnalyzer evaluateCompileTimeExpression: sourceStringNode) unwrapMbndValue.
	languageName isString ifFalse: [ self error: 'The supplied language name must be a string.' at: languageNameNode ].
	sourceString isString ifFalse: [ self error: 'The supplied source code must be a string.' at: sourceStringNode ].
	parsedSource := [
		metaBuilderScope module parseLanguage: languageName source: sourceString
	] on: Error do: [ :e |
		self error: 'Failed to parse embedded language {1} source
{2}

Error: {3}' format: { languageName printString . sourceString . e printString} at: position
	].

	^ metaBuilderAnalyzer visitNode: parsedSource ast
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
