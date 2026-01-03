# GoRhanHee Kernel for Samsung Exynos 9820 Stock Rom 

An optimized stock-based kernel for Samsung Galaxy S10 series (Exynos 9820) with integrated **KernelSU** and **Ramdisk** support.

## 🌟 What is the GoRhanHee Kernel for exynos9820?
This project provides a modified version of the official Samsung stock kernel. It is specifically designed for users who want to maintain the stability of the Stock ROM while gaining advanced root capabilities through KernelSU. And, There was a problem with losing the root(SU) after rebooting, which was a problem with the existing Galaxy 10 series. This is because the stock kernel did not have ramdisk. As a result, the GoRhanHee kernel had ramdisk.

## 🚀 Features
- **Stock Source Base**: Built from the official Samsung Open Source Release Center (OSRC) Kernel Source 
- **KernelSU-Next Integrated**: Included [KernelSU-Next](https://github.com/KernelSU-Next/KernelSU-Next/tree/legacy) 
- **Ramdisk Loaded**: Fixed an issue that did not have ramdisk installed in boot.img. So, We can use Magisk without recovery reboot. Thanks to [@LineageOS Team](https://github.com/LineageOS/android_kernel_samsung_exynos9820)
- **Disabled Samsung Protection**: As Samsung protection is disabled, [APatch](https://github.com/bmax121/APatch) patches are also possible

## 📱 Supported Devices
This kernel is compatible with the following Exynos 9820/9825 models:
- **Galaxy S10e (SM-G970F/N)** 
- **Galaxy S10 (SM-G973F/N)**
- **Galaxy S10+ (SM-G975F/N)**
- **Galaxy S10 5G (SM-G977B/N)**
- **Galaxy Note 10 (SM-N970F)**
- **Galaxy Note 10 5G (SM-N971N)**
- **Galaxy Note 10+ (SM-N975F)**
- **Galaxy Note 10+ 5G (SM-N976B/N)**

## 🛠 How Kernel Build?

### 🟢 Local Build
1. **Clone the repository:**
   ```bash
   git clone https://github.com/GoRhanHee/android_kernel_samsung_exynos9820.git
   ```
2. **Setting permission:**   
   ```bash
    chmod +x build.sh
    chmod -R +x prebuilts/ 
   ```
3. **Cooking Kernel:**   
   ```bash
    ./build.sh ${MODEL} ${KSU} # Ex) ./build.sh beyond1lteks y
   ```   
**Model List:**     
   ```bash
    beyond0lte  # SM-G970F
    beyond0lteks    # SM-G970N
    beyond1lte  # SM-G973F
    beyond1lteks    # SM-G973N
    beyond2lte  # SM-G975F
    beyond2lteks    # SM-G975N
    beyondx     # SM-G977B
    beyondxks   # SM-G977N
    d1      # SM-N970F
    d1xks   # SM-N971N
    d2s     # SM-N975F
    d2x     # SM-N976B
    d2xks   # SM-N976N
   ``` 
**KSU:**     
   ```bash
    y # Include KernelSU-Next
    n # Dont Include KernelSU-Next (Magisk or APatch)
   ```
4. **You can get Kernel installer file in ./prebuilts folder**

### 🟢 Github Action Build
1. **Fork this repository to your Github account.**

2. **Navigate to the Actions tab at the top of the repository.**   

3. **Select the "Kernel Build" workflow from the left sidebar.**   

4. **Choose Option (KernelSU)**   
   
5. **Click Run workflow**   

6. **Waiting 10mins... Download "(your_model)_Kernel_File.zip" file**

## 🤝 Credits
* [Samsung OSRC](https://opensource.samsung.com/main): Import Stock Kernel source code

* [KernelSU-Next](https://github.com/KernelSU-Next/KernelSU-Next/tree/legacy) : Include Kernel Root tools

* [LineageOS Team](https://github.com/LineageOS/android_kernel_samsung_exynos9820)

* [ExtremeXT](https://github.com/ExtremeXT/android_kernel_samsung_exynos9820)

* [ravindu644](https://github.com/ravindu644/samsung_exynos9820_stock)

* [GoRhanHee](https://github.com/GoRhanHee) : GorhanHee Kernel Developer