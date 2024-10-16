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

        copyFile(   "#{buildDirectoryPath}/compiler/rustc_target/src/spec/x86_64_unknown_linux_gnu.rs",
                    "#{buildDirectoryPath}/compiler/rustc_target/src/spec/#{Ism.settings.systemTarget.gsub("-","_")}.rs")

        fileReplaceText(path: "#{buildDirectoryPath}/compiler/rustc_target/src/spec/#{Ism.settings.systemTarget.gsub("-","_")}.rs",
                        text: "x86_64-unknown-linux-gnu",
                        newText: "#{Ism.settings.systemTarget}")

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
        tools = ["cargo", "rustdoc"]
        vendor = true

        [install]
        prefix = "/usr"
        docdir = "share/doc/rustc-1.71.1"

        [rust]
        channel = "stable"

        [target.#{Ism.settings.systemTarget}]
        llvm-config = "/usr/bin/llvm-config"

        [target.x86_64-unknown-linux-gnu]
        llvm-config = "/usr/bin/llvm-config"
        CODE
        fileWriteData("#{buildDirectoryPath}/config.toml",configData)
    end

    def build
        super

        runPythonCommand(   arguments:      "./x.py build --host #{Ism.settings.systemTarget} --target x86_64-unknown-linux-gnu,#{buildDirectoryPath}/#{Ism.settings.systemTarget}.json",
                            path:           buildDirectoryPath,
                            environment:    {"LIBSSH2_SYS_USE_PKG_CONFIG" => "1"})
    end

    def prepareInstallation
        super

        runPythonCommand(   arguments:      "./x.py install --host #{Ism.settings.systemTarget} --target x86_64-unknown-linux-gnu,#{buildDirectoryPath}/#{Ism.settings.systemTarget}.json",
                            path:           buildDirectoryPath,
                            environment:    {   "DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}",
                                                "LIBSSH2_SYS_USE_PKG_CONFIG" => "1"})

        deleteAllFilesRecursivelyFinishing( path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}",
                                            extensions: ["old"])
    end

end
