//ATM Controller.lsl
//Controls the ATM systems main functions.
//Made by Nathan
list options;
integer inuse;
integer listenhdl;
integer withdrwhdl;
key user;
string url = "http://127.0.0.1/data.php";  
string secret = "Luc1s4w3s0m3";
string separator = "|";
string ammount = "1000";
list crntammount;
string crntammount2;
key put_id;
key get_id;
key del_id;
string body;
integer wdrawn;
integer depo;
PutData(key id, list fields, list values, integer verbose)
{
    string args;
    args += "?key="+llEscapeURL(id)+"&action=put&separator="+llEscapeURL(separator);
    args += "&fields="+llEscapeURL(llDumpList2String(fields,separator));
    args += "&values="+llEscapeURL(llDumpList2String(values,separator));
    args += "&secret="+llEscapeURL(secret);
    put_id = llHTTPRequest(url+args,[HTTP_METHOD,"GET",HTTP_MIMETYPE,"application/x-www-form-urlencoded"],"");
}
GetData(key id, list fields, integer verbose)
{
    string args;
    args += "?key="+llEscapeURL(id)+"&action=get&separator="+llEscapeURL(separator);
    args += "&fields="+llEscapeURL(llDumpList2String(fields,separator))+"&verbose="+(string)verbose;
    args += "&secret="+llEscapeURL(secret);
    get_id = llHTTPRequest(url+args,[HTTP_METHOD,"GET",HTTP_MIMETYPE,"application/x-www-form-urlencoded"],"");



}
PostData(string input)
{
   crntammount = llParseString2List(input,["ammount|"], [] ); 
   crntammount2 = llDumpList2String(crntammount,"");
}
DelData(key id, list fields, integer verbose)
{
    string args;
    args += "?key="+llEscapeURL(id)+"&action=del&separator="+llEscapeURL(separator);
    args += "&fields="+llEscapeURL(llDumpList2String(fields,separator))+"&verbose="+(string)verbose;
    args += "&secret="+llEscapeURL(secret);
    del_id = llHTTPRequest(url+args,[HTTP_METHOD,"GET",HTTP_MIMETYPE,"application/x-www-form-urlencoded"],"");
}

default
{
  state_entry()
    {
        llRequestPermissions(llGetOwner(),PERMISSION_DEBIT);
        llOwnerSay("Requesting debit permissions...");
        state running;
    }
}
    state running
    {
        state_entry()
        {
            

        }
        touch_start(integer total_number)
        {
            if (!inuse)
            {
                user = llDetectedKey(0);
                inuse = TRUE;
                options = ["Withdraw","Deposit","Balance","Register"];
                llInstantMessage(llDetectedKey(0),"Welcome to Genesis ATM...");
                llDialog(llDetectedKey(0),"How may we help you?",options,30);
                listenhdl = llListen(30,"","","");
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
        listen(integer chan,string name,key lid,string msg)
        {
            if (msg == "Deposit")
            {
                llInstantMessage(lid,"Please pay the ATM in order to deposit money.");
inuse = FALSE;
}
           else if (msg == "Withdraw")
            {
               GetData(lid,["ammount"],TRUE);
               withdrwhdl = llListen(20,"","","");
               llSleep(1);
                llInstantMessage(lid,"How much would you like? You currently have £" + (string)crntammount2 + "You must use channel 20 to communicate with the ATM");

            }
             if (msg == "Balance")
            {
               GetData(lid,["ammount"],TRUE);
               llSleep(1);
                llInstantMessage(lid,"You currently have £" + (string)crntammount2);
llSetTimerEvent(0);
inuse = FALSE;

            }
            else if ((chan == 20) && ((integer)msg < (integer)crntammount2))
            {
                llGiveMoney(lid,(integer)msg);
                wdrawn = (integer)crntammount2 - (integer)msg;
                PutData(lid,["ammount"],[wdrawn],FALSE);
                llInstantMessage(lid,"Thanks for using this ATM.");
                llListenRemove(listenhdl);
                llListenRemove(withdrwhdl);
                llSetTimerEvent(0);
                inuse = FALSE;
            }
            else if (msg == "Register")
            {
                PutData(lid,["ammount"],[ammount],FALSE);
                llInstantMessage(lid,"Thanks for registering... Your current balance is £1000");
            }

        }
        timer()
        {
            llListenRemove(listenhdl);
            inuse = FALSE;
            llSay(0,"ATM timed out... Please try again.");
            llSetTimerEvent(0);
        }
        http_response(key id, integer status, list metadata, string body)
    {
        // In this example, we're simply spitting back the data we've gotten from the server as an llOwnerSay.
        
        // First, make sure this request is one of the ones used in this script (as opposed to one being called
        // by another script in the same object).
        
        if((id != put_id) && (id != get_id) && (id != del_id)) return;
        
        // If the status isn't 200, then there was a problem connecting to your server.  Maybe the URL isn't
        // correct, or the server is offline.  Set the body to the server error so the final result is an
        // accurate account of what happened.
        if(status != 200) body = "ERROR: CANNOT CONNECT TO SERVER";
   
PostData(body);
    }
    money(key giver, integer amount) 
    {
    GetData(giver,["ammount"],TRUE);
    llInstantMessage(giver,"Proccesssing.....");
    llSleep(1);
    depo = (integer)crntammount2 + (integer)amount;
                PutData(giver,["ammount"],[depo],FALSE);
                llInstantMessage(giver,"Thanks for using this ATM. You now have £" + depo);
              
                inuse = FALSE;
    }
    }