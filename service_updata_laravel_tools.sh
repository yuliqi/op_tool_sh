#!/bin/bash
#author qiqi@qiqid.com
#date   2016-12-11
#检测服务器是否与上游服务器内容同步
#使用本脚本之前请先通过 git 命令克隆项目如  git clone -b master https://github.com/yuliqi/sh.git

#定义本地git仓库位置
git_repo="/data/wwwroot/website/"
#定义项目根目录git 目录中 web 根目录,可为空.
pro_repo="./"
#定义日志文件路径
pro_log="/data/wwwlogs/website_nginx.log"

clear
printf "
#######################################################################
罗布服务器自动运维脚本 for laravel
奇奇 qiqi@qiqid.com
更新路径：$git_repo
项目路径：$pro_repo
日志路径: $pro_log
#######################################################################
"
cat << EOF
********please enter your choise:(1-6)****
(1) 更新代码并执行优化
(2) 只更新代码
(3) 只更执行优化
(4) 禁用优化
(5) 关闭站点
(6) 打开站点
(7) 修复权限
(8) 查看版本记录
(9) 安装依赖
(10) 查看 nginx 访问日志
(11) 恢复最近一次版本提交过的状态
(0) 退出
EOF

cd $git_repo
read -p "请选择: " input
case $input in
1)
#远程服务器拉回上游服务器最新版本，并更新本地工作区到最新版本

git pull origin master

if [ $? -eq 0 ]
then
    echo "#####################"
    echo " PULL SUCCESS!"
    echo "#####################"
else
    echo "!!!!!!!!!!!!!!!!!!!!!"
    echo "PULL    FAIL!"
    echo "!!!!!!!!!!!!!!!!!!!!!"
fi
cd $pro_repo
#修复权限
chown -R www.www ./
echo "!!!!!!!!!!!!!!!!!!!!!"
echo "权限修复成功"
echo "!!!!!!!!!!!!!!!!!!!!!"
#维护模式
php artisan down
#生成路由缓存
php artisan route:cache
#生成配置缓存
php artisan config:cache
#类优化
php artisan optimize --force
#删除系统缓存文件
php artisan cache:clear
#关闭维护模式
php artisan up
;;
2)
#远程服务器拉回上游服务器最新版本，并更新本地工作区到最新版本
git pull origin master
if [ $? -eq 0 ]
then
    echo "#####################"
    echo " PULL SUCCESS!"
    echo "#####################"
else
    echo "!!!!!!!!!!!!!!!!!!!!!"
    echo "PULL    FAIL!"
    echo "!!!!!!!!!!!!!!!!!!!!!"
fi
;;
3)
#生成路由缓存
cd $pro_repo
php artisan route:cache
#生成配置缓存
php artisan config:cache
#类映射加载优化
php artisan optimize --force
#删除系统缓存文件
php artisan cache:clear
;;
4)
cd $pro_repo
#删除路由缓存
php artisan route:clear
#删除配置缓存
php artisan config:clear
#禁用类映射加载优化
php artisan clear-compiled
#删除系统缓存文件
php artisan cache:clear
;;
5)
cd $pro_repo
#维护模式
php artisan down
;;
6)
cd $pro_repo
#关闭维护模式
php artisan up
;;
7)
#修复权限
cd $pro_repo
chown -R www.www ./
echo "!!!!!!!!!!!!!!!!!!!!!"
echo "权限修复成功"
echo "!!!!!!!!!!!!!!!!!!!!!"
;;
8)
#查看版本
git log
;;
9)
cd $pro_repo
#安装依赖
composer install
;;
10)
#查看日志
tail -f $pro_log
;;
11)
#恢复最近一次提交过的状态
cd $pro_repo
git reset --hard
echo "!!!!!!!!!!!!!!!!!!!!!"
echo "执行完毕"
echo "!!!!!!!!!!!!!!!!!!!!!"
;;
esac
