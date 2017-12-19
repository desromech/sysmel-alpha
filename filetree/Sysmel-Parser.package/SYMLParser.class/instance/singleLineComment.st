accessing
singleLineComment
	^ super singleLineComment flatten ==> [ :data | data allButFirst: 2 ]