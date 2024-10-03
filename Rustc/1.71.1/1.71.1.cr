class Target < ISM::Software

    def prepare
        super

        targetData = <<-CODE
        {
            "arch": "x86_64",
            "cpu": "x86-64",
            "crt-static-respected": true,
            "data-layout": "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128",
            "dynamic-linking": true,
            "env": "gnu",
            "has-rpath": true,
            "has-thread-local": true,
            "is-builtin": false,
            "linker-flavor": "gcc",
            "llvm-target": "#{Ism.settings.systemTarget}",
            "max-atomic-width": 64,
            "os": "linux",
            "position-independent-executables": true,
            "pre-link-args": {
                "gcc": [
                "-m64"
                ],
                "ld": [
                "-m64"
                ]
            },
            "relro-level": "full",
            "stack-probes": {
                "kind": "inline"
            },
            "static-position-independent-executables": true,
            "supported-sanitizers": [
                "address",
                "leak",
                "memory",
                "thread",
                "cfi",
                "kcfi"
            ],
            "supported-split-debuginfo": [
                "packed",
                "unpacked",
                "off"
            ],
            "supports-xray": true,
            "target-family": [
                "unix"
            ],
            "target-pointer-width": "64"
        }

        CODE
        fileWriteData("#{buildDirectoryPath}/#{Ism.settings.systemTarget}.json",targetData)

        configData = <<-CODE
        changelog-seen = 2

        [llvm]
        targets = "X86"
        link-shared = true

        [build]
        target = ["x86_64-unknown-linux-gnu","#{Ism.settings.systemTarget}"]
        docs = false
        extended = true
        locked-deps = true
        tools = ["cargo", "clippy", "rustdoc", "rustfmt"]
        vendor = true

        [install]
        prefix = "/usr"
        docdir = "share/doc/rustc-1.71.1"

        [rust]
        channel = "stable"

        [target.x86_64-unknown-linux-gnu]
        llvm-config = "/usr/bin/llvm-config"

        [target.#{Ism.settings.systemTarget}]
        llvm-config = "/usr/bin/llvm-config"
        CODE
        fileWriteData("#{buildDirectoryPath}/config.toml",configData)
    end
    
    def build
        super

        runPythonCommand(   arguments:      "./x.py build --target x86_64-unknown-linux-gnu --target #{buildDirectoryPath}/#{Ism.settings.systemTarget}.json",
                            path:           buildDirectoryPath,
                            environment:    {"LIBSSH2_SYS_USE_PKG_CONFIG" => "1"})
    end
    
    def prepareInstallation
        super

        runPythonCommand(   arguments:      "./x.py install --target x86_64-unknown-linux-gnu --target #{buildDirectoryPath}/#{Ism.settings.systemTarget}.json",
                            path:           buildDirectoryPath,
                            environment:    {   "DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}",
                                                "LIBSSH2_SYS_USE_PKG_CONFIG" => "1"})

        deleteAllFilesRecursivelyFinishing( path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}",
                                            extensions: ["old"])
    end

end
