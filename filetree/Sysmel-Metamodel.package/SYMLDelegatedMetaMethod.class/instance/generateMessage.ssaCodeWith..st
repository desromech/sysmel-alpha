meta methods
generateMessage: messageNode ssaCodeWith: builder
	^ codeGenerationFunction valueWithReceiver: self arguments: { messageNode . builder}