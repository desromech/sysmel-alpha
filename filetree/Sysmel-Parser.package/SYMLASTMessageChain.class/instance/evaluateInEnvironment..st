as yet unclassified
evaluateInEnvironment: anEnvironment
	| result |
	result := nil.
	messages do: [ :message |
		result := message evaluateInEnvironment: anEnvironment withReceiver: receiver
	].

	^ result