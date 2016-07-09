#!/bin/bash

select ch in "begin" "end" "exit"; do
    case $ch in
        "begin")
            echo "start something"  
        ;;
        "end")
            echo "stop something"  
        ;;
        "exit")
            echo "exit"  
            break;
        ;;
        *)
            echo "Ignorant"  
        ;;
    esac
done;

## 注意这里交互输入要输入1，2，3，而不是beign，end，exit
# $ sh demo.sh
# 1) begin
# 2) end
# 3) exit