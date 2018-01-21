evaluating
cull: a1 cull: a2
	method numArgs < 2 ifTrue: [
		^ self cull: a1
	].
	^ method valueWithReceiver: nil arguments:  { a1 . a2 }