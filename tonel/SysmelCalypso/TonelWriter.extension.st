Extension { #name : #TonelWriter }

{ #category : #'*SysmelCalypso' }
TonelWriter >> writePartialSnapshot: aSnapshot [
	snapshot := aSnapshot.

	"now export classes"
	(snapshot definitions 
		select: #isClassDefinition)
		do: [ :each | self writeClass: each ].
	"... and method extensions"
	self writeMethodExtensions
]
