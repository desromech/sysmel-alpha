accessing
module: anObject
	module := anObject.
	self
		fillWithBuiltInTypes;
		fillWithMetaBuilders;
		fillWithMetaMethods.
		
	fallbackToReceiver := SYMLFallbackToReceiverMetaMethod new compilationTarget: module compilationTarget