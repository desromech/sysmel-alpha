meta methods
lookMetaMethod: identifier hasReceiver: hasReceiver ifPresent: ifPresentBlock ifAbsentPut: ifAbsentBlock
	hasReceiver ifTrue: [
		^ genericMetaMethods at: identifier ifPresent: ifPresentBlock ifAbsentPut: ifAbsentBlock
	] ifFalse: [
		^ implicitContextMetaMethods at: identifier ifPresent: ifPresentBlock ifAbsentPut: ifAbsentBlock
	]

	