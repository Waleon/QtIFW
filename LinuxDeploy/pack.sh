#!/bin/sh
exe="MyApp" #可执行文件名称
des="/home/waleon/workspace/deploy" #依赖库被拷贝的最终位置
deplist=$(ldd $exe | awk  '{if (match($3,"/")){ printf("%s "),$3 } }')
cp $deplist $des
