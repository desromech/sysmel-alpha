Extension { #name : #RGBehavior }

{ #category : #'*SysmelCalypso' }
RGBehavior >> comment: comment stamp: stamp [
	self comment: ((RGComment parent: self) content: comment asString)
]

{ #category : #'*SysmelCalypso' }
RGBehavior >> users [
	^ #()
]

{ #category : #'*SysmelCalypso' }
RGBehavior >> visibleMethods [
	^ self methods
]
