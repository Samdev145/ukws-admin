import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    postCode: String
  }

  connect() {
    if (typeof (google) != "undefined"){
      this.initializeMap()
    }
  }

  initializeMap() {
    this.map = this.map()
    this.addMarker()
  }

  map() {
    if(this._map == undefined) {
      const myLatLng = { lat: 48.3268, lng: 18.0791 };

      this._map = new google.maps.Map(document.getElementById("map"), {
        center: myLatLng,
        zoom: 12
      })
    }

    return this._map
  }

  addMarker() {
    const map = this.map
    const geocoder = new google.maps.Geocoder()

    const address = this.postCodeValue

    geocoder.geocode( { 'address': address}, (results, status) => {
      if (status == 'OK') {

        map.setCenter(results[0].geometry.location);

        new google.maps.Marker({
            map: map,
            position: results[0].geometry.location
        });
      } else {
        alert('Geocode was not successful for the following reason: ' + status);
      }
    });
  }
}
