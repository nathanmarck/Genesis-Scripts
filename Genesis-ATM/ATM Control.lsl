//ATM Controller.lsl
//Controls the ATM systems main functions.
//Made by Nathan
list options;
integer inuse;
integer listenhdl;
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
                inuse = TRUE;
                options = ["Withdraw","Deposit","About","Help"];
                llInstantMessage(llDetectedKey(0),"Welcome to Genesis ATM...");
                llDialog(llDetectedKey(0),"How may we help you?",options,30);
                listenhdl = llListen(30,"",llDetectedKey(0),"");
            }
            else if ((inuse) && (llDetectedKey(0) != user))
            {
                llInstantMessage(llDetectedKey(0),"ATM Already in use... Please try again later...");
            }
        }
        listen(integer chan,string name,key id,string msg)
        {
            if (msg == "Withdraw")
            {
                llInstantMessage(id,"How much would you like?");
            }
            else if (chan == 20)
            {
                llGiveMoney(id,(integer)msg);
                llInstantMessage(id,"Thanks for using this ATM.");
                llListenRemove(listenhdl);
                inuse = FALSE;
            }

        }
    }