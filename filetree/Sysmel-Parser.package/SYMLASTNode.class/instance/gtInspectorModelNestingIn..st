as yet unclassified
gtInspectorModelNestingIn: composite
	<gtInspectorPresentationOrder: 0>
	composite tree 
		title: 'AST';
		display: [ :root | self ];
		children: [ :each |
			each isSYMLASTNode ifTrue: [ 
				each children
			] ifFalse: [
				(each isKindOf: Association) ifTrue: [ each value ] ifFalse: [ #() ]
			] ];
		format: [ :each |
			(each isKindOf: Association)
				ifTrue: [ each key printString ]
				ifFalse: [ each printString]
		]