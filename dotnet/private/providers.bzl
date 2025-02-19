"Providers"
DotnetAssemblyCompileInfo = provider(
    doc = "Compilation information for a .Net assembly.",
    fields = {
        "name": "string: The name of the assembly",
        "version": "string: The version of the assembly",
        "project_sdk": "string: The SDK being targeted",
        "refs": "list[File]: Reference-only assemblies containing only public symbols. See docs/ReferenceAssemblies.md for more info.",
        "irefs": "list[File]: Reference-only assemblies containing public and internal symbols. See docs/ReferenceAssemblies.md for more info.",
        "analyzers": "list[File]: Analyzer dlls",
        "internals_visible_to": "list[string]: A list of assemblies that can use the assemblies listed in iref for compilation. See docs/ReferenceAssemblies.md for more info.",
        "compile_data": "list[File]: Compile data files",
        "exports": "list[File]",

        # TODO: Maybe this should just be deps?
        "transitive_refs": "depset[File]: Transitive reference-only assemblies containing only public symbols. Only used when strict deps are off.",
        "transitive_compile_data": "depset[File]: Transitive compile data files. Only used when strict deps are off.",
        "transitive_analyzers": "depset[File]: Transitive analyzer dlls. Only used when strict deps are off.",
    },
)

DotnetAssemblyRuntimeInfo = provider(
    doc = "A DLL or exe.",
    fields = {
        "name": "string: The name of the assembly",
        "version": "string: The version of the assembly",
        "libs": "list[File]: Runtime DLLs",
        "pdbs": "list[File]: The PDBs of the assembly",
        "xml_docs": "list[File]: The XML documentation files of the assembly",
        "native": "list[File]: Native runtime files",
        "data": "list[File]: Runtime data files",
        "nuget_info": "NugetInfo",
        "deps": "depset[DotnetAssemblyRuntimeInfo]: The direct and transitive runtime dependencies of the assembly",
        "direct_deps_depsjson_fragment": "struct: A struct containing the direct deps of the target. This is used during deps.json generation and is generated in the provider to avoid making the provider too bloated and thus making analysis slower.",
    },
)

DotnetDepVariantInfo = provider(
    doc = "A wrapper provider for a dependency. The dependency can be a project " +
          "dependency, in which case the `assembly_runtime_info` will be populated" +
          "or a NuGet dependency, in which case `assembly_runtime_info` and `nuget_info` will be populated.",
    fields = {
        "label": "Label: The label of the dependency",
        "assembly_runtime_info": "DotnetAssemblyRuntimeInfo: The DotnetAssemblyRuntimeInfo provider of a dependency",
        "nuget_info": "NuGetInfo: The NuGet info of a dependency",
    },
)

NuGetInfo = provider(
    doc = "Information about a NuGet package.",
    fields = {
        "targeting_pack_overrides": "map[string, string]: Targeting packs like e.g. Microsoft.NETCore.App.Ref have a PackageOverride.txt that includes a list of NuGet packages that should be omitted in a compiliation because they are included in the targeting pack",
        "framework_list": "map[string, string]: Targeting packs like e.g. Microsoft.NETCore.App.Ref have a FrameworkList.xml that includes a list of the DLLs in the targeting pack. This is used for selecting the correct DLL versions during compilation and runtime.",
        "sha512": "string: the SHA512 SRI string for the package",
    },
)

DotnetBinaryInfo = provider(
    doc = "Information about a .Net binary",
    fields = {
        "app_host": "File: The apphost executable",
        "dll": "File: The main binary dll",
        "transitive_runtime_deps": "list[DotnetAssemblyRuntimeInfo]: The transitive runtime dependencies of the binary",
    },
)

DotnetPublishBinaryInfo = provider(
    doc = "Information about a published .Net binary",
    fields = {
        "runtime_packs": "list[AssemblyInfo]: Optional information about the used runtime packs. Used by self-contained publishing",
        "target_framework": "string: The target framework of the published binary",
        "self_contained": "bool: True if the binary is self-contained",
    },
)
