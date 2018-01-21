as yet unclassified
value
	^ value ifNil: [ value := elements collect: #evaluateLiteralArrayElement ]