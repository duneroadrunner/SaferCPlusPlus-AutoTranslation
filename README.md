Jun 2017

# SaferCPlusPlus-AutoTranslation

Here we describe a tool to assist in the conversion of native C code to [SaferCPlusPlus](https://github.com/duneroadrunner/SaferCPlusPlus) (a memory-safe subset of C++). The tool is actually part of the "mutator" code analysis project. This repository contains an (older) snapshot of the mutator project for posterity, but you can find the latest version [here](https://github.com/bloodstalker/mutator).

The conversion assistance tool is still in early development, and at the moment only converts native arrays and pointers used as array iterators to their SaferCPlusPlus counterparts. While this leaves the tool far from complete, native arrays are one of, if not the biggest culprit wrt "remote execution" vulnerabilities. So potentially, it can already be significantly helpful in improving code safety where needed.

To demonstrate how to use it, this repository contains an [example](https://github.com/duneroadrunner/SaferCPlusPlus-AutoTranslation/tree/master/examples/lodepng) of the conversion tool being applied to an open source png encoder/decoder written in C.
