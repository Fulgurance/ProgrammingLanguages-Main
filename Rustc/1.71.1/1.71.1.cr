class Target < ISM::Software

    def prepare
        super

        targetData = <<-CODE
        use crate::spec::{Cc, LinkerFlavor, Lld, SanitizerSet, StackProbeType, Target};

        pub fn target() -> Target {
            let mut base = super::linux_gnu_base::opts();
            base.cpu = "x86-64".into();
            base.max_atomic_width = Some(64);
            base.add_pre_link_args(LinkerFlavor::Gnu(Cc::Yes, Lld::No), &["-m64"]);
            base.stack_probes = StackProbeType::X86;
            base.static_position_independent_executables = true;
            base.supported_sanitizers = SanitizerSet::ADDRESS
                | SanitizerSet::CFI
                | SanitizerSet::LEAK
                | SanitizerSet::MEMORY
                | SanitizerSet::THREAD;
            base.supports_xray = true;

            Target {
                llvm_target: "#{Ism.settings.systemTarget}".into(),
                pointer_width: 64,
                data_layout: "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
                    .into(),
                arch: "x86_64".into(),
                options: base,
            }
        }

        CODE
        fileWriteData("#{buildDirectoryPath}/compiler/rustc_target/src/spec/#{Ism.settings.systemTarget.gsub("-","_")}",targetData)

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
