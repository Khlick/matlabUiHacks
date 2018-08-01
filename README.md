# matlabUiHacks

This repo was created to contain all of the working examples and more from a [guest-post at Undocumented Matlab](https://undocumentedmatlab.com/blog/customizing-web-gui-uipanel) (a very kind ''thank you'' to [Yair Altman](https://undocumentedmatlab.com)) I made for customizing `uipanels` in MATLAB's web-based figure environment.

MATLAB introduced the `uifigure()` in the 2016a release and a lot of functionality was missing, compared to the existing `figure`. In an attempt to extend, explore and share the undocumented ways in which we can modify the new "Web-GUI" framework, I have created this collection.

---

## Usage

Clone this repo:
```git
git clone --recurse-submodules https://github.com/Khlick/matlabUiHacks
cd matlabUiHacks
```

Then, in MATLAB, run `main()` to add the repository directory structure to MATLAB's path (for just the session). You can set the `verbose` flag to `true` and `main()` will print a list of relevant M-Files to the command window.


I'll try to put useful and concise comments in every script... though sometimes I may not. I am also happy to merge just about any pull requests. That said, my intent with this repository is to make it an eclectic collection of MATLAB hacks specifically for Web-GUI figures (`uifigure`) and all/any of the control elements, e.g. `uiknob` and `uipanel`. The new (as of the 2016a release) figure framework is web-based and, consequently, many of the hacks will involve some form of JavaScript, CSS, HTML (or other), many of the scripts herein could be written in their source language. For this reason, I will maintain (for some time at least) a `utils` class with methods to MATLAB-ify the scripts. Also feel free to modify/add onto that in places you see fit.

Also, though not explicitly required, I've opted to use the `mlapptoolbox` in many of the examples. I have included my fork of the project in a submodule, but I highly recommend you go read about it on the original repository at [https://github.com/StackOverflowMATLABchat/mlapptools](https://github.com/StackOverflowMATLABchat/mlapptools "https://github.com/StackOverflowMATLABchat/mlapptools").


---

## Disclaimer

These scripts were originally created on an a MATLAB 2018a (student) installation and I provide __no guarantee__ that the methods, scripts, hacks, etc. will work. I also can't promise that they will work for earlier or later versions of MATLAB. Furthermore, use code from these examples freely and __*at your own risk!*__
