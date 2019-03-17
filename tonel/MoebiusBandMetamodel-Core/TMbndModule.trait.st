Trait {
	#name : #TMbndModule,
	#instVars : [
		'globalNamespace'
	],
	#category : #'MoebiusBandMetamodel-Core-Module'
}

{ #category : #accessing }
TMbndModule >> compilationTarget [
	self explicitRequirement
]
