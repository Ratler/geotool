package eu.stderr.geotool

class Ip {
    Long start
    Long end
    Country country

    static mapping = {
        start sqlType: 'INT(10) UNSIGNED'
        end sqlType:'INT(10) UNSIGNED'
    }

    static belongsTo = Country

    static constraints = {
        start(blank: false)
        end(blank: false)
        country(blank: false)
    }
}
