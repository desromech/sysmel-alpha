Extension { #name : #PP2Token }

{ #category : #'*MoebiusBandMetamodel-Core' }
PP2Token >> asMoebiusBandSourcePosition [
	^ MbndSourcePosition new
		collection: collection;
		start: start;
		stop: stop;
		yourself
]
