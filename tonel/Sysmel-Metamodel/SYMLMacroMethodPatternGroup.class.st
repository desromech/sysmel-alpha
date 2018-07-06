Class {
	#name : #SYMLMacroMethodPatternGroup,
	#superclass : #SYMLFunctionalPatternGroup,
	#category : #'Sysmel-Metamodel-Macro'
}

{ #category : #'macro compilation' }
SYMLMacroMethodPatternGroup >> analyzeAndEvaluateMessage: message inEnvironment: environment at: aPosition [
	alternatives ifEmpty: [ ^ fallbackPattern analyzeAndEvaluateMessage: message inEnvironment: environment at: aPosition ].
	(alternatives size = 1 and: [fallbackPattern isNil ]) ifTrue: [ alternatives analyzeAndEvaluateMessage: message inEnvironment: environment at: aPosition ].
	^ super analyzeAndEvaluateMessage: message inEnvironment: environment at: aPosition
]

{ #category : #'macro compilation' }
SYMLMacroMethodPatternGroup >> analyzeMetaMessage: message toReceiver: receiverValue inEnvironment: environment at: aPosition [
	| checkedMessageAndPattern |
	checkedMessageAndPattern := self findValidPatternForMessage: message inEnvironment: environment at: aPosition.

	^ checkedMessageAndPattern second analyzeMetaMessage: checkedMessageAndPattern first toReceiver: receiverValue inEnvironment: environment at: aPosition
]

{ #category : #'method evaluation' }
SYMLMacroMethodPatternGroup >> evaluateWithReceiver: aReceiver arguments: activationArguments inEnvironment: environment at: aPosition [
	| pattern |
	pattern := self findValidPatternWithArgumentTypes: (activationArguments collect: #type) at: aPosition.
	^ pattern evaluateWithReceiver: aReceiver arguments: activationArguments inEnvironment: environment at: aPosition
]

{ #category : #'as yet unclassified' }
SYMLMacroMethodPatternGroup >> semanticAnalyzeApplicationAlternative: selectedAlternative message: message inEnvironment: environment at: aPosition [
	^ selectedAlternative semanticAnalyzeMessage: message inEnvironment: environment at: aPosition
]

{ #category : #'macro compilation' }
SYMLMacroMethodPatternGroup >> semanticAnalyzeMessage: message inEnvironment: environment at: aPosition [
	| checkedMessageAndPattern |
	checkedMessageAndPattern := self findValidPatternForMessage: message inEnvironment: environment at: aPosition.
	^ checkedMessageAndPattern second semanticAnalyzeMessage: checkedMessageAndPattern first inEnvironment: environment at: aPosition
]
