accessing
module: anObject
	module := anObject.
	self
		fillWithBuiltInTypes;
		fillWithMetaBuilders;
		fillWithMetaMethods;
		fillWithObjects.
		
	fallbackToReceiver := SYMLFallbackToReceiverMetaMethod new compilationTarget: module compilationTarget