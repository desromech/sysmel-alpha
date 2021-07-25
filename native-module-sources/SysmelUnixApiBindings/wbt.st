self staticLibrary: 'SysmelUnixApiBindings' with: [:lib |
    lib sources: #(
        'dirent.c'
        'stat.c'
        'thread.c'
    )
]
