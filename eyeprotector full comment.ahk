SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance Force
#Persistent
DetectHiddenWindows, On

#Include notify.ahk


;���������ͼ���Զ��˳�
IfNotExist, %A_ScriptDir%\work.ico
{
MsgBox , , Error,����ͼ���ļ������ڣ�5�������Զ��˳���,5
ExitApp
}
IfNotExist, %A_ScriptDir%\suspend.ico
{
MsgBox , , Error,����ͼ���ļ������ڣ�5�������Զ��˳���,5
ExitApp
}
IfNotExist, %A_ScriptDir%\noti.ico
{
MsgBox , , Error,֪ͨͼ���ļ������ڣ�5�������Զ��˳���,5
ExitApp
}

TrayMenu:
Menu, Tray, Icon , %A_ScriptDir%\work.ico, IconNumber, 1
OnExit,Exit
;���ý������ȼ�Ϊ��
Process ,Priority,,High
;��ȡini�ļ��е�%ѭ��ʱ����%,Ĭ��Ϊ10
IniRead, LoopTime, %A_Scriptdir%\Preferences.ini, Config, Loop Time (h||m||s), 10
;��ȡini�ļ��е�%�����ļ�%,Ĭ�������ļ�Ϊ��ǰ����Ŀ¼�µ�tweet.wav
IniRead, Soundfile, %A_Scriptdir%\Preferences.ini, Config, Audio File (wav), %A_Scriptdir%\tweet.wav
;��ȡini�ļ��е�%�ظ�����%,Ĭ��Ϊ3��
IniRead, Repeats, %A_Scriptdir%\Preferences.ini, Config, Repeats, 3
;��ȡini�ļ��е�%ʱ�䵥λѡ��%,option1Ϊʱ,option2Ϊ��,option3Ϊ��,Ĭ��Ϊoption2����
IniRead, iOpt, %A_ScriptDir%\Preferences.ini, Options, Option, 2
;��ȡini�ļ��е�%ִ��������%,�������˵�����ѡ����Ŀ��,1Ϊ����,2Ϊ�ػ�,3ע��4����5�û��Զ���,Ĭ��Ϊ��Ŀ1����
IniRead, task, %A_Scriptdir%\Preferences.ini, Options, Task, 1
;��ȡini�ļ��е������ļ�,��ִ��������Ϊ5�û��Զ���������,%�û��ļ�% ,�Զ����ļ�����·����Ĭ��Ϊexplorer.exe������ָ��Ĭ���ļ������򲻴��������ļ�ʱ�����ɵ������ļ�Ĭ��Ufile��ֵΪERROR
IniRead, Ufile, %A_ScriptDir%\Preferences.ini, Options, User define file,%A_WinDir%\explorer.exe

;������Ŀ
Menu, tray, add, ����, Start
Menu, tray, add,
Menu, tray, add, ����...,prefs
Menu, tray, add,
Menu, tray, add, ����..., ABOUT
Menu, tray, add,
Menu, tray, add, �˳�, exit
Menu, tray, tip, Loop Timer
Menu, tray, NoStandard




