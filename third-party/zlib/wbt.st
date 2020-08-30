self platform name selectCase: {
    #linux -> [
        self importLibrary: 'z' fromDebianPackage: 'zlib1g-dev'.
    ].
    #osx -> [

    ].
    #windows -> [
        | folder |
        folder := 'windows/' , self architecture name.
        self importLibrary: 'zlibwapi' fromLibFolder: folder , '/lib' binFolder: folder , '/bin'
    ].
    [true] -> []
}.
