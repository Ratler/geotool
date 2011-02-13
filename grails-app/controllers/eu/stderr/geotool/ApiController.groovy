package eu.stderr.geotool

class ApiController {

    def index = {
        redirect(action: "country", params: params)
    }

    def country = {
        def ip = params.id ? params.id : request.getRemoteAddr()
        if(isValidIp(ip)) {
            long aton = getAtonFromIp(ip)
            def geoCountryInstance = Ip.findAll("FROM Ip as t1 WHERE ? BETWEEN t1.start AND t1.end", [aton])

            if(geoCountryInstance) {
                render(view: "country.xml", contentType: "text/xml", encoding: "UTF-8", model: [status:"OK", ip:ip, geoCountryInstance: geoCountryInstance?.first()])
            } else {
                render(view: "response.xml.error", contentType: "text/xml", encoding: "UTF-8", model: [status:"IP NOT FOUND IN DATABASE, SORRY!", ip:ip])
            }
        } else {
            render(view: "response.xml.error", contentType: "text/xml", encoding: "UTF-8", model: [status:"IP IS NOT VALID!", ip:ip])
        }
    }

    def city = {
        def ip = params.id ? params.id : request.getRemoteAddr()
        if(isValidIp(ip)) {
            long aton = getAtonFromIp(ip)
            long geo = aton - (aton % 65536)
            def geoCityInstance = CityBlock.findAll("FROM CityBlock as t1 WHERE t1.indexGeo = ? AND ? BETWEEN t1.start AND t1.end", [geo, aton])
            if(geoCityInstance) {
                render(view: "city.xml", contentType: "text/xml", encoding: "UTF-8", model: [status:"OK", ip:ip, geoCityInstance:geoCityInstance?.first().cityLocation])
            } else {
                render(view: "response.xml.error", contentType: "text/xml", encoding: "UTF-8", model: [status:"IP NOT FOUND IN DATABASE, SORRY!", ip:ip])
            }
        } else {
            render(view: "response.xml.error", contentType: "text/xml", encoding: "UTF-8", model: [status:"IP IS NOT VALID!", ip:ip])
        }
    }

    private boolean isValidIp(String ip) {
        if (ip.matches("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}")) {
            return true
        }
        return false
    }

    private long getAtonFromIp(String ip) {
        def ipArray = ip.split("\\.")
        long aton = ipArray[0].toLong() * 16777216
        aton += ipArray[1].toLong() * 65536
        aton += ipArray[2].toLong() * 256
        aton += ipArray[3].toLong()

        return aton
    }
}
