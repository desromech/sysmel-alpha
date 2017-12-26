as yet unclassified
wrapASTNodes: aCollectionOfNodes
	| type |
	type := self compilationTarget astNodeType.
	^ aCollectionOfNodes collect: [:node | node sysmelValueWithType: type  inEnvironment: self]