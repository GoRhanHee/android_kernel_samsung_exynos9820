![LOGO](./prebuilts/logo.png)
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

| Device |  Code Name  | Model |
|--------|------------------|-----------|
| Galaxy S10e   | beyond0lte/beyond0lteks  | SM-G970F/N |
| Galaxy S10   | beyond1lte/beyond1lteks    | SM-G973F/N |
| Galaxy S10+   | beyond2lte/beyond2lteks    | SM-G975F/N |
| Galaxy S10 5G   | beyondx/beyondxks    | SM-G977B/N |
| Galaxy Note10   | d1    | SM-N970F |
| Galaxy Note10 5G   | d1xks    | SM-N971N |
| Galaxy Note10+   | d2s    | SM-N975F |
| Galaxy Note10+ 5G   | d2x/d2xks    | SM-N976B/N |

## 🛠 How Kernel Build?

### 🟢 Local Build
1. **Clone the repository:**
   ```bash
   git clone --depth=1 https://github.com/GoRhanHee/android_kernel_samsung_exynos9820.git
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
**Model:**     
   ```bash
    # Refer Support Device table
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

* [ExtremeXT Kernel](https://github.com/ExtremeXT/android_kernel_samsung_exynos9820)

* [ravindu644's Kernel](https://github.com/ravindu644/samsung_exynos9820_stock)

* [GoRhanHee](https://github.com/GoRhanHee) : GorhanHee Kernel Developer