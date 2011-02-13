dataSource {
    pooled = true
    driverClassName = "org.hsqldb.jdbcDriver"
    username = "sa"
    password = ""
}
hibernate {
    cache.use_second_level_cache = true
    cache.use_query_cache = true
    cache.provider_class = 'net.sf.ehcache.hibernate.EhCacheProvider'
}
// environment specific settings
environments {
    development {
        dataSource {
            //pooled = true
            //driverClassName = "com.mysql.jdbc.Driver"
            //username = "geotool"
            //password = ""
            dbCreate = false
            jndiName = "java:comp/env/jdbc/geotool-dev"
        }
    }
    test {
        dataSource {
            dbCreate = "update"
            url = "jdbc:hsqldb:mem:testDb"
        }
    }
    production {
        dataSource {
            dbCreate = false
            jndiName = "java:comp/env/jdbc/geotool"
        }
    }
}
