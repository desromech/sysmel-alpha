self platform name selectCase: {
    #linux -> [
        self importLibrary: 'jpeg' fromDebianPackage: 'libjpeg-turbo8-dev'.
    ].
    #osx -> [

    ].
    #windows -> [
        | folder |
        folder := 'windows/' , self architecture name.
        self importLibrary: 'jpeg' fromLibFolder: folder , '/lib' binFolder: folder , '/bin'
    ].
    [true] -> []
}.
