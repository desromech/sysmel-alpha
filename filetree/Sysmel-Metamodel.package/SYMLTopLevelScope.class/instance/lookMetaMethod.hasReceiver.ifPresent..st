meta methods
lookMetaMethod: identifier hasReceiver: hasReceiver ifPresent: aBlock
	hasReceiver ifTrue: [
		^ genericMetaMethods at: identifier ifPresent: aBlock
	] ifFalse: [
		^ implicitContextMetaMethods at: identifier ifPresent: aBlock
	]
	