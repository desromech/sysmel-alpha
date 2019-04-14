Extension { #name : #Behavior }

{ #category : #'*SysmelMoebiusMetamodel-Core' }
Behavior >> asMoebiusType [
	^ Smalltalk moebiusBandModule typeForBehavior: self
]
