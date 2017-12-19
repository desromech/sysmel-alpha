accessing
chainExpression
	^ chainReceiver , chainKeywordMessage optional , (semicolon , chainedMessage) star