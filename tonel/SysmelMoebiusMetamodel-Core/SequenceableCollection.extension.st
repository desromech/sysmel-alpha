Extension { #name : #SequenceableCollection }

{ #category : #'*SysmelMoebiusMetamodel-Core' }
SequenceableCollection >> asMoebiusBandCollectionWithContext [
	^ MbndCollectionWithContext new collection: self
]
