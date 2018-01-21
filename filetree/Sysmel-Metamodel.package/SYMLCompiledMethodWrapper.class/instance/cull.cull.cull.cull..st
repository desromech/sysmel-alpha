evaluating
cull: a1 cull: a2 cull: a3 cull: a4
	method numArgs < 4 ifTrue: [
		^ self cull: a1 cull: a2 cull: a3
	].
	^ method valueWithReceiver: nil arguments:  { a1 . a2 . a3 . a4 }