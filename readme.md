6.61 Adrenaline
================================================================================

A software that transforms your PS Vita into a two-in-one device

What is Adrenaline?
-------------------
Adrenaline is a software that modifies the official PSP Emulator using [taiHEN CFW framework](https://github.com/yifanlu/taiHEN)
to make it run a PSP 6.61 custom firmware. Thanks to the power of taiHEN, Adrenaline can
inject custom code into the IPL which allows unsigned code to run at boottime.

How to update
-------------
If you have already been using Adrenaline, simply open Adrenaline.vpk as zip file and copy all modules from sce_module to ux0:app/PSPEMUCFW/sce_module.  
Alternatively, use "System update" from XMB and follow instructions.

How to install
--------------
Please only do this approach for a fresh installation, otherwise please refer to the guide above.

1. Remove the Adrenaline bubble and the `ux0:app/PSPEMUCFW/sce_module/adrenaline_kernel.skprx` path from the taiHEN config.txt and finally reboot your device.
2. Download [Adrenaline.vpk](https://github.com/TheOfficialFloW/Adrenaline/releases) and install it using [VitaShell](https://github.com/TheOfficialFloW/VitaShell/releases).
3. Launch Adrenaline and press ❌ to download the 6.61 firmware. After finishing it will automatically terminate.
4. Relaunch Adrenaline, this time it will go into pspemu mode. Follow the instructions on screen.

Getting rid of double launch bug
--------------------------------
Adrenaline has been redesigned in `6.61 Adrenaline-6`, so you'd need to launch Adrenaline twice everytime you reboot your device. To get rid of that, simply write this line to `*KERNEL`

```text
*KERNEL
ux0:app/PSPEMUCFW/sce_module/adrenaline_kernel.skprx
```


## Dependencies
Adrenaline uses these dependencies: 

- [pspsdk](https://pspdev.github.io/) + [psp-packer](https://github.com/PSP-Archive/ARK-4/tree/main/contrib/PC/PSPSDK) binary in your $PATH
- [vitasdk](https://vitasdk.org/)
- [vita2dlib-fbo](https://github.com/frangarcj/vita2dlib/tree/fbo)
- [vita-shader-collection](https://github.com/frangarcj/vita-shader-collection)
- python3

<details>
  <summary>Ubuntu Quick Install</summary>
  This will install the dependencies. Tested on Ubuntu 24.10 in WSL2.
  
  ```sh
  # Install PSPDEV
  cd /tmp # dont want garbage cluttering up your folders now, do we? (if any gets left over, that is)
  sudo apt update
  sudo apt install -y build-essential cmake pkgconf libreadline8t64 libusb-1.0-0 libgpgme11t64 libarchive-tools fakeroot python3 python-is-python3 p7zip
  curl -OL https://github.com/pspdev/pspdev/releases/latest/download/pspdev-ubuntu-latest-x86_64.tar.gz
  sudo tar -xvf ./pspdev-ubuntu-latest-x86_64.tar.gz -C /usr/local
  sudo chown -R $USER /usr/local/pspdev/
  rm ./pspdev-ubuntu-latest-x86_64.tar.gz
  sed -i -e '$aexport PSPDEV="/usr/local/pspdev"' ~/.bashrc
  sed -i -e '$aexport PATH="$PATH:$PSPDEV/bin"' ~/.bashrc
  # Install psp-packer
  curl -OL https://github.com/PSP-Archive/ARK-4/raw/main/contrib/PC/PSPSDK/pspdev.7z
  7z x -y pspdev.7z -o./
  mv ./pspdev/bin/psp-packer /usr/local/pspdev/bin/
  rm ./pspdev.7z
  rm -rf ./pspdev
  # Install VitaSDK
  sed -i -e '$aexport VITASDK="/usr/local/vitasdk"' ~/.bashrc
  sed -i -e '$aexport PATH="$VITASDK/bin:$PATH"' ~/.bashrc
  git clone https://github.com/vitasdk/vdpm
  cd ./vdpm
  ./bootstrap-vitasdk.sh
  ./install-all.sh
  cd ..
  rm -rf ./vdpm
  # Install vita2dlib-fbo
  git clone -b fbo https://github.com/frangarcj/vita2dlib.git
  cd ./vita2dlib/libvita2d
  make
  make install
  cd ../..
  rm -rf ./vita2dlib
  # Install vita-shader-collection
  mkdir ./vitashader
  curl -OL https://github.com/frangarcj/vita-shader-collection/releases/download/master-0.1-v86/vita-shader-collection.tar.gz
  tar -xvf ./vita-shader-collection.tar.gz -C ./vitashader
  rm ./vita-shader-collection.tar.gz
  mv ./vitashader/includes/* /usr/local/vitasdk/arm-vita-eabi/include/
  mv ./vitashader/lib/* /usr/local/vitasdk/arm-vita-eabi/lib/
  rm -rf ./vitashader
  cd ~
  $SHELL # restarts the shell so .bashrc has a chance to update
  ```
</details>


## Building
To use the file sending functionality you will need to install [vitacompanion](https://github.com/Ibrahim778/vitacompanion) (Make sure "CMD/FTP Servers is ticked in your Quick Menu.)
### From VSCode:
Open the Run and Debug section and choose one of the options below. \
`Build` - makes without installing. \
`Build & Send` - makes and copies the build to ux0:/app/PSPEMUCFW. \
`Build & Install` - makes and installs the VPK automatically. 
### From the terminal:
`./make` - makes without installing. \
`./make <VITA IP>` - makes and copies the build to ux0:/app/PSPEMUCFW. \
`./make <VITA IP> -i` - makes and installs the VPK automatically. 
### Manually
- `cd cef && make && cd ..`
- `cmake -S . -B build -DCMAKE_BUILD_TYPE=Release`
- `cmake --build build`
- grab VPK from `build/bubble/`

## Building updater
- Build adrenaline (see above)
- `cmake --build build --target updater`
- (optionally) modify `cef/updater/psp-updatelist.template`
- `cd cef/updater && make`
- resulting files are `EBOOT.PBP` and `psp-updatelist.txt`
