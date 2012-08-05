key data;
default
{
    state_entry()
     {
      //osMakeNotecard("License Key","adminlicense");
     llOwnerSay("Loading License Key...");
     data = llGetNotecardLine("Settings",0 );
     }
    dataserver(key queryid,string license)
    {
        if (queryid == data)
        {
            if (license == "test license")
            {
                llOwnerSay("License correct.. Initializing...");
                llMessageLinked(LINK_SET,0,"licenseconfirm","");
            }
            else 
            {
                llOwnerSay("License not found or incorrect... Ending...");
                llMessageLinked(LINK_SET,0,"licenserror","error");
            }
        }
        else 
        {
            llMessageLinked(LINK_SET,0,"licenseerror","error");
        }
    }
}
