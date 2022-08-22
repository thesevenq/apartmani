currentIndex = 0
datica = null
const resourceName = 'rev-apartmani'


window.addEventListener('message', function(event) {
  let data = event.data
  datica = data

  if (data.action == "open") {
    $("#container").fadeIn("")
    $("#lista-container").html('')
    kreirajListu(datica.apartmani)


  } else if (data.action == "close") {
    $("#container").fadeOut("")
    $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}));
  }
});

document.onkeyup = function (data) {
    if (data.which == 27) {
      $("#container").fadeOut("")
      $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}));
    }

  };
//  ============= FUNKCIJE ZA BUTTONE =============
function kupiApartman() {
  console.log('doslo?')
  $.post('https://' + resourceName + '/kupiApartman', JSON.stringify({
      ime : vozilaData[currentIndex].ime, cijena : vozilaData[currentIndex].cijena
  }))
  zatvori()
  console.log('zavrsilo')
}

function setapajInformacije(tabela) {
  $("#informacije").html('')
  $(".pic-container").html(`  <img id="center" src="` + vozilaData[currentIndex].slikaBez + `" class="mx-auto">`)
  $("#informacije").append(`
  <p id="imeapartmana">` + vozilaData[currentIndex].label + `</p>
  <hr style="width:80%;text-align:center;margin-left:9%; margin-top: 2%;">
  <p id="storagesize"> KAPACITET SEFA </p>
  <p id="storage"> 1000 KG </p>
  <hr style="width:80%;text-align:center;margin-left:9%; margin-top: 2%;">
  <p id="nadogradnjah"> MOGUCE NADOGRADITI? </p>
  <p id="nadogradnja"> Potpuna nadogradnja! </p>
  <hr style="width:80%;text-align:center;margin-left:9%; margin-top: 2%;">
  <p id="cijenah"> CIJENA OBJEKTA: </p>
  <p id="cijena">` + '$' + vozilaData[currentIndex].cijena + `</p>
    <div id="kupi" onClick="kupiApartman()"> <i class="fas fa-shopping-cart"></i> KUPITE APARTMAN </div>
  `)
}
function kreirajListu(vehicleList) {
  $.each(vehicleList, function(k,v) {
    if (typeof v.slika !== 'undefined') {
        $("#lista-container").append(`
          <div class="row"">
                <div class="col-12 lista-karta my-2"<i id="btn-`+ k +`"></i>
                <div class="col-2 pic-slot d-flex align-items-center"><img class="mx-2" src="`+ v.slika +`" style="width: 90%;"></div>
                <div class="col-2 d-flex align-items-center" style="text-align: center;"><span class="">` + v.label +`</span></div>
                <div class="col-6 d-flex align-items-center" style="text-align: center; color: lightgray; font-size: 13px;"><span>`+ v.cijena +`$</span></div> 
                </div>
                
            </div>
        `);
        $("#btn-" + k).click(function() {
          currentIndex = k
          vozilaData = vehicleList
          setapajInformacije(vehicleList)
      });
    }
});
}

function zatvori() {
  $("#container").hide("slow")
  $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}));

}

