Extension { #name : #Collection }

{ #category : #'*SimpleInspector' }
Collection >> simpleInspectorEmitItemsInto: inspector [
	self doWithIndex: [:each :index |
		inspector addKey: index value: each
   ]
]
