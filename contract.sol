// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.4.18;


contract Greeting {

    struct hashName{
        string hash;
        string name;
        string filetype;
    }

    mapping(string => address[]) owner;   
    hashName[] ipfshash;

    function addipfshash(string hash,string name) public{
        bytes memory temp=bytes(name);
        bytes memory filetype=new bytes(4);
        filetype[0]=temp[temp.length-4];
        filetype[1]=temp[temp.length-3];
        filetype[2]=temp[temp.length-2];
        filetype[3]=temp[temp.length-1];
        
        require(bytes(hash).length==46 && owner[hash].length==0  );
        
        bytes memory Name=new bytes(temp.length-4);
        for(uint j=0;j<temp.length-4;j++)
        {
            Name[j]=temp[j];
        }
        
        var owneraddrs= owner[hash];
        owneraddrs.push(msg.sender);
        ipfshash.push(hashName(hash,name,string(filetype)));
    }
    
    function getipfsnum() view public returns (uint256){
        return ipfshash.length;
    }
  
    function isSubstr(string str,string substr) pure private returns (bool){
        bytes memory Str=bytes(str);
        bytes memory SubStr=bytes(substr);
        if(SubStr.length==0)
            return false;
       uint j=0;
       for(uint i=0;i<Str.length-SubStr.length+1;i++)
       {
           
           for( j=0;j<SubStr.length;j++)
           {
                if(Str[i+j]!=SubStr[j])
                    break;
           }
           if(j==SubStr.length)
                return true;
       }
        return false;
    }
    
    function getipfshash(uint j) view public returns (string){
        return ipfshash[j].hash;
    } 
    
    function getipfshashname(uint j) view public returns (string){
        return ipfshash[j].name;
    } 
  
    function getipfshashs(string subname,uint maxlen) view public returns (string Hashs,uint Num,string FileTypes ){
        uint i=0;
        uint j=0;
        bytes memory temp1;
        bytes memory temp;
        bytes memory hashs=new bytes(maxlen*46);
        uint num=0;
        bytes memory filetypes=new bytes(maxlen*4);
       
        while(i<ipfshash.length && num<maxlen )
        {
            
            if(isSubstr(ipfshash[i].name,subname))
            {
                j=0;
                var owners=owner[ipfshash[i].hash];
                while(j<owners.length)
                {
                    if(owners[j]==msg.sender)
                        break;
                    j++;
                }
                if(j<owners.length)
                {
                    temp1=bytes(ipfshash[i].hash);
                    temp=bytes(ipfshash[i].filetype);
                    for(uint k=0;k<46;k++)
                    {
                        hashs[num*46+k]=temp1[k];
                    }
                    for(k=0;k<4;k++)
                    {
                        filetypes[num*4+k]=temp[k];
                    }
                    num++;
                }
            }
            i++;
        }
        
        return (string(hashs),num,string(filetypes));
    }
    
    
   function addOwner(string hash,address newOwner) public {
       uint i=0;
       var owners=owner[hash];
       bool isgood;
       for(i=0;i<owners.length;i++)
       {
           if(owners[i]==msg.sender)
                break;
       }
       isgood=(i<owners.length);
       require(isgood);
       owners.push(newOwner);
   }
  
  
    function removeSelf(string hash) public{
        uint i=0;
        var owners=owner[hash];
        bool isgood;
        for(i=0;i<owners.length;i++)
        {
            if(owners[i]==msg.sender)
                break;
        }
        isgood=(i<owners.length);
        require(isgood);
        owners[i]=owners[owners.length-1];
        delete owners[owners.length-1];
    }
}