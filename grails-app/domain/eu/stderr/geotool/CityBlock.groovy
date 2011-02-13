package eu.stderr.geotool

class CityBlock {
    CityLocation cityLocation
    Long start
    Long end
    Long indexGeo

    static belongsTo = CityLocation

    static mapping = {
        version false
    }
    static constraints = {
    }
}
