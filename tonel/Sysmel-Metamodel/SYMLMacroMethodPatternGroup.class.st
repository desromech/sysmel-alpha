Class {
	#name : #SYMLMacroMethodPatternGroup,
	#superclass : #SYMLFunctionalPatternGroup,
	#category : #'Sysmel-Metamodel-Macro'
}

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

{ #category : #'macro compilation' }
SYMLMacroMethodPatternGroup >> semanticAnalyzeMessage: message inEnvironment: environment at: aPosition [
	| checkedMessageAndPattern |
	checkedMessageAndPattern := self findValidPatternForMessage: message inEnvironment: environment at: aPosition.
	^ checkedMessageAndPattern second semanticAnalyzeMessage: checkedMessageAndPattern first inEnvironment: environment at: aPosition
]
