tokens
integerNumber
	^ self token: numberSign optional, #digit asParser plus