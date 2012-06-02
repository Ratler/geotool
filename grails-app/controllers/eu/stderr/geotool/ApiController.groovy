package eu.stderr.geotool

import groovy.sql.Sql

class ApiController {

    def dataSource

    def index = {
        redirect(action: "country", params: params)
    }

    def country = {
        def ip = params.id ? params.id : request.getRemoteAddr()
        if(isValidIpv4(ip)) {
            long aton = aton(ip)

            Sql sql = new Sql(dataSource)
            def geoCountryInstance = sql.rows("SELECT * FROM ip t1 JOIN country t2 ON t1.country_id = t2.id WHERE MBRCONTAINS(t1.polygon, POINTFROMWKB(POINT(?, 0)))", [aton])

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
        if(isValidIpv4(ip)) {
            long aton = aton(ip)
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

    def asn = {
        def ip = params.id ? params.id : request.getRemoteAddr()
        if (isValidIpv4(ip)) {
            long aton = aton(ip)

            Sql sql = new Sql(dataSource)
            def geoAsnIPV4 = sql.rows("SELECT * FROM asn_ipv4 t1 WHERE MBRCONTAINS(t1.polygon, POINTFROMWKB(POINT(?, 0)))", [aton])
            if(geoAsnIPV4) {
                geoAsnIPV4 = geoAsnIPV4.first()
                def iprange = ntoa(geoAsnIPV4.start) + " - " + ntoa(geoAsnIPV4.end)
                render(view: "asn.xml", contentType: "text/xml", encoding: "UTF-8", model: [status:"OK", ip:ip, iprange:iprange, asn:geoAsnIPV4.asn, company:geoAsnIPV4.owner])
            } else {
                render(view: "response.xml.error", contentType: "text/xml", encoding: "UTF-8", model: [status:"IP NOT FOUND IN DATABASE, SORRY!", ip:ip])
            }
        } else {
            render(view: "response.xml.error", contentType: "text/xml", encoding: "UTF-8", model: [status:"IP IS NOT VALID!", ip:ip])
        }
    }

    private boolean isValidIpv4(String ip) {
        if (ip.matches("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}")) {
            return true
        }
        return false
    }

    private long aton(String ip) {
        def ipArray = ip.split("\\.")
        long aton = ipArray[0].toLong() * 16777216
        aton += ipArray[1].toLong() * 65536
        aton += ipArray[2].toLong() * 256
        aton += ipArray[3].toLong()

        return aton
    }

    private String ntoa(Long aton) {
        def ip = []
        ip.add(((aton >> 24) & 0xff))
        ip.add(((aton >> 16) & 0xff))
        ip.add(((aton >> 8) & 0xff))
        ip.add(aton & 0xff)

        return ip.join('.')
    }
}
