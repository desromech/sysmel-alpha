Extension { #name : #PPToken }

{ #category : #'*Sysmel-Parser' }
PPToken >> asSysmelSourcePosition [
	^ SYMLSourcePosition new
		collection: collection;
		start: start;
		stop: stop;
		yourself
]
