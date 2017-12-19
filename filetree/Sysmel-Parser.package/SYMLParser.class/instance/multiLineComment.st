accessing
multiLineComment
	^ super multiLineComment flatten ==> [ :data | data copyFrom: 3 to: data size - 2 ]