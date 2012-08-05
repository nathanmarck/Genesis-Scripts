//This is an auto-generated script created by Dialog Generator
//Available at http://ugleh.com/llDialog.php
integer channel;
list menu = ["Connect to ICSNet","System Features","System Configuration","System Link","Server link"];
string message = "Welcome to the Genesis PDA OS. What would you like to do?";

default
{
    state_entry()
    {
     channel = (integer)("0x"+llGetSubString((string)llGetKey(),-8,-1));
        llListen(channel,"", "","");
    }
 
    touch_start(integer count)
    {
    if (llDetectedKey(0) == llGetOwner()){
    llDialog(llGetOwner(), message, menu, channel);
                 }
    }
 
    listen(integer chan, string name, key id, string mes)
    {
if (mes =="Connect to ICSNet"){
//Do something for option Connect to ICSNet

}
else if (mes =="System Features"){
//Do something for option System Features

}
else if (mes =="System Configuration"){
//Do something for option System Configuration

}
else if (mes =="System Link"){
//Do something for option System Link

}
else if (mes =="Server link"){
//Do something for option Server link

}

    }
}

