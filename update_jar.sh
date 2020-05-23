#!/bin/bash
#author qiqi@qiqid.com
#date   2020-05-10
LANG=en_US.UTF-8

#本地项目存放路径,需要已’/’结尾
path_root="/www/pro1"
#本地日志路径
path_log="/www/pro1/logs/default.log"
#远程文件下载服务器路径
download_url="http://www.xxx.com/pro1"

#jar文件名称
jar_name="pro1-0.0.1.jar"
#produce文件名称 config/
config_produce_name="application-produce.yml"
#spervise文件名称 config/mapper/
config_spervise_name="spervise.xml"

#生成时间戳
time=`date +%s`

if [ "$1" ];then
	Run_CODE=$1
fi

Red_Error(){
	echo '=================================================';
	echo -e "\033[1;31;40m $1 \033[0m\n";
	exit 0;
}

Service_Start(){
    nohup java -jar $path_root$jar_name &
}

Service_Stop(){
    jar_pid=`ps -ef|grep -v grep | grep 'java -jar ${jar_name} '|awk '{ print $2 }'`
    if [ ! -n "$jar_pid" ]; then
        echo "\033[32m ${jar_name} 服务没有启动 \033[0m"
    else
    kill -9 $jar_pid
    echo 'kill' $jar_pid
    fi

}

Service_Dev(){
    java -jar $path_root$jar_name
}

Service_Update(){
    local name=$1
    name_temp=$name.temp
    name_bak=$name.bak.$time
    wget $download_url$name -O $path_root$name_temp
    mv $path_root$name $path_root$name_bak
    mv $path_root$name_temp $path_root$name
}

Service_Update_Jar(){
    Service_Update $jar_name
}


Service_Update_Produce(){
    Service_Update config/$config_produce_name
}

Service_Update_Spervise(){
    Service_Update config/mapper/$config_spervise_name
}

Service_Logs(){
    tail -f $path_log
}

Service_Del_Temp(){
    rm -rf $path_root$jar_name.bak.*
}


Start_Main(){
if [ ! -n "${Run_CODE}" ] ;then
    	echo "*******请按键选择****
(1) 启动服务
(2) 停止服务
(3) 重启服务
(4) 启动调试
(5) 实时查看日志
(6) 更新jar包并启动测试
(61) 更新 application-produce.yml
(62) 更新 spervise.xml
(9) 删除备份文件
(0) 退出";
    read -p "请选择: " go
else
    go=${Run_CODE}
fi

case $go in
1)
Service_Start
;;
2)
Service_Stop
;;
3)
Service_Stop
Service_Start
;;
4)
Service_Dev
;;
5)
Service_Logs
;;
6)
Service_Update_Jar
Service_Dev
;;
61)
Service_Update_Produce
;;
62)
Service_Update_Spervise
;;
7)
;;
8)
;;
9)
Service_Del_Temp
;;
0)
exit;
;;
*)
Red_Error "输入有误!";
# Start_Main
;;
esac
}


echo "
+----------------------------------------------------------------------
| JAVA服务更新脚本 By 奇奇 qiqi@qiqid.com
+----------------------------------------------------------------------
| 本地项目路径： $path_root
+----------------------------------------------------------------------
| jar文件名称：         $jar_name
| produce文件名称：     $config_produce_name
| spervise文件名称：    $config_spervise_name
+----------------------------------------------------------------------
"
Start_Main
echo "\033[32m 完成 \033[0m"