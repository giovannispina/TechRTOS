TechOS
========

TechOS is a very simple cooperative OS for PIC18. It has a timersystem and also containers such as list and hashmap. This is a beta version that seems to be working well, but if you find any bug please report it. Be careful with reentrancies and avoid using local non-static variables. 

The dependencies for compiling the OS are:

* Time
* C_String
* MemManager

A sample can be found in the same repository. Documentation will be provided as soon as I have free time. In the meantime, I hope you find the sample helpful.