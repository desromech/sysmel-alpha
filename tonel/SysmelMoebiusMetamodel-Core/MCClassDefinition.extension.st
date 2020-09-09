Extension { #name : #MCClassDefinition }

{ #category : #'*SysmelMoebiusMetamodel-Core' }
MCClassDefinition >> buildMbndASTNodeWith: builder [
	^ (builder defineGCClassNamed: name
		superclass: (superclassName ifNotNil: [builder identifier: superclassName])
		body: (self buildMbndBehaviorBodyWith: builder))
		poolDictionaries: (builder tuple: (self poolDictionaries collect: [:poolName | builder identifier: poolName ]))
]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
MCClassDefinition >> mbndDefinitionSortKey [
	^ -1
]
