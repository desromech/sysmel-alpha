white
multiLineComment
	^ '/*' asParser ,
		( ($* asParser negate) /
			($* asParser , $/ asParser negate)
		) star ,
	'*/' asParser