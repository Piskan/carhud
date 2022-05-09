


window.addEventListener('message', function(e) {
   if (e.data.message == "arachud") {
	 if (event.data.hudaktif) {
     $( "#mybody" ).fadeIn( 200, function() {
       // Animation complete.
      });
	 } else {
		$( "#mybody" ).fadeOut( 200, function() {
       // Animation complete.
      });
	 }
	
  
   }
   
   
   if (e.data.message == "kemertetikle") {
	 if (event.data.KemerAktif){
		document.getElementById("kemer").style.color = "#ffce00";
	 }else{
		 document.getElementById("kemer").style.color = "white";
	 }
	
  
   }
  
    if (e.data.message == "aracupdate") {

    
   	  var val = Number(event.data.arachiz * 1.70);

      var hiz = document.querySelector("#atess2");
      var hiz2 = document.querySelector("#atess");
      hiz.setAttribute("stroke-dasharray", val + "," + 943);
       hiz2.setAttribute("stroke-dasharray", val + "," + 943);
  
	  if (event.data.aracrpm.toFixed(2) == 0.20){
		 var val1 = 0;
	  }else{
		   var val1 = Number(Number(event.data.aracrpm.toFixed(2)) * 440);
	  }
	

      var rpm = document.querySelector("#icibre");
    
      rpm.setAttribute("stroke-dasharray", val1 + "," + 943);
	  
	  
	  document.getElementById("rpmtext").innerHTML = event.data.aracrpm.toFixed(2)+ ' rpm';
	   
	   
	    if (event.data.aracbenzin > 50 && event.data.aracbenzin < 100){
		document.getElementById("ustpompa100").style.display = "block";
		document.getElementById("ustpompa50").style.display = "none";
		 document.getElementById("ustpompa30").style.display = "none";
	  }else if (event.data.aracbenzin > 30 && event.data.aracbenzin < 50){
		 document.getElementById("ustpompa50").style.display = "block";
		 document.getElementById("ustpompa30").style.display = "none";
		 document.getElementById("ustpompa100").style.display = "none";
	  }else if ( event.data.aracbenzin < 30){
	document.getElementById("ustpompa30").style.display = "block";
		   document.getElementById("ustpompa100").style.display = "none";
		   	document.getElementById("ustpompa50").style.display = "none";
	  }
	  
	  if (event.data.arachiz >= 100){
		document.getElementById("kmtext").innerHTML = event.data.arachiz;
		
	  }else if (event.data.arachiz < 10){
		  document.getElementById("kmtext").innerHTML = '0'+'0'+ event.data.arachiz;	
	  }else {
		document.getElementById("kmtext").innerHTML = '0'+ event.data.arachiz;	
		  
	  }

    }
	
	if (e.data.message == "sokakinfo"){
	document.getElementById("adresbilgisi").innerHTML = event.data.sokakisim;
	  document.getElementById("adresyon").innerHTML = event.data.sokakyon;
	}
  

})




