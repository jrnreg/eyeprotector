SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance Force
#Persistent
DetectHiddenWindows, On

#Include notify.ahk


;如果不存在图标自动退出
IfNotExist, %A_ScriptDir%\work.ico
{
MsgBox , , Error,工作图标文件不存在，5秒后程序自动退出。,5
ExitApp
}
IfNotExist, %A_ScriptDir%\suspend.ico
{
MsgBox , , Error,挂起图标文件不存在，5秒后程序自动退出。,5
ExitApp
}
IfNotExist, %A_ScriptDir%\noti.ico
{
MsgBox , , Error,通知图标文件不存在，5秒后程序自动退出。,5
ExitApp
}

TrayMenu:
Menu, Tray, Icon , %A_ScriptDir%\work.ico, IconNumber, 1
OnExit,Exit
;设置进程优先级为高
Process ,Priority,,High
;读取ini文件中的%循环时间数%,默认为10
IniRead, LoopTime, %A_Scriptdir%\Preferences.ini, Config, Loop Time (h||m||s), 10
;读取ini文件中的%声音文件%,默认声音文件为当前程序目录下的tweet.wav
IniRead, Soundfile, %A_Scriptdir%\Preferences.ini, Config, Audio File (wav), %A_Scriptdir%\tweet.wav
;读取ini文件中的%重复次数%,默认为3次
IniRead, Repeats, %A_Scriptdir%\Preferences.ini, Config, Repeats, 3
;读取ini文件中的%时间单位选项%,option1为时,option2为分,option3为秒,默认为option2分钟
IniRead, iOpt, %A_ScriptDir%\Preferences.ini, Options, Option, 2
;读取ini文件中的%执行任务项%,即下拉菜单中所选的条目号,1为挡屏,2为关机,3注销4重启5用户自定义,默认为条目1挡屏
IniRead, task, %A_Scriptdir%\Preferences.ini, Options, Task, 1
;读取ini文件中的任务文件,在执行任务项为5用户自定义的情况下,%用户文件% ,自定义文件完整路径，默认为explorer.exe，必须指定默认文件，否则不存在配置文件时，生成的配置文件默认Ufile的值为ERROR
IniRead, Ufile, %A_ScriptDir%\Preferences.ini, Options, User define file,%A_WinDir%\explorer.exe

;托盘条目
Menu, tray, add, 重载, Start
Menu, tray, add,
Menu, tray, add, 配置...,prefs
Menu, tray, add,
Menu, tray, add, 关于..., ABOUT
Menu, tray, add,
Menu, tray, add, 退出, exit
Menu, tray, tip, Loop Timer
Menu, tray, NoStandard




