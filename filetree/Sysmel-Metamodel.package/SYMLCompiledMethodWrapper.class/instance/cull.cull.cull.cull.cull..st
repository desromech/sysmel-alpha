as yet unclassified
cull: a1 cull: a2 cull: a3 cull: a4 cull: a5
	method numArgs < 5 ifTrue: [
		^ self cull: a1 cull: a2 cull: a3 cull: a4
	].
	^ method valueWithReceiver: nil arguments:  { a1 . a2 . a3 . a4 . a5 }