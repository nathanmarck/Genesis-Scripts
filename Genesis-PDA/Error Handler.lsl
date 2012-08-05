default
{
    state_entry()
    {
        llOwnerSay("Debug Mode Enabled...");
    }
    link_message(integer sender_num,integer num,string str,key id)
    {
        if((str == "licenserror") && (id == "error"))
        {
            llOwnerSay("License Error detected. Attempting to fix...");
            osMakeNotecard("Settings","test license \n on");
        }
        else
        {
        
        }
    }
}
