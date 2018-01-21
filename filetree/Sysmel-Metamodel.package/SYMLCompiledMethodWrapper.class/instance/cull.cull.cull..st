evaluating
cull: a1 cull: a2 cull: a3
	method numArgs < 3 ifTrue: [
		^ self cull: a1 cull: a2
	].
	^ method valueWithReceiver: nil arguments:  { a1 . a2 . a3 }