Extension { #name : #PP2Token }

{ #category : #'*Sysmel-Parser' }
PP2Token >> asSysmelSourcePosition [
	^ SYMLSourcePosition new
		collection: collection;
		start: start;
		stop: stop;
		yourself
]