;开始任务
StartSession:
;计数器清零
counter = 0
Sleep, 500
;如果存在配置窗口转向suspend标签
IfWinExist, %A_Scriptname% Preferences
{
;MsgBox prefs exist
Gosub, suspend
}
;如果不存在配置窗口,取消暂停
IfWinNotExist, %A_Scriptname% Preferences
{
;MsgBox prefs not exist
Pause, Off
}
;通知("标题","信息",持续时间,"窗口颜色,底层面板颜色,标题字颜色,信息字颜色,标题字尺寸,标题宽度,标题字体,信息尺寸,信息宽度,信息字体,面板圆角半径仅影响边缘圆角,GUI圆角半径仅影响上层GUI圆角,面板透明度仅影响边缘(上层GUI,下层面板),图片(面板左上角的小图标)图标名称,图片宽度,图片高度,面板厚度边缘) A_ScriptDir "\work.ico" 表示当前目录下的work.ico图标文件 ， "IN=8",A_WinDir "\explorer.exe"表示windows目录下的explorer.exe文件中的第8个图标, A_ScriptDir "\noti.ico"表示当前程序目录下的noti.ico图标文件
;notify("新任务","任务开始",3,"GC=FFFFAA BC=silver TC=black MC=black TS=8 TW=825 TF=simsun MS=8 MW=750 MF=simsun BR=8 GR=9 BT=105 GT=220 IN=20 IW=20 IH=20 BW=2",222)
;;notify("新任务","开始任务", 0,"GC=32312D BC=red TC=E7E0CC MC=silver TS=18 TW=825 TF=Arial MS=16 MW=750 MF=Arial BR=8 GR=9 BT=off GT=off IN=1 IW=30 IH=30 BW=1 BF=100",A_ScriptDir "\noti.ico")
;notify("新任务","开始任务", 1,"GC=FBFBAA BC=000000 TC=black MC=black TS=8 TW=825 TF=Arial MS=8 MW=750 MF=Arial BR=10 GR=10 BT=0 GT=220 IN=1 IW=10 IH=10 BW=2 BF=off",0)
notify("新任务","开始任务", 0,"GC=3b3b3b BC=3b3b3b TC=BCC2C2 MC=silver TS=18 TW=825 TF=Arial MS=16 MW=750 MF=Arial BR=10 GR=10 BT=105 GT=220 IN=1 IW=25 IH=25 BW=0 BF=100",A_ScriptDir "\noti.ico")
Sleep, 100
;如果声音文件不为空, 如果已指定%声音文件%不存在,通知 否则播放指定声音文件,(作用是在已选择声音文件的情况下,即指定声音文件路径不为空,但声音文件本身不存在,如更名或转移目录了则出现重新指定声音文件的提示)
If Soundfile!=
  {
  IfNotExist, %Soundfile%
  MsgBox ,64, ,声音文件无效，请重新指定或指定为空。
  Else
  SoundPlay, %Soundfile%
  Sleep, 2000
  }
Else
Sleep, 1000
;关闭notify
Notify("","",-1,"Wait")



;设置工作时间
SetWorkTime:
;如果存在"黑屏"窗口,休眠100毫秒,即不进行其它特别动作
        IfWinExist, Blackscreen
        Sleep, 100
;计数器以1为步长值递进
counter += 1
;如果计数器大于%重复次数%
If counter > %repeats%
;转到结束任务标签
    Gosub, EndSession ;Goto
;否则
  Else
  {
    ;定义变量"允许时间" ,允许时间=%循环时间数%
    allowedMinutes = %LoopTime%
    ;定义变量"中止时间" 当前时间如20100917180145(2010年9月17日18点01分45秒)以数值形式赋给变量"中止时间"
    FormatTime,now,,HHmmss
    endTime := now
    ;如果%时间单位选项%为1,即以小时为单位
    if iOpt=1
    {
    ;中止时间以上面刚定义的%允许时间%为步长值,以小时为单位递进
    endTime += %allowedMinutes%, Hours
    }
    ;;如果%时间单位选项%为2,即以分钟为单位
    else if iOpt=2
    {
    ;中止时间以%允许时间%为步长值,以小时为分钟递进
    endTime += %allowedMinutes%, Minutes
    }
    ;如果%时间单位选项%为3,即以秒钟为单位
    else
    {
    ;中止时间以%允许时间%为步长值,以秒钟为单位递进
    endTime += %allowedMinutes%, Seconds
    }
  ;设置运行间隔时间为1秒
    SetTimer, WorkTimer, 1000
  }
;工作器:
WorkTimer:
    ;定义剩余时间变量,将中止时间的值以数值形式赋给它,如中止时间为20100917181145(2010年9月17日18点11分45秒)
    remainingTime := endTime

     ;剩余时间=剩余时间-当前时间(以秒为单位),如20100917181145(2010年9月17日18点11分45秒)-20100917180145(2010年9月17日18点01分45秒)=600秒 (即10分钟)
     EnvSub remainingTime, %A_Now%, Seconds

     ;定义变量h将 剩余时间整除60整除60后的值赋给它
     h := remainingTime // 60 // 60

     ;定义变量m将 剩余时间整除60后的值赋给它
     m := remainingTime // 60

     ;定义变量s将 剩余时间与60求模后的值赋给它.即剩余时间除以60时余下的值.结果为正.
     s := Mod(remainingTime, 60)

     ;定义变量"显示时间",值为 数字格式(h):数字格式(m):数字格式(s) ,hms为上面定义的变量,实际值分别为剩余时间的 "时" "分" "秒","数字格式"是一个函数,在后面定义.
     displayedTime := Format2Digits(h) ":" Format2Digits(m) ":" Format2Digits(s)

     ;托盘图标设为工作状态
     Menu, Tray, Icon , %A_ScriptDir%\work.ico, IconNumber, 1

     ;如果"时间选项"为1 则托盘气泡显示提示: %循环时间%小时 * %循环次数%次 当前执行任务第%计数器%次 当前剩余时间 %显示时间%
     ;如果"时间选项"为2 则托盘气泡显示提示: %循环时间%分钟 * %循环次数%次 当前执行任务第%计数器%次 当前剩余时间 %显示时间%
     ;如果"时间选项"为3 则托盘气泡显示提示: %循环时间%秒 * %循环次数%次 当前执行任务第%计数器%次 当前剩余时间 %显示时间%
     if iOpt=1
     Menu, tray, Tip, %LoopTime%小时*%Repeats%次`n当前执行任务第%counter%次`n当前剩余时间`n%displayedTime%`n`n ; Icon Tip
     if iOpt=2
     Menu, tray, Tip, %LoopTime%分钟*%Repeats%次`n当前执行任务第%counter%次`n当前剩余时间`n%displayedTime%`n`n ; Icon Tip
     if iOpt=3
     Menu, tray, Tip, %LoopTime%秒钟*%Repeats%次`n当前执行任务第%counter%次`n当前剩余时间`n%displayedTime%`n`n ; Icon Tip

     ;如果"显示时间"=00:00:00,即剩余时间为0
      If displayedTime = 00:00:00
      {

        ;如果"执行任务项"为1,如果窗口"黑屏"不在激活状态则转向blackscr标签,如果在激活状态则休眠100毫秒即有黑屏时不重复执行黑屏,但不能用IfWinNotExist,因为看不到黑屏窗口时窗口关闭或不可见不代表不存在,只有gui Destroy才是销毁窗口式的不存在.
        ;如果"执行任务项"为2,如果存在窗口"黑屏",销毁黑屏窗口,转向shut标签
        ;如果"执行任务项"为3,如果存在窗口"黑屏",销毁黑屏窗口,转向logoff标签
        ;如果"执行任务项"为4,如果存在窗口"黑屏",销毁黑屏窗口,转向restart标签
        ;如果"执行任务项"为5,如果存在窗口"黑屏",销毁黑屏窗口,转向udef标签
         if task=1
            {
            IfWinNotActive, Blackscreen
            Gosub, blackscr
            Else Sleep, 100
            }
         Else if task=2
            {
            IfWinExist, Blackscreen
            Gui, Destroy
            Gosub, Shut
            }
          Else if task=3
            {
            IfWinExist, Blackscreen
            Gui, Destroy
            Gosub, Logoff
            }
          Else if task=4
            {
            IfWinExist, Blackscreen
            Gui, Destroy
            Gosub, Restart
            }
          Else if task=5
            {
            IfWinExist, Blackscreen
            Gui, Destroy
            Gosub, Udef
            }

          ;如果"执行任务项"不为1-5中的任意一个数字,则提示错误 避免手动修改配置文件中的task行为其它值时出错
          Else MsgBox,,task error,任务文件指定错误，请在配置窗口中选择所要执行的任务。

        ;转到设置运行间隔时间,标签内用goto,不带回返回值,标签外转向用gosub带回返回值,转向后的标签执行完后return,带返回值到转向前的标签gosub的下一行
        Goto, SetWorkTime
      }
   Return


;配置窗口
;销毁生成的其它窗口,如"黑屏",在"黑屏"状态下使用快捷键打开配置窗口,黑屏被销毁.
;总在最前
;删除系统菜单和点击窗体左上角的图片所弹出的菜单。同时也删除标题栏上的最小化最大化按钮。
;正常字体

prefs:
Gui, Destroy
Gui, +AlwaysOnTop
Gui, -SysMenu
Gui, Font

;添加GroupBox（分组框）循环时间, 有利于用户识别，使界面变得更加友好,将一个窗体中的各种功能进一步进行分类，可将各种选项按钮控件分隔开。
;添加文本区域 显示文字 循环时间
;添加编辑框, 编辑框内的内容居中,  vLoop 前的V: 要使一个控件和一个变量相关联。在字母 V 后面加上变量名，该变量将是全局变量
;添加依附于编辑框的增减按钮,范围为1-99999, 值为%循环时间% ,如果输入的数值小于1则自动变为1,大于99999则自动变为99999
;添加单选框, 显示名称为 t1 时
;添加单选框, 显示名称为 t2 分
;添加单选框, 显示名称为 t3 秒
;选择单选框,如果%iopt%为1则选择t1,iopt不为0
Gui, Add, GroupBox, x16 y+5 w320 h100 , 循环时间
Gui, Add, Text, x50 y47 w70 h30 Section, 循环时间
Gui, Add, Edit, x120 y43 w80 h20 +Center vLoopTime
Gui, add, UpDown, Range1-99999,%LoopTime%
Gui, Add, Radio,x225 y15 w80 h30 vRadioButton, t1 时
Gui, Add, Radio,x225 y40 w80 h30 , t2 分
Gui, Add, Radio,x225 y65 w80 h30 , t3 秒
GuiControl,, t%iOpt%, % (iOpt <> 0)

;添加GroupBox（分组框）循环次数
;添加文本区域 执行次数
;添加编辑框, 编辑框内的内容居中,
;添加依附于编辑框的增减按钮,范围为1-999, 值为%重复次数% ,如果输入的数值小于1则自动变为1,大于999则自动变为999
;添加文本区域 次
Gui, Add, GroupBox, x16 y107 w320 h70 , 循环次数
Gui, Add, Text, x50 y141 w70 h30 , 执行次数
Gui, Add, Edit, x120 y137 w80 h20  +Center vRepeats
Gui, add, UpDown,Range1-999, %repeats%
Gui, Add, Text, x225 y141 w80 h30 , 次

;添加GroupBox（分组框）提示声音
;添加文本区域
;添加编辑框, vsdfile, 内容为%声音文件%
;添加文本区域
;添加按钮 选择文件, gSelect:字母G后面加上标签名，表示当当用户点击或改变一个变量，脚本会自动跳转到关联的子过程如"Select"标签。 &F表示按alt+F等同于点击该按钮.
Gui, Add, GroupBox, x16 y187 w320 h155 , 提示声音
Gui, Add, Text, x26 y207 w290 h20 , 提示声音:在下栏输入提示声音文件完整路径
Gui, Add, Edit, x26 y227 w290 h40 vSdfile, %soundfile%
Gui, Add, Text, x30 y285 w290 h40 , 或点击“选择文件”按钮`n手动选择声音文件位置
Gui, Add, Button, x186 y283 w110 h25 gSelectfile, 选择文件(&F)

;任务们=挡屏|关机|注销|重启|用户自定义
;添加GroupBox（分组框）任务文件
;添加文本区域
;添加下拉菜单,vTask内容存储到变量task中, gTaskselect内容改变响应转向"Taskselect"标签, 下拉菜单的条目由上面定义的 "任务们"中的项所决定
;添加按钮 自定义文件
;添加文本区域 变量Taskf 值为%任务%
;按"任务"的值选择名为task的下拉菜单中的内容,如%任务%值为1,则选择下拉菜单中的第1条,即tasks的第1项:挡屏
;如果"任务"=5
;在文本区域taskf处显示%用户文件%
tasks = 挡屏|关机|注销|重启|用户自定义
Gui, Add, GroupBox, x16 y352 w320 h140 , 任务文件
Gui, Add, Text, x26 y383 w270 h20 , 在下栏选择要执行的任务
Gui, Add, DropDownList,x26 y412 w150 h150 AltSubmit vTask gTaskselect, %tasks%
Gui, Add, Button, x186 y412 w110 h24 gUserfile, 自定义文件(&U)
Gui, Add, Text, x26 y452 w305 h30 vTaskf , %task%
GuiControl, Choose, task, %task%
if task=5
Guicontrol,,taskf, %ufile%

;字体粗体
;添加按钮 保存,关联Save标签
;添加按钮 取消,关联Cancel标签
;界面显示 宽354 高551 "%脚本名% Preferences
;托盘图标设为工作状态
;暂停开启 作用是打开配置窗口时暂停脚本运行,暂停计时等
Gui, Font,Bold
Gui, add, Button, x46 y507 w80 h25 Default gSave,保存(&S)
Gui, add, Button, x206 y507 w80 h25 gCancel,取消(&C)
Gui,Show,w354 h551,%A_Scriptname% Preferences
Menu, Tray, Icon , %A_ScriptDir%\suspend.ico, IconNumber, 1
Pause, On
Return

;托盘选项start为重载
Start:
  Reload
Return

;按钮Save
;提交,取消隐藏
;
;写入ini文件中的Config大项下的 Loop Time (h||m||s) =后面   以%循环时间数%的值
;写入ini文件中的Config大项下的 Audio File (wav) =后面   以%声音文件%的值
;写入ini文件中的Config大项下的 Repeats =后面   以%重复次数%的值
;写入ini文件中的Option大项下的 Option =后面   以%时间单位选项%的值
;写入ini文件中的Option大项下的 Task =后面   以%执行任务项%的值
;写入ini文件中的Option大项下的 User define file =后面   以%用户文件%的值

Save:
  Gui,Submit,NoHide
  soundfile:=Sdfile
  IniWrite, %LoopTime%, %A_ScriptDir%\Preferences.ini, Config, Loop Time (h||m||s)
  IniWrite, %Soundfile%, %A_ScriptDir%\Preferences.ini, Config, Audio File (wav)
  IniWrite, %Repeats%, %A_Scriptdir%\Preferences.ini, Config, Repeats
  IniWrite, % RadioButton, %A_ScriptDir%\Preferences.ini, Options, Option
  IniWrite, %task%, %A_Scriptdir%\Preferences.ini, Options, Task
  IniWrite, %ufile%, %A_Scriptdir%\Preferences.ini, Options, User define file
  Gui,Destroy
  Menu, Tray, Icon , %A_ScriptDir%\work.ico, IconNumber, 1
  Reload
Return



/*
;;关闭窗口,配置窗口设置-SysMenu后没有最小最大化和关闭按钮,按esc也不会退出窗口,因此此段无必要.
guiescape:
guiclose:
  Gui, Destroy
  Pause, Off
  Menu, Tray, Icon , %A_ScriptDir%\work.ico, IconNumber, 1
Return
*/



;"数字格式"函数
;_val 以100为步长值递进
;将_val的值从右往左取2位存入到_cal中,如_val的初值为990198,现值为98
;返回_val的值
Format2Digits(_val)
  {
   _val += 10000
   StringRight _val, _val, 4
   Return _val
  }

;取消按钮
;取消暂停
;当前窗口销毁
Cancel:
Pause, Off
Gui, Destroy
Sleep, 500
;Menu, Tray, Icon , %A_ScriptDir%\work.ico, IconNumber, 1
;Gosub, StartSession
Return

;选择文件标签
;为上一窗口的子窗口
;选择文件,默认是windows\media目录下,规定文件格式为.wav
;如果"声音文件"为空,通知没有音频文件,无提示声音
;否则(即不为空),通知您选择了%声音文件%为提示声音
;提交
;控件编辑框sdfile中显示当前选择的%声音文件%
selectfile:
Gui +OwnDialogs
FileSelectFile, Soundfile, 3, %SystemRoot%\Media\, Open a file, Wave Documents (*.wav)
if Soundfile =
    MsgBox, 没有选择音频文件，无提示声音。
else
    MsgBox, 您选择了下列文件:`n%Soundfile%作为提示声音。
Gui, Submit, NoHide
GuiControl,,Sdfile,%Soundfile%
Return

;选择用户自定义文件标签:
;为上一窗口的子窗口
;选择文件,默认是program files目录下,规定文件格式为.exe
;如果"用户文件"为空,通知没有执行文件,默认为挡屏. 同时选择控件下拉菜单中的任务为第1条目,即挡屏
;否则,通知选择了%用户文件%为执行文件,同时选择控件下拉菜单中的任务为第5条目,即用户自定义
;提交界面
;控件taskf文本区域显示%用户文件%完整路径
Userfile:
Gui +OwnDialogs
FileSelectFile, ufile, 3, %ProgramFiles%\, Open a file, Executable file (*.exe)
if ufile =
    {
    MsgBox, 没有选择执行文件，默认为挡屏。
    GuiControl,Choose,task,|1
    }
else
    {
    MsgBox, 您选择了下列文件:`n%ufile%作为执行文件。
    GuiControl,Choose,task,|5
    }