;��ʼ����
StartSession:
;����������
counter = 0
Sleep, 500
;����������ô���ת��suspend��ǩ
IfWinExist, %A_Scriptname% Preferences
{
;MsgBox prefs exist
Gosub, suspend
}
;������������ô���,ȡ����ͣ
IfWinNotExist, %A_Scriptname% Preferences
{
;MsgBox prefs not exist
Pause, Off
}
;֪ͨ("����","��Ϣ",����ʱ��,"������ɫ,�ײ������ɫ,��������ɫ,��Ϣ����ɫ,�����ֳߴ�,������,��������,��Ϣ�ߴ�,��Ϣ���,��Ϣ����,���Բ�ǰ뾶��Ӱ���ԵԲ��,GUIԲ�ǰ뾶��Ӱ���ϲ�GUIԲ��,���͸���Ƚ�Ӱ���Ե(�ϲ�GUI,�²����),ͼƬ(������Ͻǵ�Сͼ��)ͼ������,ͼƬ���,ͼƬ�߶�,����ȱ�Ե) A_ScriptDir "\work.ico" ��ʾ��ǰĿ¼�µ�work.icoͼ���ļ� �� "IN=8",A_WinDir "\explorer.exe"��ʾwindowsĿ¼�µ�explorer.exe�ļ��еĵ�8��ͼ��, A_ScriptDir "\noti.ico"��ʾ��ǰ����Ŀ¼�µ�noti.icoͼ���ļ�
;notify("������","����ʼ",3,"GC=FFFFAA BC=silver TC=black MC=black TS=8 TW=825 TF=simsun MS=8 MW=750 MF=simsun BR=8 GR=9 BT=105 GT=220 IN=20 IW=20 IH=20 BW=2",222)
;;notify("������","��ʼ����", 0,"GC=32312D BC=red TC=E7E0CC MC=silver TS=18 TW=825 TF=Arial MS=16 MW=750 MF=Arial BR=8 GR=9 BT=off GT=off IN=1 IW=30 IH=30 BW=1 BF=100",A_ScriptDir "\noti.ico")
;notify("������","��ʼ����", 1,"GC=FBFBAA BC=000000 TC=black MC=black TS=8 TW=825 TF=Arial MS=8 MW=750 MF=Arial BR=10 GR=10 BT=0 GT=220 IN=1 IW=10 IH=10 BW=2 BF=off",0)
notify("������","��ʼ����", 0,"GC=3b3b3b BC=3b3b3b TC=BCC2C2 MC=silver TS=18 TW=825 TF=Arial MS=16 MW=750 MF=Arial BR=10 GR=10 BT=105 GT=220 IN=1 IW=25 IH=25 BW=0 BF=100",A_ScriptDir "\noti.ico")
Sleep, 100
;��������ļ���Ϊ��, �����ָ��%�����ļ�%������,֪ͨ ���򲥷�ָ�������ļ�,(����������ѡ�������ļ��������,��ָ�������ļ�·����Ϊ��,�������ļ���������,�������ת��Ŀ¼�����������ָ�������ļ�����ʾ)
If Soundfile!=
  {
  IfNotExist, %Soundfile%
  MsgBox ,64, ,�����ļ���Ч��������ָ����ָ��Ϊ�ա�
  Else
  SoundPlay, %Soundfile%
  Sleep, 2000
  }
Else
Sleep, 1000
;�ر�notify
Notify("","",-1,"Wait")



;���ù���ʱ��
SetWorkTime:
;�������"����"����,����100����,�������������ر���
        IfWinExist, Blackscreen
        Sleep, 100
;��������1Ϊ����ֵ�ݽ�
counter += 1
;�������������%�ظ�����%
If counter > %repeats%
;ת�����������ǩ
    Gosub, EndSession ;Goto
;����
  Else
  {
    ;�������"����ʱ��" ,����ʱ��=%ѭ��ʱ����%
    allowedMinutes = %LoopTime%
    ;�������"��ֹʱ��" ��ǰʱ����20100917180145(2010��9��17��18��01��45��)����ֵ��ʽ��������"��ֹʱ��"
    FormatTime,now,,HHmmss
    endTime := now
    ;���%ʱ�䵥λѡ��%Ϊ1,����СʱΪ��λ
    if iOpt=1
    {
    ;��ֹʱ��������ն����%����ʱ��%Ϊ����ֵ,��СʱΪ��λ�ݽ�
    endTime += %allowedMinutes%, Hours
    }
    ;;���%ʱ�䵥λѡ��%Ϊ2,���Է���Ϊ��λ
    else if iOpt=2
    {
    ;��ֹʱ����%����ʱ��%Ϊ����ֵ,��СʱΪ���ӵݽ�
    endTime += %allowedMinutes%, Minutes
    }
    ;���%ʱ�䵥λѡ��%Ϊ3,��������Ϊ��λ
    else
    {
    ;��ֹʱ����%����ʱ��%Ϊ����ֵ,������Ϊ��λ�ݽ�
    endTime += %allowedMinutes%, Seconds
    }
  ;�������м��ʱ��Ϊ1��
    SetTimer, WorkTimer, 1000
  }
;������:
WorkTimer:
    ;����ʣ��ʱ�����,����ֹʱ���ֵ����ֵ��ʽ������,����ֹʱ��Ϊ20100917181145(2010��9��17��18��11��45��)
    remainingTime := endTime

     ;ʣ��ʱ��=ʣ��ʱ��-��ǰʱ��(����Ϊ��λ),��20100917181145(2010��9��17��18��11��45��)-20100917180145(2010��9��17��18��01��45��)=600�� (��10����)
     EnvSub remainingTime, %A_Now%, Seconds

     ;�������h�� ʣ��ʱ������60����60���ֵ������
     h := remainingTime // 60 // 60

     ;�������m�� ʣ��ʱ������60���ֵ������
     m := remainingTime // 60

     ;�������s�� ʣ��ʱ����60��ģ���ֵ������.��ʣ��ʱ�����60ʱ���µ�ֵ.���Ϊ��.
     s := Mod(remainingTime, 60)

     ;�������"��ʾʱ��",ֵΪ ���ָ�ʽ(h):���ָ�ʽ(m):���ָ�ʽ(s) ,hmsΪ���涨��ı���,ʵ��ֵ�ֱ�Ϊʣ��ʱ��� "ʱ" "��" "��","���ָ�ʽ"��һ������,�ں��涨��.
     displayedTime := Format2Digits(h) ":" Format2Digits(m) ":" Format2Digits(s)

     ;����ͼ����Ϊ����״̬
     Menu, Tray, Icon , %A_ScriptDir%\work.ico, IconNumber, 1

     ;���"ʱ��ѡ��"Ϊ1 ������������ʾ��ʾ: %ѭ��ʱ��%Сʱ * %ѭ������%�� ��ǰִ�������%������%�� ��ǰʣ��ʱ�� %��ʾʱ��%
     ;���"ʱ��ѡ��"Ϊ2 ������������ʾ��ʾ: %ѭ��ʱ��%���� * %ѭ������%�� ��ǰִ�������%������%�� ��ǰʣ��ʱ�� %��ʾʱ��%
     ;���"ʱ��ѡ��"Ϊ3 ������������ʾ��ʾ: %ѭ��ʱ��%�� * %ѭ������%�� ��ǰִ�������%������%�� ��ǰʣ��ʱ�� %��ʾʱ��%
     if iOpt=1
     Menu, tray, Tip, %LoopTime%Сʱ*%Repeats%��`n��ǰִ�������%counter%��`n��ǰʣ��ʱ��`n%displayedTime%`n`n ; Icon Tip
     if iOpt=2
     Menu, tray, Tip, %LoopTime%����*%Repeats%��`n��ǰִ�������%counter%��`n��ǰʣ��ʱ��`n%displayedTime%`n`n ; Icon Tip
     if iOpt=3
     Menu, tray, Tip, %LoopTime%����*%Repeats%��`n��ǰִ�������%counter%��`n��ǰʣ��ʱ��`n%displayedTime%`n`n ; Icon Tip

     ;���"��ʾʱ��"=00:00:00,��ʣ��ʱ��Ϊ0
      If displayedTime = 00:00:00
      {

        ;���"ִ��������"Ϊ1,�������"����"���ڼ���״̬��ת��blackscr��ǩ,����ڼ���״̬������100���뼴�к���ʱ���ظ�ִ�к���,��������IfWinNotExist,��Ϊ��������������ʱ���ڹرջ򲻿ɼ�����������,ֻ��gui Destroy�������ٴ���ʽ�Ĳ�����.
        ;���"ִ��������"Ϊ2,������ڴ���"����",���ٺ�������,ת��shut��ǩ
        ;���"ִ��������"Ϊ3,������ڴ���"����",���ٺ�������,ת��logoff��ǩ
        ;���"ִ��������"Ϊ4,������ڴ���"����",���ٺ�������,ת��restart��ǩ
        ;���"ִ��������"Ϊ5,������ڴ���"����",���ٺ�������,ת��udef��ǩ
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

          ;���"ִ��������"��Ϊ1-5�е�����һ������,����ʾ���� �����ֶ��޸������ļ��е�task��Ϊ����ֵʱ����
          Else MsgBox,,task error,�����ļ�ָ�������������ô�����ѡ����Ҫִ�е�����

        ;ת���������м��ʱ��,��ǩ����goto,�����ط���ֵ,��ǩ��ת����gosub���ط���ֵ,ת���ı�ǩִ�����return,������ֵ��ת��ǰ�ı�ǩgosub����һ��
        Goto, SetWorkTime
      }
   Return


;���ô���
;�������ɵ���������,��"����",��"����"״̬��ʹ�ÿ�ݼ������ô���,����������.
;������ǰ
;ɾ��ϵͳ�˵��͵���������Ͻǵ�ͼƬ�������Ĳ˵���ͬʱҲɾ���������ϵ���С����󻯰�ť��
;��������

prefs:
Gui, Destroy
Gui, +AlwaysOnTop
Gui, -SysMenu
Gui, Font

;���GroupBox�������ѭ��ʱ��, �������û�ʶ��ʹ�����ø����Ѻ�,��һ�������еĸ��ֹ��ܽ�һ�����з��࣬�ɽ�����ѡ�ť�ؼ��ָ�����
;����ı����� ��ʾ���� ѭ��ʱ��
;��ӱ༭��, �༭���ڵ����ݾ���,  vLoop ǰ��V: Ҫʹһ���ؼ���һ�����������������ĸ V ������ϱ��������ñ�������ȫ�ֱ���
;��������ڱ༭���������ť,��ΧΪ1-99999, ֵΪ%ѭ��ʱ��% ,����������ֵС��1���Զ���Ϊ1,����99999���Զ���Ϊ99999
;��ӵ�ѡ��, ��ʾ����Ϊ t1 ʱ
;��ӵ�ѡ��, ��ʾ����Ϊ t2 ��
;��ӵ�ѡ��, ��ʾ����Ϊ t3 ��
;ѡ��ѡ��,���%iopt%Ϊ1��ѡ��t1,iopt��Ϊ0
Gui, Add, GroupBox, x16 y+5 w320 h100 , ѭ��ʱ��
Gui, Add, Text, x50 y47 w70 h30 Section, ѭ��ʱ��
Gui, Add, Edit, x120 y43 w80 h20 +Center vLoopTime
Gui, add, UpDown, Range1-99999,%LoopTime%
Gui, Add, Radio,x225 y15 w80 h30 vRadioButton, t1 ʱ
Gui, Add, Radio,x225 y40 w80 h30 , t2 ��
Gui, Add, Radio,x225 y65 w80 h30 , t3 ��
GuiControl,, t%iOpt%, % (iOpt <> 0)

;���GroupBox�������ѭ������
;����ı����� ִ�д���
;��ӱ༭��, �༭���ڵ����ݾ���,
;��������ڱ༭���������ť,��ΧΪ1-999, ֵΪ%�ظ�����% ,����������ֵС��1���Զ���Ϊ1,����999���Զ���Ϊ999
;����ı����� ��
Gui, Add, GroupBox, x16 y107 w320 h70 , ѭ������
Gui, Add, Text, x50 y141 w70 h30 , ִ�д���
Gui, Add, Edit, x120 y137 w80 h20  +Center vRepeats
Gui, add, UpDown,Range1-999, %repeats%
Gui, Add, Text, x225 y141 w80 h30 , ��

;���GroupBox���������ʾ����
;����ı�����
;��ӱ༭��, vsdfile, ����Ϊ%�����ļ�%
;����ı�����
;��Ӱ�ť ѡ���ļ�, gSelect:��ĸG������ϱ�ǩ������ʾ�����û������ı�һ���������ű����Զ���ת���������ӹ�����"Select"��ǩ�� &F��ʾ��alt+F��ͬ�ڵ���ð�ť.
Gui, Add, GroupBox, x16 y187 w320 h155 , ��ʾ����
Gui, Add, Text, x26 y207 w290 h20 , ��ʾ����:������������ʾ�����ļ�����·��
Gui, Add, Edit, x26 y227 w290 h40 vSdfile, %soundfile%
Gui, Add, Text, x30 y285 w290 h40 , ������ѡ���ļ�����ť`n�ֶ�ѡ�������ļ�λ��
Gui, Add, Button, x186 y283 w110 h25 gSelectfile, ѡ���ļ�(&F)

;������=����|�ػ�|ע��|����|�û��Զ���
;���GroupBox������������ļ�
;����ı�����
;��������˵�,vTask���ݴ洢������task��, gTaskselect���ݸı���Ӧת��"Taskselect"��ǩ, �����˵�����Ŀ�����涨��� "������"�е���������
;��Ӱ�ť �Զ����ļ�
;����ı����� ����Taskf ֵΪ%����%
;��"����"��ֵѡ����Ϊtask�������˵��е�����,��%����%ֵΪ1,��ѡ�������˵��еĵ�1��,��tasks�ĵ�1��:����
;���"����"=5
;���ı�����taskf����ʾ%�û��ļ�%
tasks = ����|�ػ�|ע��|����|�û��Զ���
Gui, Add, GroupBox, x16 y352 w320 h140 , �����ļ�
Gui, Add, Text, x26 y383 w270 h20 , ������ѡ��Ҫִ�е�����
Gui, Add, DropDownList,x26 y412 w150 h150 AltSubmit vTask gTaskselect, %tasks%
Gui, Add, Button, x186 y412 w110 h24 gUserfile, �Զ����ļ�(&U)
Gui, Add, Text, x26 y452 w305 h30 vTaskf , %task%
GuiControl, Choose, task, %task%
if task=5
Guicontrol,,taskf, %ufile%

;�������
;��Ӱ�ť ����,����Save��ǩ
;��Ӱ�ť ȡ��,����Cancel��ǩ
;������ʾ ��354 ��551 "%�ű���% Preferences
;����ͼ����Ϊ����״̬
;��ͣ���� �����Ǵ����ô���ʱ��ͣ�ű�����,��ͣ��ʱ��
Gui, Font,Bold
Gui, add, Button, x46 y507 w80 h25 Default gSave,����(&S)
Gui, add, Button, x206 y507 w80 h25 gCancel,ȡ��(&C)
Gui,Show,w354 h551,%A_Scriptname% Preferences
Menu, Tray, Icon , %A_ScriptDir%\suspend.ico, IconNumber, 1
Pause, On
Return

;����ѡ��startΪ����
Start:
  Reload
Return

;��ťSave
;�ύ,ȡ������
;
;д��ini�ļ��е�Config�����µ� Loop Time (h||m||s) =����   ��%ѭ��ʱ����%��ֵ
;д��ini�ļ��е�Config�����µ� Audio File (wav) =����   ��%�����ļ�%��ֵ
;д��ini�ļ��е�Config�����µ� Repeats =����   ��%�ظ�����%��ֵ
;д��ini�ļ��е�Option�����µ� Option =����   ��%ʱ�䵥λѡ��%��ֵ
;д��ini�ļ��е�Option�����µ� Task =����   ��%ִ��������%��ֵ
;д��ini�ļ��е�Option�����µ� User define file =����   ��%�û��ļ�%��ֵ

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
;;�رմ���,���ô�������-SysMenu��û����С��󻯺͹رհ�ť,��escҲ�����˳�����,��˴˶��ޱ�Ҫ.
guiescape:
guiclose:
  Gui, Destroy
  Pause, Off
  Menu, Tray, Icon , %A_ScriptDir%\work.ico, IconNumber, 1
Return
*/



;"���ָ�ʽ"����
;_val ��100Ϊ����ֵ�ݽ�
;��_val��ֵ��������ȡ2λ���뵽_cal��,��_val�ĳ�ֵΪ990198,��ֵΪ98
;����_val��ֵ
Format2Digits(_val)
  {
   _val += 10000
   StringRight _val, _val, 4
   Return _val
  }

;ȡ����ť
;ȡ����ͣ
;��ǰ��������
Cancel:
Pause, Off
Gui, Destroy
Sleep, 500
;Menu, Tray, Icon , %A_ScriptDir%\work.ico, IconNumber, 1
;Gosub, StartSession
Return

;ѡ���ļ���ǩ
;Ϊ��һ���ڵ��Ӵ���
;ѡ���ļ�,Ĭ����windows\mediaĿ¼��,�涨�ļ���ʽΪ.wav
;���"�����ļ�"Ϊ��,֪ͨû����Ƶ�ļ�,����ʾ����
;����(����Ϊ��),֪ͨ��ѡ����%�����ļ�%Ϊ��ʾ����
;�ύ
;�ؼ��༭��sdfile����ʾ��ǰѡ���%�����ļ�%
selectfile:
Gui +OwnDialogs
FileSelectFile, Soundfile, 3, %SystemRoot%\Media\, Open a file, Wave Documents (*.wav)
if Soundfile =
    MsgBox, û��ѡ����Ƶ�ļ�������ʾ������
else
    MsgBox, ��ѡ���������ļ�:`n%Soundfile%��Ϊ��ʾ������
Gui, Submit, NoHide
GuiControl,,Sdfile,%Soundfile%
Return

;ѡ���û��Զ����ļ���ǩ:
;Ϊ��һ���ڵ��Ӵ���
;ѡ���ļ�,Ĭ����program filesĿ¼��,�涨�ļ���ʽΪ.exe
;���"�û��ļ�"Ϊ��,֪ͨû��ִ���ļ�,Ĭ��Ϊ����. ͬʱѡ��ؼ������˵��е�����Ϊ��1��Ŀ,������
;����,֪ͨѡ����%�û��ļ�%Ϊִ���ļ�,ͬʱѡ��ؼ������˵��е�����Ϊ��5��Ŀ,���û��Զ���
;�ύ����
;�ؼ�taskf�ı�������ʾ%�û��ļ�%����·��
Userfile:
Gui +OwnDialogs
FileSelectFile, ufile, 3, %ProgramFiles%\, Open a file, Executable file (*.exe)
if ufile =
    {
    MsgBox, û��ѡ��ִ���ļ���Ĭ��Ϊ������
    GuiControl,Choose,task,|1
    }
else
    {
    MsgBox, ��ѡ���������ļ�:`n%ufile%��Ϊִ���ļ���
    GuiControl,Choose,task,|5
    }
