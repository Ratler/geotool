package eu.stderr.geotool

import com.vividsolutions.jts.geom.Polygon
import org.hibernatespatial.GeometryUserType

class AsnIpv4 {
    Polygon polygon
    Long start
    Long end
    String asn
    String owner

    static mapping = {
        version false
        polygon type: GeometryUserType
    }

    static constraints = {
    }
}
