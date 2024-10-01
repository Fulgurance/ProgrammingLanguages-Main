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
            "is-builtin": true,
            "link-self-contained": {
                "components": [
                "linker"
                ]
            },
            "linker-flavor": "gnu-lld-cc",
            "llvm-target": "#{Ism.settings.systemTarget}",
            "max-atomic-width": 64,
            "metadata": {
                "description": "64-bit Linux (kernel 3.2+, glibc 2.17+)",
                "host_tools": true,
                "std": true,
                "tier": 1
            },
            "os": "linux",
            "plt-by-default": false,
            "position-independent-executables": true,
            "pre-link-args": {
                "gnu-cc": [
                "-m64"
                ],
                "gnu-lld-cc": [
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
                "kcfi",
                "safestack",
                "dataflow"
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
        target = ["#{Ism.settings.systemTarget}"]
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

        [target.#{Ism.settings.systemTarget}]
        llvm-config = "/usr/bin/llvm-config"
        CODE
        fileWriteData("#{buildDirectoryPath}/config.toml",configData)
    end
    
    def build
        super

        runPythonCommand(   arguments:      "./x.py build --target #{buildDirectoryPath}/#{Ism.settings.systemTarget}.json",
                            path:           buildDirectoryPath,
                            environment:    {"LIBSSH2_SYS_USE_PKG_CONFIG" => "1"})
    end
    
    def prepareInstallation
        super

        runPythonCommand(   arguments:      "./x.py install",
                            path:           buildDirectoryPath,
                            environment:    {   "DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}",
                                                "LIBSSH2_SYS_USE_PKG_CONFIG" => "1"})

        deleteAllFilesRecursivelyFinishing( path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}",
                                            extensions: ["old"])
    end

end
