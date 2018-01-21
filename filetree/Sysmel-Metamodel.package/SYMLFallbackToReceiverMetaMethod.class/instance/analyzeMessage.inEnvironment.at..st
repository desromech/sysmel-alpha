meta methods
analyzeMessage: theMessageNode inEnvironment: anEnvironment at: aSourcePosition
	| receiverType messageNode receiver arguments metaMethod receiverValue |

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
	metaMethod := receiverType metaMethodForSelector: theMessageNode selector receiver: receiver arguments: arguments inEnvironment: anEnvironment at: aSourcePosition.
	metaMethod ifNotNil: [
		^ metaMethod analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition
	].

	"Now try by evaluating the arguments"
	arguments := arguments collect: [ :arg |
		arg semanticAnalysisInEnvironment: anEnvironment
	].
	messageNode := messageNode copy arguments: arguments.
	
	metaMethod := receiverType metaMethodForSelector: theMessageNode selector receiver: receiver arguments: arguments inEnvironment: anEnvironment at: aSourcePosition.
	metaMethod ifNotNil: [
		^ metaMethod analyzeMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition
	].

	anEnvironment error: 'Failed to find a meta method for {1} >>> {2} ' format: { receiverType printString . messageNode selector } at: aSourcePosition