as yet unclassified
evaluateInEnvironment: anEnvironment
	| result receiverValue |
	result := nil.
	receiverValue := anEnvironment wrapAPSGNode: receiver.
	messages do: [ :message |
		result := message evaluateInEnvironment: anEnvironment withReceiver: receiverValue
	].

	^ result