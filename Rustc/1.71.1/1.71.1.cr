class Target < ISM::Software

    def prepare
        super

        configData = <<-CODE
        changelog-seen = 2

        [llvm]
        targets = "X86"
        link-shared = true

        [build]
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

        [target.i686-unknown-linux-gnu]
        llvm-config = "/usr/bin/llvm-config"
        CODE
        fileWriteData("#{buildDirectoryPath(false)}/config.toml",configData)
    end
    
    def build
        super

        runPythonCommand(   ["./x.py","build"],
                            buildDirectoryPath,
                            {"LIBSSH2_SYS_USE_PKG_CONFIG" => "1"})
    end
    
    def prepareInstallation
        super

        runPythonCommand(   ["./x.py","install"],
                            buildDirectoryPath,
                            {"DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}",
                            "LIBSSH2_SYS_USE_PKG_CONFIG" => "1"})

        deleteAllFilesRecursivelyFinishing("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}",".old")
    end

end
