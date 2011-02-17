package eu.stderr.geotool
import com.vividsolutions.jts.geom.Polygon
import org.hibernatespatial.GeometryUserType

class Ip {
    Polygon polygon
    Country country
    Long start
    Long end

    static mapping = {
        version false
        polygon type: GeometryUserType
    }
    static constraints = {
    }

}
