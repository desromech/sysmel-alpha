Extension { #name : #Array }

{ #category : #converting }
Array >> copyWithDependent: newElement [
	self size = 0 ifTrue:[^DependentsArray with: newElement].
	^self copyWith: newElement
]
