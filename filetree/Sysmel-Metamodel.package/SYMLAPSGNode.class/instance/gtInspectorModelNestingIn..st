as yet unclassified
gtInspectorModelNestingIn: composite
	<gtInspectorPresentationOrder: 0>
	composite tree 
		title: 'APSG Tree';
		display: [ :root | self ];
		children: [ :each |
			each isSYMLAPSGNode ifTrue: [ 
				each inspectorChildren
			] ifFalse: [
				(each isKindOf: Association) ifTrue: [ each value ] ifFalse: [ #() ]
			] ];
		format: [ :each |
			(each isKindOf: Association)
				ifTrue: [ each key printString ]
				ifFalse: [ each printString]
		]