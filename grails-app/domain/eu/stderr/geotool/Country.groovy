package eu.stderr.geotool

class Country {
    String countryCode
    String countryName

    static hasMany = [ips: Ip, cityLocations: CityLocation]

    static constraints = {
        countryCode(size: 2..2)
        countryName(size: 1..50)
    }
}
