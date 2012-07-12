//ATM Controller.lsl
//Controls the ATM systems main functions.
//Made by Nathan
list options;
integer inuse;
integer listenhdl;
integer withdrwhdl;
key user;
default
{
  state_entry()
    {
        llRequestPermissions(llGetOwner(),PERMISSION_DEBIT);
        llOwnerSay("Requesting debit permissions... You have 5 seconds to accept");
        state running;
    }
}
    state running
    {
        state_entry()
        {
            llListen(30,"","","");

        }
        touch_start(integer total_number)
        {
            if (!inuse)
            {
                user = llDetectedKey(0);
                inuse = TRUE;
                options = ["Withdraw","Deposit","About","Help"];
                llInstantMessage(llDetectedKey(0),"Welcome to Genesis ATM...");
                llDialog(llDetectedKey(0),"How may we help you?",options,30);
                listenhdl = llListen(30,"",llDetectedKey(0),"");
                llSetTimerEvent(60);
            }
            else if ((inuse) && (llDetectedKey(0) != user))
            {
                llInstantMessage(llDetectedKey(0),"ATM Already in use... Please try again later...");
            }
            else if ((inuse) && (llDetectedKey(0) == user))
            {
                llInstantMessage(llDetectedKey(0),"Redrawing menu...");
                llDialog(llDetectedKey(0),"How may we help you?",options,30);
                
            }
        }
        listen(integer chan,string name,key id,string msg)
        {
            if (msg == "Withdraw")
            {
                llInstantMessage(id,"How much would you like?");
                withdrwhdl = llListen(20,"",id,"");
            }
            else if (chan == 20)
            {
                llGiveMoney(id,(integer)msg);
                llInstantMessage(id,"Thanks for using this ATM.");
                llListenRemove(listenhdl);
                llListenRemove(withdrwhdl);
                inuse = FALSE;
            }

        }
        timer()
        {
            llListenRemove(listenhdl);
            llSay(0,"ATM timed out... Please try again.");
        }
    }