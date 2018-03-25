Extension { #name : #SequenceableCollection }

{ #category : #'*Sysmel-Parser' }
SequenceableCollection >> asSysmelCollectionWithContext [
	^ SYMLCollectionWithContext new collection: self
]
