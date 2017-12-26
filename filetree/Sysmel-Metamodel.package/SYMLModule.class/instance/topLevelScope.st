evaluating
topLevelScope
	^ topLevelScope ifNil: [topLevelScope := SYMLTopLevelScope new module: self]