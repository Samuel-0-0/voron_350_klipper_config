#!/bin/bash

### 自定义打印信息颜色
green=$(echo -en "\e[92m")
yellow=$(echo -en "\e[93m")
red=$(echo -en "\e[91m")
default=$(echo -en "\e[39m")

# webcam，使用crowsnest替代MJPG-Streamer
function install_webcam {
    if [ -d "crowsnest" ]; then
        rm -rf crowsnest
    fi
    git clone --recurse-submodules https://github.com/mainsail-crew/crowsnest.git
    if [ $? -eq 0 ]
    then
        echo -e ""
        echo -e "${green}文件下载完成，开始安装...${default}"
        echo -e ""
    else
        echo -e ""
        echo -e "${red}文件下载失败，详情请查看上方信息${default}"
        echo -e ""
        exit 1
    fi
    cd ~/crowsnest && make install
    if [ $? -eq 0 ]
    then
        echo -e ""
        echo -e "${green}webcam安装完成${default}"
        echo -e ""
    else
        echo -e ""
        echo -e "${red}webcam安装失败，详情请查看上方信息${default}"
        echo -e ""
        exit 1
    fi
}

# timelapse，用于延时摄影
function install_timelapse {
    git clone https://github.com/mainsail-crew/moonraker-timelapse.git
    if [ $? -eq 0 ]
    then
        echo -e ""
        echo -e "${green}文件下载完成，开始安装...${default}"
        echo -e ""
    else
        echo -e ""
        echo -e "${red}文件下载失败，详情请查看上方信息${default}"
        echo -e ""
        exit 1
    fi
    ./moonraker-timelapse/install.sh
    if [ $? -eq 0 ]
    then
        echo -e ""
        echo -e "${green}timelapse安装完成${default}"
        echo -e ""
    else
        echo -e ""
        echo -e "${red}timelapse安装失败，详情请查看上方信息${default}"
        echo -e ""
        exit 1
    fi
}

# klipper_z_calibration，用于自动Z偏移
function install_klipper_z_calibration {
    git clone https://github.com/protoloft/klipper_z_calibration.git
    if [ $? -eq 0 ]
    then
        echo -e ""
        echo -e "${green}文件下载完成，开始安装...${default}"
        echo -e ""
    else
        echo -e ""
        echo -e "${red}文件下载失败，详情请查看上方信息${default}"
        echo -e ""
        exit 1
    fi
    ./klipper_z_calibration/install.sh
    if [ $? -eq 0 ]
    then
        echo -e ""
        echo -e "${green}klipper_z_calibration安装完成${default}"
        echo -e ""
    else
        echo -e ""
        echo -e "${red}klipper_z_calibration安装失败，详情请查看上方信息${default}"
        echo -e ""
        exit 1
    fi
}

# gcode_shell_command，用于在gcode中执行shell脚本
function install_gcode_shell_command {
    cp ~/klipper_config/scripts/gcode_shell_command.py /home/samuel/klipper/klippy/extras/
    if [ $? -eq 0 ]
    then
        echo -e ""
        echo -e "${green}gcode_shell_command安装完成${default}"
        echo -e ""
    else
        echo -e ""
        echo -e "${red}gcode_shell_command安装失败，详情请查看上方信息${default}"
        echo -e ""
        exit 1
    fi

cd ~
echo -e "${yellow}开始安装webcam${default}"
install_webcam
echo -e "${yellow}开始安装gcode_shell_command${default}"
install_gcode_shell_command
echo -e "${yellow}开始安装timelapse${default}"
install_timelapse
echo -e "${yellow}开始安装klipper_z_calibration${default}"
install_klipper_z_calibration
