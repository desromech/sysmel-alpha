Class {
	#name : #MbndSamplerType,
	#superclass : #MbndOpaqueHandleType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndSamplerType class >> typeName [
	^ #GPUSampler
]

{ #category : #visiting }
MbndSamplerType >> accept: visitor [
	^ visitor visitSamplerType: self
]

{ #category : #initialization }
MbndSamplerType >> addInstanceMacros [
	self class == MbndSamplerType ifFalse: [ ^ self ].
	self
		onMacroSelector: #sample:at: do: [ :node :builder |
			(builder sampleWith: node receiver texture: node arguments first atWithImplicitLod: node arguments second )
				position: node
		];
		onMacroSelector: #sample:at:depth: do: [ :node :builder |
			(builder sampleWith: node receiver texture: node arguments first at: node arguments second depth: node arguments third )
				position: node
		];
		onMacroSelector: #sample:at:lod: do: [ :node :builder |
			(builder sampleWith: node receiver texture: node arguments first at: node arguments second lod: node arguments third)
				position: node
		];
		onMacroSelector: #sample:at:dtdx:dtdy: do: [ :node :builder |
			(builder sampleWith: node receiver texture: node arguments first at: node arguments second dtdx: node arguments third dtdy: node arguments fourth)
				position: node
		]
	
]

{ #category : #'testing methods' }
MbndSamplerType >> isSamplerType [
	^ true
]

{ #category : #initialization }
MbndSamplerType >> markAsTrait [
]
