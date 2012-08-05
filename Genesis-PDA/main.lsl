initilize1()
{
    
}
integer licensewait;
key data;
default
{
    state_entry()
    {
        llOwnerSay("Loading Internal Systems...");
        licensewait = TRUE;
        llSetScriptState("license checker.lsl",TRUE);
        llResetOtherScript("license checker.lsl");
        data = llGetNotecardLine("Settings",1 );

    } 
    touch_start(integer num)
    {
        if(llDetectedLinkNumber(0) == 5)
        {
            llOwnerSay("Implment Off functions here");
        }
    }
    link_message(integer sender_num, integer num, string msg, key id)
    {
        if((msg == "licenseconfirm") && (licensewait == TRUE))
        {
            initilize1();
            licensewait = FALSE;
            llSetScriptState("license checker.lsl",FALSE);
                            llSetScriptState("dialogs.lsl",TRUE);
                llOwnerSay("Genesis PDA OS loaded...");
        }
        else 
        {
            llOwnerSay("Some sort of error occured checking your license...");
            llSetScriptState("dialogs.lsl",FALSE);
            llOwnerSay("Disabling Genesis PDA OS");
        }
    }
     dataserver(key queryid,string setting)
     {
         if(setting == "on") 
         {
                llSetScriptState("error handler.lsl",TRUE);
                llResetOtherScript("error handler.lsl");
         }

         else if(setting == "off")
         {
             llSetScriptState("error handler.lsl",FALSE);
         }
        
     }
     changed(integer change)
     { 
        if (change & CHANGED_INVENTORY)
        {
            llResetScript();
        }
    }
}
