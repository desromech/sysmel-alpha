Extension { #name : #SequenceableCollection }

{ #category : #'*Sysmel-Metamodel' }
SequenceableCollection >> unwrapSysmelValue [
	^ self collect: #unwrapSysmelValue
]
