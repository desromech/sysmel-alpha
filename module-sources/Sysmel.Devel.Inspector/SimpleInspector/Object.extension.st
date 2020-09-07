Extension { #name : #Object }

{ #category : #'*SimpleInspector' }
Object >> inspect [
	^ (SimpleInspector on: self)
		openWithSpec;
		yourself
]
