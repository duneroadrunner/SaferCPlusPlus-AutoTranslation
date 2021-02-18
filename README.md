
This project has been superceded by [SaferCPlusPlus-AutoTranslation2](https://github.com/duneroadrunner/SaferCPlusPlus-AutoTranslation2) and remains here for posterity.

<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>

-----------------------------------------------------------------------------------------------------


Aug 2017

# SaferCPlusPlus-AutoTranslation

Here we describe a tool to assist in the conversion of native C code to [SaferCPlusPlus](https://github.com/duneroadrunner/SaferCPlusPlus) (a memory-safe subset of C++). The tool is actually part of the "mutator" code analysis project. This repository contains an (older) snapshot of the mutator project for posterity, but you can find the latest version [here](https://github.com/bloodstalker/mutator).

The conversion assistance tool is still in early development, and at the moment only converts native arrays and pointers used as array iterators to their SaferCPlusPlus counterparts. While this leaves the tool far from complete, native arrays are one of, if not the biggest culprit wrt "remote execution" vulnerabilities. So potentially, it can already be significantly helpful in improving code safety where needed.

To demonstrate how to use it, this repository contains an [example](https://github.com/duneroadrunner/SaferCPlusPlus-AutoTranslation/tree/master/examples/lodepng) of the conversion tool being applied to an open source png encoder/decoder written in C.

Note that, currently, the conversion tool doesn't necessarily produce (performance) optimal SaferCPlusPlus code. Instead it uses SaferCPlusPlus elements that map directly to the (unsafe) native elements they are replacing. One benefit of doing it this way is that, with the converted code, you can use a compile-time directive to "disable" the SaferCPlusPlus elements and "restore" the original (unsafe) implementation. That is, adding `-DMSE_SAFER_SUBSTITUTES_DISABLED` to your compile options (or `#define MSE_SAFER_SUBSTITUTES_DISABLED` in the source files), should make the code essentially equivalent to the original (unsafe) code, generating the same, or nearly the same, machine code.
