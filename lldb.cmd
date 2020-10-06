# lldb.cmd 
# lldb --source debug.cmd
platform select ios-simulator
platform connect 72910B8C-9149-4260-8552-023E8543A0C9
process attach -n Calculator --waitfor
br s -F main
process continue

http://junch.github.io/debug/2016/09/19/original-lldb.html