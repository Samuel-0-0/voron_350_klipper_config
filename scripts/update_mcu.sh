#!/bin/bash

clear

### 自定义打印信息颜色
green=$(echo -en "\e[92m")
yellow=$(echo -en "\e[93m")
red=$(echo -en "\e[91m")
default=$(echo -en "\e[39m")

#if [ "$EUID" -ne 0 ]
#  then echo -e "${red}错误: 本脚本需要root用户权限${default}"
#  exit
#fi

#######################################################################
###  设置主板
###  使用命令 "ls -l /dev/serial/by-id/" 来获取主板通讯端口号填入下方
#######################################################################
TOOLHEAD_BOARD=/dev/serial/by-id/usb-Klipper_stm32f072xb_3F0048001651524138383120-if00
MAIN_BOARD=/dev/serial/by-id/usb-Klipper_stm32f446xx_29001000095053424E363420-if00


#######################################################################
###      更新VAST打印头板
#######################################################################
function update_vast {
    echo -e ""
    echo -e "${yellow}开始更新 VAST 打印头控制板${default}"
    echo -e ""
    make clean
    #make menuconfig KCONFIG_CONFIG=~/klipper_config/scripts/vast-072.config
    make KCONFIG_CONFIG=~/klipper_config/scripts/vast-072.config
    echo -e ""
    read -e -p "${yellow}固件编译完成，请检查上面是否有错误。 按 [Enter] 继续更新固件，或者按 [Ctrl+C] 取消${default}"
    echo -e ""
    make flash KCONFIG_CONFIG=~/klipper_config/scripts/vast-072.config FLASH_DEVICE=$TOOLHEAD_BOARD
    if [ $? -eq 0 ]
    then
        echo -e ""
        echo -e "${green}已完成 VAST 打印头控制板固件更新${default}"
        echo -e ""
    else
        echo -e ""
        echo -e "${red}固件更新失败，详情请查看上方信息${default}"
        echo -e ""
        exit 1
    fi
}

#######################################################################
###   使用dfu方式更新 BigTreeTech OctoPus Pro v1.0(STM32F446)
#######################################################################
function update_octopus {
    echo -e ""
    echo -e "${yellow}开始更新 BigTreeTech OctoPus Pro v1.0(STM32F446)${default}"
    echo -e ""
    make clean
    #make menuconfig KCONFIG_CONFIG=~/klipper_config/scripts/btt-octopus-pro-446.config
    make KCONFIG_CONFIG=~/klipper_config/scripts/btt-octopus-pro-446.config
    echo -e ""
    read -p "${yellow}固件编译完成，请检查上面是否有错误。 按 [Enter] 继续更新固件，或者按 [Ctrl+C] 取消${default}"
    echo -e ""
    make flash KCONFIG_CONFIG=~/klipper_config/scripts/btt-octopus-pro-446.config FLASH_DEVICE=$MAIN_BOARD
    if [ $? -eq 0 ]
    then
        echo -e ""
        echo -e "${green}已完成 OctoPus Pro 固件更新${default}"
        echo -e ""
    else
        echo -e ""
        echo -e "${red}固件更新失败，详情请查看上方信息${default}"
        echo -e ""
        exit 1
    fi
}

#######################################################################
###  使用flash sdcard方式更新 BigTreeTech OctoPus Pro v1.0(STM32F446)
#######################################################################
function update_octopus_sdcard {
    echo -e ""
    echo -e "${yellow}开始更新 BigTreeTech OctoPus Pro v1.0(STM32F446)${default}"
    echo -e ""
    make clean
    #make menuconfig KCONFIG_CONFIG=~/klipper_config/script/btt-octopus-pro-446.config
    make KCONFIG_CONFIG=~/klipper_config/script/btt-octopus-pro-446.config
    echo -e ""
    read -p "${yellow}固件编译完成，请检查上面是否有错误。 按 [Enter] 继续更新固件，或者按 [Ctrl+C] 取消${default}"
    echo -e ""
    # 查看支持的设备执行 cd ~/klipper && ./scripts/flash-sdcard.sh -l
    ./scripts/flash-sdcard.sh $MAIN_BOARD
    echo -e ""
    read -p "${yellow}固件更新完成，请检查上面是否有错误。 按 [Enter] 继续更新固件，或者按 [Ctrl+C] 取消${default}"
    echo -e ""
    if [ $? -eq 0 ]
    then
        echo -e ""
        echo -e "${green}已完成固件更新${default}"
        echo -e ""
    else
        echo -e ""
        echo -e "${red}固件更新失败，详情请查看上方信息${default}"
        echo -e ""
        exit 1
    fi
}

#######################################################################
###      停止klipper服务
#######################################################################
function stop_service {
    echo -e ""
    echo -e "${yellow}正在停止klipper服务..."
    sudo service klipper stop
    echo -e "完成${default}"
    cd ~/klipper
}
#######################################################################
###      启动klipper服务
#######################################################################
function start_service {
    echo -e ""
    echo -e "${yellow}正在启动klipper服务..."
    sudo service klipper start
    echo -e "完成${default}"
    echo -e ""
    echo -e "${green}本次固件更新工作已全部完成，祝你打印顺利！${default}"
    echo -e ""
}


#######################################################################
###      执行的操作
#######################################################################
stop_service
update_vast
update_octopus
#update_octopus_sdcard
start_service
