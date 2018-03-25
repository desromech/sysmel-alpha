Class {
	#name : #SYMLFallbackToReceiverMetaMethod,
	#superclass : #SYMLMetaMethod,
	#category : #Sysmel-Metamodel-MetaMethods
}

{ #category : #'meta methods' }
SYMLFallbackToReceiverMetaMethod >> analyzeMessage: theMessageNode inEnvironment: anEnvironment at: aSourcePosition [
	| receiverType messageNode receiver arguments metaMethod |

	messageNode := theMessageNode.
	receiver := messageNode receiver.
	receiverType := receiver evaluateTypeInEnvironment: anEnvironment.

	receiverType isNil ifTrue: [
		receiver := receiver semanticAnalysisInEnvironment: anEnvironment.
		messageNode := messageNode copy receiver: receiver.
		^ anEnvironment semanticAnalyzeMessage: messageNode at: aSourcePosition
	].

	"Try evaluating with just the AST nodes."
	arguments := messageNode arguments.
	metaMethod := receiverType metaMethodForMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition.
	metaMethod ifNotNil: [
		^ metaMethod analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition
	].

	"Now try with the evaluated arguments"
	messageNode hasAnalyzedArguments ifFalse: [ 
		messageNode := messageNode analyzeArgumentsInEnvironment: anEnvironment.
		^ anEnvironment semanticAnalyzeMessage: messageNode at: aSourcePosition
	].
	
	metaMethod := receiverType metaMethodForMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition.
	metaMethod ifNotNil: [
		^ metaMethod analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition
	].

	anEnvironment error: 'Failed to find a meta method for {1} >>> {2} ' format: { receiverType printString . messageNode selector } at: aSourcePosition
]
