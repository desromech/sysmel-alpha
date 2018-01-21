evaluating
cull: a1
	method numArgs < 1 ifTrue: [
		^ self value
	].
	^ method valueWithReceiver: nil arguments:  { a1 }