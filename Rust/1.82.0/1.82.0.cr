class Target < ISM::Software

    def prepare
        super

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
        docdir = "share/doc/rustc-1.82.0"

        [rust]
        channel = "stable"
        lto = "thin"
        codegen-units = 1

        [target.#{Ism.settings.systemTarget}]
        llvm-config = "/usr/bin/llvm-config"
        CODE
        fileWriteData("#{buildDirectoryPath}/config.toml",configData)
    end

    def build
        super

        runPythonCommand(   arguments:      "./x.py build",
                            path:           buildDirectoryPath,
                            environment:    {   "LIBSSH2_SYS_USE_PKG_CONFIG" => "1",
                                                "LIBSQLITE3_SYS_USE_PKG_CONFIG" => "1"})
    end

    def prepareInstallation
        super

        runPythonCommand(   arguments:      "./x.py install rustc std",
                            path:           buildDirectoryPath,
                            environment:    {   "DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}",
                                                "LIBSSH2_SYS_USE_PKG_CONFIG" => "1",
                                                "LIBSQLITE3_SYS_USE_PKG_CONFIG" => "1"})

        deleteAllFilesRecursivelyFinishing( path:       "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}",
                                            extensions: ["old"])
    end

end