Gui, Submit, NoHide
GuiControl,,taskf,%ufile%
Return


;����ѡ���ǩ: ��Ӧ�����˵��е�ÿһ����Ŀ,�ж�ѡ��ͬ����Ŀʱ���еĶ���(��ʱ)
;�����ύ,������
;���"����"=1 , "�û��ļ�"��� ,�ؼ�taskf�ı�������ʾBlkScreen
;���"����"=2 , "�û��ļ�"��� ,�ؼ�taskf�ı�������ʾShutdown
;���"����"=3 , "�û��ļ�"��� ,�ؼ�taskf�ı�������ʾLogoff
;���"����"=4 , "�û��ļ�"��� ,�ؼ�taskf�ı�������ʾRestart
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

;���"����"=5 ,���"�û��ļ�"Ϊ�� ,ת��"�û��Զ����ļ�"��ǩ. ����,�ؼ�taskf�ı�������ʾ%�û��ļ�%����·��,�ؼ�task�����˵�ѡ���5�� "�û��Զ���" (ע��:���ⲻ���� if task=5 gosub,userfile   �������ж�task=5��ֱ����ת��Userfile��ǩ,�����ת��Userfile��,ѡ���û��ļ�,ͬʱѡ��ؼ������˵��е�����Ϊ��5��ĿGuiControl choose task 5,�ͻ�����Taskselect��ǩ,����ѭ��.) ���Դ˴�ֻ�����ж�"�û��ļ�"�Ƿ�Ϊ��,���Ϊ�ղ���ת��Userfile����ѡ���ļ�,�����Ϊ����ֻѡ�������˵��еĵ�5��Ŀ.(��Ҳ��Ϊʲôǰ4������ѡ��ʱһ��Ҫ�����"�û��ļ�"������.��ֹ�ϴ�ѡ���û��ļ����в���,��ʹ��ѡ��5��Ŀ,"�û��ļ�"Ҳ��Ϊ��,��������жϾͻ�ʧЧ.)
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
;���"ִ��������"��Ϊ1-5�е�����һ������,����ʾ���� �����ֶ��޸������ļ��е�task��Ϊ����ֵʱ����
Else
{
MsgBox task error
}
Return

