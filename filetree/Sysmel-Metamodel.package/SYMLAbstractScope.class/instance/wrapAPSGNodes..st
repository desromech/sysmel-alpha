as yet unclassified
wrapAPSGNodes: aCollectionOfNodes
	| type |
	type := self compilationTarget apsgNodeType.
	^ aCollectionOfNodes collect: [:node | node sysmelValueWithType: type inEnvironment: self]