Gui, Submit, NoHide
GuiControl,,taskf,%ufile%
Return


;任务选择标签: 响应下拉菜单中的每一个条目,判断选择不同的条目时进行的动作(即时)
;界面提交,不隐藏
;如果"任务"=1 , "用户文件"清空 ,控件taskf文本区域显示BlkScreen
;如果"任务"=2 , "用户文件"清空 ,控件taskf文本区域显示Shutdown
;如果"任务"=3 , "用户文件"清空 ,控件taskf文本区域显示Logoff
;如果"任务"=4 , "用户文件"清空 ,控件taskf文本区域显示Restart
Taskselect:
Gui,Submit,NoHide
if task=1
{
ufile=
GuiControl,,taskf,BlkScreen
}
Else if task=2
{
ufile=
GuiControl,,taskf,Shutdown
}
Else if task=3
{
ufile=
GuiControl,,taskf,Logoff
}
Else if task=4
{
ufile=
GuiControl,,taskf,Restart
}

;如果"任务"=5 ,如果"用户文件"为空 ,转到"用户自定义文件"标签. 否则,控件taskf文本区域显示%用户文件%完整路径,控件task下拉菜单选择第5项 "用户自定义" (注意:此外不可用 if task=5 gosub,userfile   即不能判断task=5后直接跳转到Userfile标签,如果跳转到Userfile后,选择用户文件,同时选择控件下拉菜单中的任务为第5条目GuiControl choose task 5,就会跳回Taskselect标签,反复循环.) 所以此处只能先判断"用户文件"是否为空,如果为空才跳转到Userfile进行选择文件,如果不为空则只选定下拉菜单中的第5条目.(这也是为什么前4个任务被选择时一定要先清空"用户文件"的内容.防止上次选择用户文件后有残留,即使不选第5条目,"用户文件"也不为空,则下面的判断就会失效.)
Else if task=5
{
  If (ufile="")
  Gosub, Userfile
  Else
  {
    GuiControl,,taskf,%ufile%
    GuiControl,Choose,task,|5
  }
}
;如果"执行任务项"不为1-5中的任意一个数字,则提示错误 避免手动修改配置文件中的task行为其它值时出错
Else
{
MsgBox task error
}
Return

