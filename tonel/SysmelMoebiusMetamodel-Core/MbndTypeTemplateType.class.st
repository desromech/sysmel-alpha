Class {
	#name : #MbndTypeTemplateType,
	#superclass : #MbndTemplateType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndTypeTemplateType class >> typeName [
	^ #_TypeTemplateType
]

{ #category : #initialization }
MbndTypeTemplateType >> addInstanceMacros [
	self class == MbndTypeTemplateType ifFalse: [ ^ self ].
	self
		onMacroSelectors: #( definition: extend: )do: [ :node :builder |
			builder programEntity: node receiver extension: node arguments first
			
		]
]

{ #category : #testing }
MbndTypeTemplateType >> isTypeTemplateType [
	^ true
]
