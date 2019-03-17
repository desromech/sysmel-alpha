Extension { #name : #SequenceableCollection }

{ #category : #'*MoebiusBandMetamodel-Core' }
SequenceableCollection >> asMoebiusBandCollectionWithContext [
	^ MbndCollectionWithContext new collection: self
]
