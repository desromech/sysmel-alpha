Extension { #name : #RGPackage }

{ #category : #'*SysmelCalypso' }
RGPackage >> addMethod: anRGMethod [ 
	self addExtensionMethod: anRGMethod 
]

{ #category : #'*SysmelCalypso' }
RGPackage >> removeMethod: anRGMethod [ 
	self removeExtensionMethod: anRGMethod 
]