;关机标签
;shutdown 13表示强制关机并关闭电源
Shut:
MsgBox, 4,, 是否继续执行关机！？`n点“是”则自动强制关机，“否”则退出程序
IfMsgBox Yes
    Shutdown, 13
else
    ExitApp
return

;注销标签
Logoff:
MsgBox, 4,, 是否继续执行注销？`n点“是”则自动注销当前用户，“否”则退出程序
IfMsgBox Yes
    Shutdown, 0
else
    ExitApp
return

;重启标签
Restart:
MsgBox, 4,, 是否继续执行重启？`n点“是”则自动重启，“否”则退出程序
IfMsgBox Yes
    Shutdown, 6
else
    ExitApp
return

;用户自定标签 : 如果上面的执行任务项目为5时,计时中止,则转到这里,执行指定的文件
;如果"用户文件"为空,通知 没有指定文件
;否则,执行%用户文件%
Udef:
If ufile=
MsgBox, 没有指定执行文件。
Else
run , %ufile%
Return

;锁定标签:
Lockworkstation:
Run, %windir%\system32\rundll32.exe user32.dll,LockWorkStation
Return

;黑屏标签: 即挡屏
;如果存在配置窗口,销毁它
;创建一个界面,总在最前,无标题栏和最大最小关闭等按钮
;颜色为黑
;显示界面 名为"黑屏"
;设置透明度为150
;取当前鼠标指针的坐标 分别存入变量X和Y中
;把鼠标指针移到最右下角
blackscr:
IfWinExist, %A_Scriptname% Preferences
Gui, Destroy
Gui +AlwaysOnTop -Caption +ToolWindow
Gui Color, 0
Gui Show, x0 y0 h%A_ScreenHeight% w%A_ScreenWidth%, Blackscreen
WinSet Transparent, 150, A
MouseGetPos X, Y
MouseMove %A_ScreenWidth%,%A_ScreenHeight%
Return

;退出黑屏热键标签: 热键为win+q
;如果存在"黑屏"窗口
;激活"黑屏"窗口
;关闭"黑屏"窗口
;鼠标指针还原到上面变量X和Y中记录的坐标位置
;;如果不存在配置窗口 这个判定无必要
;返回
$#q::
{
  IfWinExist Blackscreen
    {
    WinActivate Blackscreen
    WinClose Blackscreen
    }
  Sleep, 1000
  MouseMove %X%, %Y%
}
;IfWinNotExist, %A_Scriptname% Preferences
Return

;结束任务标签:
;通知任务完成
;播放%声音文件%
;关闭通知窗口
;转到"挂起"标签
EndSession:
notify("完成","任务结束", 0,"GC=3b3b3b BC=3b3b3b TC=BCC2C2 MC=silver TS=18 TW=825 TF=Arial MS=16 MW=750 MF=Arial BR=10 GR=10 BT=105 GT=220 IN=1 IW=25 IH=25 BW=0 BF=100",A_ScriptDir "\noti.ico")
Sleep, 100
;如果声音文件不为空, 如果已指定%声音文件%不存在,通知 否则播放指定声音文件
If Soundfile!=
  {
  IfNotExist, %Soundfile%
  MsgBox ,64, ,声音文件无效，请重新指定或指定为空。
  Else
  SoundPlay, %Soundfile%
  Sleep, 2000
  }
Else
Sleep, 1000
Notify("","",-1,"Wait")
      Gosub, suspend
      Sleep, 50
Return

;挂起标签
;托盘图标设置为挂起状态
;计数器清零
;如果"时间选项"为1 则托盘气泡显示提示: %循环时间%小时 * %循环次数%次 已执行任务第%计数器%次 当前剩余时间 %显示时间% 任务结束 暂停模式
;如果"时间选项"为2 则托盘气泡显示提示: %循环时间%分钟 * %循环次数%次 已执行任务第%计数器%次 当前剩余时间 %显示时间% 任务结束 暂停模式
;如果"时间选项"为3 则托盘气泡显示提示: %循环时间%秒 * %循环次数%次 已执行任务第%计数器%次 当前剩余时间 %显示时间% 任务结束 暂停模式
;暂停 开启
suspend:
  Menu, Tray, Icon , %A_ScriptDir%\suspend.ico, IconNumber, 1
  Counter = 0
  if iOpt=1
  Menu, tray, Tip, %LoopTime%小时*%Repeats%次`n已执行任务 %counter%次`n当前剩余时间`n%displayedTime%1`n任务结束`n暂停模式`n`n
  if iOpt=2
  Menu, tray, Tip, %LoopTime%分钟*%Repeats%次`n已执行任务 %counter%次`n当前剩余时间`n%displayedTime%`n任务结束`n暂停模式`n`n
  if iOpt=3
  Menu, tray, Tip, %LoopTime%秒钟*%Repeats%次`n已执行任务 %counter%次`n当前剩余时间`n%displayedTime%`n任务结束`n暂停模式`n`n
  Sleep, 100
  Pause, On
  Return

;F10键打开配置窗口
F10::
Sleep,99
Gosub,prefs
Return

exit:
ExitApp

$#x::
ExitApp

About:
MsgBox when ready for primetime, will complete this section
;MsgBox,262144,about,`n                   special for miffy.`n `n   rest belongs to the work as the eyelids to the eyes.`n `n                  wish you a good day!`n `n         this message will disappear after 0.3s.,0.3
Return




