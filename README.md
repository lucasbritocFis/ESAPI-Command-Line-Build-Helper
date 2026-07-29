<p align="center">
  <img src="https://img.shields.io/badge/C%23-.NET%20Framework-green" alt="C# with .NET Framework" />
  <img src="https://img.shields.io/badge/ESAPI-tested%20with%2016.1-blue" alt="Tested with ESAPI 16.1" />
  <img src="https://img.shields.io/badge/platform-Windows-0078D6" alt="Windows" />
  <img src="https://img.shields.io/badge/license-MIT-lightgrey" alt="MIT License" />
</p>

<h1 align="center">ESAPI Command-Line Build Helper</h1>

<p align="center">
  <strong>Build small, single-file ESAPI plug-ins from the Windows command line.</strong>
</p>

<p align="center">
  This project calls the C# compiler installed with the .NET Framework, supplies the required ESAPI references and generates a standard .NET class library named <code>&lt;ScriptName&gt;.esapi.dll</code>.
</p>

---

## What problem does this solve?

A small ESAPI plug-in is usually built inside a Visual Studio project.

Visual Studio is useful because it manages many details for the developer:

* source files;
* references;
* compiler options;
* output paths;
* debugging;
* larger project structures.

But a small plug-in does not always need all of that.

At the most basic level, the build requires only:

1. a compatible C# source file;
2. a C# compiler;
3. the required ESAPI assemblies;
4. the correct compiler options.

This repository makes that smaller build process explicit.

It does not replace Visual Studio for complex applications. It provides a simpler path for a restricted class of small ESAPI plug-ins.

---

## What does the build script do?

The `build.bat` file:

* checks whether the source file exists;
* checks whether the expected C# compiler exists;
* checks whether the required ESAPI assemblies exist;
* removes an older output file;
* calls `csc.exe`;
* builds a .NET class library;
* explicitly targets the tested x64 environment;
* names the output file `<ScriptName>.esapi.dll`;
* returns an error when compilation fails.

The essential transformation is:

```text
C# source file
+ ESAPI assemblies
+ compiler options
        |
        v
      csc.exe
        |
        v
managed .NET class library
```

The `.esapi.dll` suffix is a naming convention used by the ESAPI workflow. It is not a separate binary format.

---

## What does this project not do?

A successful compilation means that the compiler produced a DLL.

It does not prove that:

* Eclipse can load the DLL;
* all runtime dependencies can be resolved;
* the plug-in will execute without errors;
* the code produces the intended result;
* the plug-in is safe for clinical use.

These are different stages:

```text
Source compiles
        ↓
DLL is created
        ↓
Eclipse recognizes the plug-in
        ↓
The CLR loads the assembly
        ↓
The Execute method runs
        ↓
The result is verified
        ↓
The plug-in is validated for its intended use
```

This repository currently automates only the compilation stage.

---

## Build decisions made explicit

### Target architecture

The build uses:

```text
/platform:x64
```

This matches the Eclipse 16.1 environment in which the project was developed and tested.

The behavior of `x86` and `AnyCPU` builds has not yet been systematically evaluated in this repository.

### ESAPI references

The compiler receives explicit references to:

```text
VMS.TPS.Common.Model.API.dll
VMS.TPS.Common.Model.Types.dll
```

These files define the ESAPI types used by the source code.

The C# compiler cannot understand types such as `ScriptContext`, `StructureSet` or `Structure` unless the corresponding assemblies are available during compilation.

### Output name

The generated library is named:

```text
<ScriptName>.esapi.dll
```

Changing the file extension does not change the internal nature of the file. It remains a managed .NET assembly.

### Old output removal

Before compiling, the script removes an older output DLL with the same name.

This avoids a misleading situation in which compilation fails but an older DLL remains in the folder and appears to be the new result.

### Assembly versioning

The current script does not automatically modify:

```csharp
[assembly: AssemblyVersion("1.0.0.0")]
```

Assembly versioning and Eclipse re-registration must be handled according to the local development and testing workflow.

---

## Requirements

