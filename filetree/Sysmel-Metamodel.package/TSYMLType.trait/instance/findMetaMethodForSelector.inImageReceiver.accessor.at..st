meta methods
findMetaMethodForSelector: aSelector inImageReceiver: aReceiver accessor: aReceiverAccessor at: aSourcePosition
	| compiledMethod actualReceiver |
	actualReceiver := aReceiver.
	aReceiverAccessor ifNotNil: [
		actualReceiver := actualReceiver perform: aReceiverAccessor
	].

	compiledMethod := actualReceiver class lookupSelector: aSelector.
	compiledMethod ifNil: [ ^ nil ].
	
	"Ensure this contains"
	(compiledMethod hasPragmaNamed: #compileTime) ifFalse: [ ^ nil ].
	
	^ (compiledMethod hasPragmaNamed: #lazy) ifTrue: [
		SYMLLazyMessageSendMetaMethod new
			compilationTarget: self compilationTarget;
			receiverAccessor: aReceiverAccessor;
			rewrite: (compiledMethod hasPragmaNamed: #rewrite);
			yourself
	] ifFalse: [ 
		SYMLNormalMessageSendMetaMethod new
			compilationTarget: self compilationTarget;
			receiverAccessor: aReceiverAccessor;
			rewrite: (compiledMethod hasPragmaNamed: #rewrite);
			yourself
	]