;�ػ���ǩ
;shutdown 13��ʾǿ�ƹػ����رյ�Դ
Shut:
MsgBox, 4,, �Ƿ����ִ�йػ�����`n�㡰�ǡ����Զ�ǿ�ƹػ����������˳�����
IfMsgBox Yes
    Shutdown, 13
else
    ExitApp
return

;ע����ǩ
Logoff:
MsgBox, 4,, �Ƿ����ִ��ע����`n�㡰�ǡ����Զ�ע����ǰ�û����������˳�����
IfMsgBox Yes
    Shutdown, 0
else
    ExitApp
return

;������ǩ
Restart:
MsgBox, 4,, �Ƿ����ִ��������`n�㡰�ǡ����Զ��������������˳�����
IfMsgBox Yes
    Shutdown, 6
else
    ExitApp
return

;�û��Զ���ǩ : ��������ִ��������ĿΪ5ʱ,��ʱ��ֹ,��ת������,ִ��ָ�����ļ�
;���"�û��ļ�"Ϊ��,֪ͨ û��ָ���ļ�
;����,ִ��%�û��ļ�%
Udef:
If ufile=
MsgBox, û��ָ��ִ���ļ���
Else
run , %ufile%
Return

;������ǩ:
Lockworkstation:
Run, %windir%\system32\rundll32.exe user32.dll,LockWorkStation
Return

;������ǩ: ������
;����������ô���,������
;����һ������,������ǰ,�ޱ������������С�رյȰ�ť
;��ɫΪ��
;��ʾ���� ��Ϊ"����"
;����͸����Ϊ150
;ȡ��ǰ���ָ������� �ֱ�������X��Y��
;�����ָ���Ƶ������½�
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

;�˳������ȼ���ǩ: �ȼ�Ϊwin+q
;�������"����"����
;����"����"����
;�ر�"����"����
;���ָ�뻹ԭ���������X��Y�м�¼������λ��
;;������������ô��� ����ж��ޱ�Ҫ
;����
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

;���������ǩ:
;֪ͨ�������
;����%�����ļ�%
;�ر�֪ͨ����
;ת��"����"��ǩ
EndSession:
notify("���","�������", 0,"GC=3b3b3b BC=3b3b3b TC=BCC2C2 MC=silver TS=18 TW=825 TF=Arial MS=16 MW=750 MF=Arial BR=10 GR=10 BT=105 GT=220 IN=1 IW=25 IH=25 BW=0 BF=100",A_ScriptDir "\noti.ico")
Sleep, 100
;��������ļ���Ϊ��, �����ָ��%�����ļ�%������,֪ͨ ���򲥷�ָ�������ļ�
If Soundfile!=
  {
  IfNotExist, %Soundfile%
  MsgBox ,64, ,�����ļ���Ч��������ָ����ָ��Ϊ�ա�
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

;�����ǩ
;����ͼ������Ϊ����״̬
;����������
;���"ʱ��ѡ��"Ϊ1 ������������ʾ��ʾ: %ѭ��ʱ��%Сʱ * %ѭ������%�� ��ִ�������%������%�� ��ǰʣ��ʱ�� %��ʾʱ��% ������� ��ͣģʽ
;���"ʱ��ѡ��"Ϊ2 ������������ʾ��ʾ: %ѭ��ʱ��%���� * %ѭ������%�� ��ִ�������%������%�� ��ǰʣ��ʱ�� %��ʾʱ��% ������� ��ͣģʽ
;���"ʱ��ѡ��"Ϊ3 ������������ʾ��ʾ: %ѭ��ʱ��%�� * %ѭ������%�� ��ִ�������%������%�� ��ǰʣ��ʱ�� %��ʾʱ��% ������� ��ͣģʽ
;��ͣ ����
suspend:
  Menu, Tray, Icon , %A_ScriptDir%\suspend.ico, IconNumber, 1
  Counter = 0
  if iOpt=1
  Menu, tray, Tip, %LoopTime%Сʱ*%Repeats%��`n��ִ������ %counter%��`n��ǰʣ��ʱ��`n%displayedTime%1`n�������`n��ͣģʽ`n`n
  if iOpt=2
  Menu, tray, Tip, %LoopTime%����*%Repeats%��`n��ִ������ %counter%��`n��ǰʣ��ʱ��`n%displayedTime%`n�������`n��ͣģʽ`n`n
  if iOpt=3
  Menu, tray, Tip, %LoopTime%����*%Repeats%��`n��ִ������ %counter%��`n��ǰʣ��ʱ��`n%displayedTime%`n�������`n��ͣģʽ`n`n
  Sleep, 100
  Pause, On
  Return

;F10�������ô���
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




