    //   var currShow = false;
    // window.addEventListener('message', function (e) {
    //     var isShow = e.data.isShow,
    //     speed = e.data.speed,
    //     beltOn = e.data.beltOn,
    //     hasBelt = e.data.hasBelt,
    //     aracisik = e.data.vehiclelight,
    //     aracmotor = e.data.engineStatus,
    //     hasCruise = e.data.hasCruise,
    //     cruiseStatus = e.data.cruiseStatus,
    //     isHide = e.data.isHide;
    //     if(isShow == true && isHide == false) {
    //         this.document.getElementById('speedometer').style.animation = "";
    //         this.document.getElementById('speedometer').style.display = "block";
    //         // this.document.getElementById('hellobitch').style.strokeDashoffset = speed ;
    //         this.document.getElementById('linecont').style.transform = "rotate(" + speed + "deg)";
    //         this.document.getElementById('muhittin').innerHTML = speed;
           
    //         if(currShow == false) {
    //             currShow = true;
               
               
    //         }

    //         if(beltOn && hasBelt) {
    //             this.document.getElementById('nevarlan').style.fill = "green";
    //         } else if(!beltOn && hasBelt) {
    //             this.document.getElementById('nevarlan').style.fill = "rgba(255, 255, 255, 0.5)";
    //         }
    //         if(cruiseStatus && hasCruise) {
    //             this.document.getElementById('cruise').style.background = "#1275b7";
    //         } else if(!cruiseStatus && hasCruise) {
    //             this.document.getElementById('cruise').style.background = "rgba(255, 255, 255, 0.5)";
    //         }
    //         if(aracisik == 'high') {
    //             this.document.getElementById('nevartirrek').style.fill = "#1275b7";
    //         } else if(aracisik == 'normal') {
    //             this.document.getElementById('nevartirrek').style.fill = "green";
    //         } else if(aracisik == 'off') {
    //             this.document.getElementById('nevartirrek').style.fill = "rgba(255, 255, 255, 0.5)";
    //         }
    //         if(aracmotor) {
    //             this.document.getElementById('nevartirrek2').style.fill = "green";
    //         } else {
    //             this.document.getElementById('nevartirrek2').style.fill = "rgba(255, 255, 255, 0.5)";
    //         }
    //     } else {
    //         if (currShow == true) {
    //             currShow = false;
    //             this.document.getElementById('speedometer').style.animation = "fadeOutDown .5s forwards";
    //             setTimeout(() => {
    //                 this.document.getElementById('speedometer').style.display = "";
    //             }, 500);
    //         }
    //     }
    // })

    (() => {
        PRHud = {};
    
       
        
    
        PRHud.ToggleSeatbelt = function(data) {
            if (data.seatbelt) {
                document.getElementById('nevarlan').style.fill = "green";
            } else {
                document.getElementById('nevarlan').style.fill = "rgba(255, 255, 255, 0.5)";
        
            }
        };
        PRHud.ToggleCruise = function(data) {
            if (data.cruise) {
                document.getElementById('cruise').style.background = "#1275b7";
            } else {
                document.getElementById('cruise').style.background = "rgba(255, 255, 255, 0.5)";
        
            }
        };
    
 
    
        PRHud.CarHud = function(data) {
            if (data.show) {
                document.getElementById('speedometer').style.animation = "";
                document.getElementById('speedometer').style.display = "block";
            } else {
                document.getElementById('speedometer').style.animation = "fadeOutDown .5s forwards";
                setTimeout(() => {
                    document.getElementById('speedometer').style.display = "";
                }, 500);
            }
        };
    
        PRHud.UpdateHud = function(data) {
            var Show = "block";
            if (data.show) {
                Show = "none";
                $(".ui-container").css("display", Show);
                return;
            }
            $(".ui-container").css("display", Show);
    
            
          
            // console.log(data.speed)
          
          if (data.speed >= 220) {
           document.getElementById('linecont').style.transform = "rotate(" + 220 + "deg)";
         
          } else {

           document.getElementById('linecont').style.transform = "rotate(" + data.speed + "deg)";

          }
    
         
        //    document.getElementById('linecont').style.transform = "rotate(" + yenihız + "deg)";
            document.getElementById('muhittin').innerHTML = data.speed;

            if (data.aracdurum < 600) {
                document.getElementById('araciptal').style.color = "#921512";
            } else if (data.aracdurum < 800) {
                document.getElementById('araciptal').style.color = "#c7b212";
            } else {
                document.getElementById('araciptal').style.color = "rgba(255, 255, 255, 0.5)";
            }

            function setCircleTo(target, percent)
{  
    var path = target.find('.line').get(0);
    var pathLen = path.getTotalLength();
    var adjustedLen = percent * pathLen / 100;
    path.setAttribute('stroke-dasharray', adjustedLen+' '+pathLen);
}

function setStartTo(target, percent)
{  
    var path = target.find('.line2').get(0);
    var pathLen = path.getTotalLength();
    var adjustedLen = percent * pathLen / 100;
    path.setAttribute('stroke-dasharray', adjustedLen+' '+pathLen);
}

//Fuel End Dot & Needle
function setLevelTo(target, percent)
{  
    var needle = target.find('.needle').get(0);
    var endDot = target.find('.fuel_end').get(0);
    var rotation = percent * 180 / 100;
    needle.setAttribute('transform', 'rotate('+rotation+', 81.3, 58.1)');
    endDot.setAttribute('transform', 'rotate('+rotation+', 81.3, 58.1)');
}

//Fuel Start
function setStartLevelTo(target, percent)
{
    var startDot = target.find('.fuel_start').get(0);
    var rotation = percent * 180 / 100;
    startDot.setAttribute('transform', 'rotate('+rotation+', 81.3, 58.1)');
}

function setGauge(target, fuelStart, fuelEnd){
  setCircleTo(target, fuelEnd);
  setStartTo(target, fuelStart);
  setLevelTo(target, fuelEnd);
  setStartLevelTo(target, fuelStart);
}

//Initialize Gauge Function
setGauge($('#gauge-id'),100,data.aracbenzin);
            if(data.aracisik == 'high') {
                document.getElementById('nevartirrek').style.fill = "#1275b7";
                } else if(data.aracisik == 'normal') {
                  document.getElementById('nevartirrek').style.fill = "green";
                 } else if(data.aracisik == 'off') {
             document.getElementById('nevartirrek').style.fill = "rgba(255, 255, 255, 0.5)";
           }
            if (data.engine) {
                document.getElementById('nevartirrek2').style.fill = "green";
          
            } else {
                document.getElementById('nevartirrek2').style.fill = "rgba(255, 255, 255, 0.5)";
            }
        };
    
     
    
     
    
        // PRHud.Update = function(data) {
           

        //     $("body").css("display", data.show ? "block" : "none");
        //     $("#boxSetHealth").css("width", data.health + "%");
        //     $("#boxSetArmour").css("width", data.armour + "%");
        //     $("#boxSetHealth").css("width", data.health + "%");
        //     $("#boxSetArmour").css("width", data.armour + "%");
        //     widthHeightSplit(data.hunger, $("#boxSetHunger"));
        //     widthHeightSplit(data.thirst, $("#boxSetThirst"));
        //     widthHeightSplit(data.oxygen, $("#boxSetOxygen"));
        //     widthHeightSplit(data.stress, $("#boxSetStress"));
    
        // };

        // function widthHeightSplit(value, ele) {
        //     let height = 30;
        //     let eleHeight = (value / 100) * height;
        //     let leftOverHeight = height - eleHeight;
        
        //     ele.css("height", eleHeight + "px");
        //     ele.css("top", leftOverHeight + "px");
        // };
    
     
  
        window.onload = function(e) {
            window.addEventListener('message', function(event) {
                switch(event.data.action) {
                    case "open":
                        PRHud.Open(event.data);
                        break;
                    case "close":
                        PRHud.Close();
                        break;
                    // case "update":
                    //     PRHud.Update(event.data);
                    //     break;
                    case "show":
                        PRHud.Show(event.data);
                        break;
                    case "hudtick":
                        PRHud.UpdateHud(event.data);
                        break;
                    case "car":
                        PRHud.CarHud(event.data);
                        break;
                    case "cruise":
                        PRHud.ToggleCruise(event.data);
                        break;
                    case "seatbelt":
                        PRHud.ToggleSeatbelt(event.data);
              
                    
                      
    
                }
            })
        }
    
    })();


