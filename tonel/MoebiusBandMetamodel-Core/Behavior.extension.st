Extension { #name : #Behavior }

{ #category : #'*MoebiusBandMetamodel-Core' }
Behavior >> asMoebiusType [
	^ Smalltalk moebiusBandModule typeForBehavior: self
]
