Extension { #name : #Number }

{ #category : #accessing }
Integer >> digitSum [
    "Returns the digit sum of the receiver"

    ^self abs asString inject: 0 into: [:value :new| value + new digitValue]
]
