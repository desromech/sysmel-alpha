evaluating
moduleScope
	^ SYMLNamespaceScope new
		parent: self topLevelScope;
		namespace: globalNamespace;
		yourself