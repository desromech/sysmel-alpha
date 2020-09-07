Extension { #name : #Dictionary }

{ #category : #'*SimpleInspector' }
Dictionary >> simpleInspectorEmitItemsInto: inspector [
	self keysAndValuesDo: [:key :value |
		inspector addKey: key value: value
   ].
]
