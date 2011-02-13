package eu.stderr.geotool

class CityLocation {
    Country country
    String region
    String city
    String postalCode
    Float latitude
    Float longitude
    Integer metroCode
    Integer areaCode

    static belongsTo = Country
    static hasMany = [cityBlocks:CityBlock]

    static mapping = {
        version false
    }

    static constraints = {
    }
}