* 64-bit Windows environment;
* compatible .NET Framework installation;
* 64-bit C# compiler available at:

```text
C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe
```

* Varian Eclipse/ARIA with the ESAPI assemblies installed locally;
* local access and permissions required by the institution's script-registration process.

This repository was developed and tested with ESAPI 16.1.

Other ESAPI versions may require changes to the assembly path and have not yet been validated here.

---

## Setup and usage

Clone the repository:

```bat
git clone https://github.com/lucasbritocFis/ESAPI-Offline-Compiler.git
cd ESAPI-Offline-Compiler
```

Run the environment checker:

```bat
scripts\check_env.bat
```

The checker searches common Varian RTM installation folders and prints the first candidate directory containing the ESAPI API assembly.

Review the result and confirm that the directory contains both:

```text
VMS.TPS.Common.Model.API.dll
VMS.TPS.Common.Model.Types.dll
```

Then update `ESAPI_DIR` inside:

```text
scripts\build.bat
```

Compile the included example:

```bat
scripts\build.bat
```

Compile another compatible single-file script:

```bat
scripts\build.bat YourScript.cs
```

Run these commands from the repository root.

When no source file is provided, `build.bat` uses:

```text
examples\HelloEsapi.cs
```

When a source file is provided, the generated output is named after that file:

```text
YourScript.cs
        ↓
YourScript.esapi.dll
```

---

## Repository structure

```text
ESAPI-Offline-Compiler/
├── examples/
│   └── HelloEsapi.cs
├── scripts/
│   ├── check_env.bat
│   └── build.bat
├── LICENSE
└── README.md
```

### `examples\HelloEsapi.cs`

A minimal read-only example used to test the build and integration workflow.

It reads the active ESAPI `ScriptContext`, checks whether a patient and structure set are available and lists the non-empty structures.

It does not open a patient or create a structure set. It reads the context already active in Eclipse.

### `scripts\check_env.bat`

Searches several common Varian RTM folders for a candidate ESAPI installation path.

The result must still be reviewed by the user.

### `scripts\build.bat`

Calls the local .NET Framework C# compiler with the ESAPI references and build options required by this template.

---

## Example build

```text
Compiling examples\HelloEsapi.cs to HelloEsapi.esapi.dll ...

SUCCESS: HelloEsapi.esapi.dll was compiled.
NOTE: Compilation does not prove that Eclipse can load or execute the assembly.
Continue with your local registration and testing procedure.
```

After compilation, the DLL must be registered and tested according to the local Eclipse and institutional workflow.

Running the example successfully inside a non-clinical test context provides an integration check. It is not clinical validation.

---

## Current scope

The current build workflow is designed for compatible single-file plug-ins.

It does not currently manage:

* multiple C# source files;
* NuGet packages;
* custom external dependencies;
* embedded resources;
* code generation;
* automated AssemblyVersion updates;
* automated Eclipse registration;
* deterministic or reproducible builds;
* automated clinical validation.

Larger projects should use a structured build system such as Visual Studio and MSBuild.

---

## Safety and clinical-use notice

This is an independent educational and development project.

It is not affiliated with, endorsed by or supported by Varian Medical Systems or Siemens Healthineers.

The tool automates part of the compilation process only. It does not verify the clinical correctness, safety or suitability of a plug-in.

Before clinical use, every generated assembly should undergo appropriate:

* code review;
* integration testing;
* validation;
* documentation;
* risk assessment;
* institutional approval.

Do not include patient-identifiable or institution-confidential information in screenshots, logs, issues or public examples.

---

## Contributing

Corrections, compatibility reports and pull requests are welcome.

When reporting a problem, include:

* Windows version;
* Eclipse/ARIA version;
* ESAPI version;
* compiler path;
* complete compiler error;
* whether the included example compiled successfully.

Do not include patient-identifiable information.

---

## License

Released under the MIT License. See [LICENSE](LICENSE).

## Author

**Lucas Brito, PhD**
Clinical Medical Physicist and Radiation Oncology Software Developer
Rio de Janeiro, Brazil
