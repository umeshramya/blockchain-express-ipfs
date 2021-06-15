var axios=require("axios");

var space=document.getElementById("images");
var inputname=document.getElementById("name");
document.getElementById("search").addEventListener("click",async ()=>{
    const result = await axios.get("/gethashs?name="+inputname.value).then(res=>res);
    while (space.hasChildNodes()) {  
        space.removeChild(list.firstChild);
    }
    for(let i=0;i<result.data.hashs.length;i++)
    {
        let img=document.createElement("img");
        img.src="/getthefile?hash="+result.data.hashs[i];
        img.style="width: 100%;";
        space.appendChild(img);
    }              
})  