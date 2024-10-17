class Target < ISM::Software

    def prepare
        super

        fileReplaceTextAtLineNumber(path: "#{buildDirectoryPath}/compiler/rustc_session/src/config.rs",
                                    text: "CUSTOM_TARGET",
                                    newText: Ism.settings.systemTarget,
                                    lineNumber: 1992)

        fileReplaceTextAtLineNumber(path: "#{buildDirectoryPath}/compiler/rustc_target/src/spec/x86_64_unknown_linux_gnu.rs",
                                    text: "CUSTOM_TARGET",
                                    newText: Ism.settings.systemTarget,
                                    lineNumber: 18)

        configData = <<-CODE
        changelog-seen = 2

        [llvm]
        targets = "X86"
        link-shared = true

        [build]
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

        [target.x86_64-unknown-linux-gnu]
        llvm-config = "/usr/bin/llvm-config"
        CODE
        fileWriteData("#{buildDirectoryPath}/config.toml",configData)
    end

    def build
        super

        runPythonCommand(   arguments:      "./x.py build",
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
