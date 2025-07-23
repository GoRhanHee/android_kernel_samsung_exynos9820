# ✅ Galaxy S10 | Note10 Series SuSFS ඞ Kernel
* ⚠️ This kernel is Stock OneUI(4.1) Source (I recommend use Stock OneUI ROM)
* 📱 Include [KernelSU-Next](https://github.com/KernelSU-Next/KernelSU-Next) and [SuSFS](https://github.com/sidex15/susfs4ksu-module) (Best Rooting Tool & Root Hiding Tool)


# ❓ How to Compille? 

* **Local LINUX PC**
* **Prepare GCC & Clang Compiler** : [Download](https://github.com/CruelKernel/samsung-exynos9820-toolchain.git) (I recommend make "toolchain" folder (mkdir), and download compiler in this folder)
* **Open terminal in ~~/Kernel Source**
*         ./build_kernel.sh MODEL
* EX) **./build_kernel.sh G977N**
* **Support MODEL**
*         SM-G970F/N (Galaxy S10e) 
          SM-G973F/N (Galaxy S10) 
          SM-G975F/N (Galaxy S10+)
          SM-G977B/N (Galaxy S10 5G)
          SM-N970F (Galaxy Note10)
          SM-N971N (Galaxy Note10 5G)
          SM-N975F (Galaxy Note10+)
          SM-N976N (Galaxy Note10+ 5G)
* **If you Compile Success, You can get boot.img | dt.img | dtbo.img and Odin_flashable file in "out" folder**


# 📋 Credit
* Samsung Open Source Project : [Click](https://opensource.samsung.com/main)
* Kernel Source Fix : [CruelKernel](https://github.com/CruelKernel/samsung-exynos9820) [ravindu644](https://github.com/ravindu644/samsung_exynos9820_stock)
* KernelSU-Next : [rifsxd](https://github.com/KernelSU-Next/KernelSU-Next)
* SuSFS ඞ : [sidex15](https://github.com/sidex15/susfs4ksu-module) [simonpunk](https://gitlab.com/simonpunk/susfs4ksu/-/tree/kernel-4.14?ref_type=heads)
