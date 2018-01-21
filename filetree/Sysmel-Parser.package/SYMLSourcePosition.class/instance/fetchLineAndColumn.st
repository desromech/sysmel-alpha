accessing
fetchLineAndColumn
	| lineColumn |
	(collection isNil or: [collection isString]) ifTrue: [
		line := 0.
		column := 0.
		^ self
	].

	lineColumn := collection lineColumnAt: start.
	line := lineColumn first.
	column := lineColumn second.